-- =============================================================================
-- PASSO 4 — RODE NO PROJETO POLIWAYS (SQL Editor). Pode rodar mais de uma vez.
--
-- O portal passa a ter 8 turmas, 4 de Física e 4 de Matemática, e o aluno pode
-- estar matriculado em várias. Cada turma tem o próprio conteúdo.
--
-- Como funciona:
--   • matriculas          → em quais turmas o aluno está (a coordenação define).
--   • profiles.turma_id   → a turma ATIVA, a que o aluno está estudando agora.
--                           Todo o portal (questões, aulas, ranking...) mostra o
--                           conteúdo da turma ativa. O aluno troca pelo menu.
-- =============================================================================

-- 1) As 8 turmas. O slug precisa ser exatamente este (é o que o site usa).
insert into public.turmas (nome, slug)
select v.nome, v.slug
from (values
  ('Física · ENEM',                'fisica-enem'),
  ('Física · ENEM Medicina',       'fisica-enem-medicina'),
  ('Física · Escolas Militares',   'fisica-escolas-militares'),
  ('Clube da Física',              'fisica-clube'),
  ('Matemática · ENEM',            'matematica-enem'),
  ('Matemática · ENEM Medicina',   'matematica-enem-medicina'),
  ('Matemática · Escolas Militares','matematica-escolas-militares'),
  ('Clube da Matemática',          'matematica-clube')
) as v(nome, slug)
where not exists (select 1 from public.turmas t where t.slug = v.slug);

-- 2) Matrículas: um aluno, várias turmas.
create table if not exists public.matriculas (
  user_id   uuid not null references auth.users(id) on delete cascade,
  turma_id  uuid not null references public.turmas(id) on delete cascade,
  criado_em timestamptz not null default now(),
  primary key (user_id, turma_id)
);
create index if not exists idx_matriculas_turma on public.matriculas(turma_id);

alter table public.matriculas enable row level security;

drop policy if exists "matriculas: aluno ve as suas" on public.matriculas;
create policy "matriculas: aluno ve as suas" on public.matriculas
  for select to authenticated
  using (user_id = auth.uid());

drop policy if exists "matriculas: admin gerencia" on public.matriculas;
create policy "matriculas: admin gerencia" on public.matriculas
  for all to authenticated
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin))
  with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin));

grant select, insert, update, delete on public.matriculas to authenticated;

-- 3) A turma ativa sempre conta como matrícula (cadastro, convite, admin...).
create or replace function public.matricular_turma_ativa()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.turma_id is not null then
    insert into public.matriculas (user_id, turma_id)
    values (new.id, new.turma_id)
    on conflict do nothing;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_matricular_turma_ativa on public.profiles;
create trigger trg_matricular_turma_ativa
  after insert or update of turma_id on public.profiles
  for each row execute function public.matricular_turma_ativa();

-- 4) No cadastro, o aluno pode marcar várias turmas (metadado turmas_slugs).
--    Roda depois do gatilho que cria o perfil (os gatilhos rodam em ordem alfabética).
create or replace function public.matricular_turmas_do_cadastro()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if jsonb_typeof(new.raw_user_meta_data -> 'turmas_slugs') = 'array' then
    insert into public.matriculas (user_id, turma_id)
    select new.id, t.id
    from public.turmas t
    where t.slug in (select jsonb_array_elements_text(new.raw_user_meta_data -> 'turmas_slugs'))
    on conflict do nothing;
  end if;
  return new;
end;
$$;

drop trigger if exists on_auth_user_matriculas on auth.users;
create trigger on_auth_user_matriculas
  after insert on auth.users
  for each row execute function public.matricular_turmas_do_cadastro();

-- 5) O aluno troca a turma ativa (só entre as turmas em que está matriculado).
create or replace function public.trocar_turma_ativa(p_turma_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'Faça login.' using errcode = '42501';
  end if;
  if not exists (
    select 1 from public.matriculas m where m.user_id = auth.uid() and m.turma_id = p_turma_id
  ) and not exists (
    select 1 from public.profiles p where p.id = auth.uid() and p.is_admin
  ) then
    raise exception 'Você não está matriculado nesta turma.' using errcode = '42501';
  end if;
  update public.profiles set turma_id = p_turma_id where id = auth.uid();
end;
$$;

revoke all on function public.trocar_turma_ativa(uuid) from public, anon;
grant execute on function public.trocar_turma_ativa(uuid) to authenticated;

-- 6) Quem já existia ganha a matrícula da turma atual.
insert into public.matriculas (user_id, turma_id)
select p.id, p.turma_id from public.profiles p
where p.turma_id is not null
on conflict do nothing;

-- 7) Trilhas antigas (Medicina/ENEM e ITA/IME) saem. Quem estava nelas vai para
--    a turma equivalente de Física. Se alguma já tiver conteúdo cadastrado, ela fica
--    (e aparece um aviso abaixo) para nada ser perdido.
update public.profiles set turma_id = (select id from public.turmas where slug = 'fisica-enem-medicina')
where turma_id = (select id from public.turmas where slug = 'medicina-enem');
update public.profiles set turma_id = (select id from public.turmas where slug = 'fisica-escolas-militares')
where turma_id = (select id from public.turmas where slug = 'ita-ime');

do $$
declare v_slug text;
begin
  foreach v_slug in array array['medicina-enem', 'ita-ime'] loop
    begin
      delete from public.turmas where slug = v_slug;
    exception when foreign_key_violation then
      raise notice 'A turma antiga "%" tem conteúdo ligado a ela e foi mantida.', v_slug;
    end;
  end loop;
end $$;

notify pgrst, 'reload schema';
