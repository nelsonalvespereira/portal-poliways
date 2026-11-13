-- =============================================================================
-- PASSO 3 — RODE NO PROJETO NOVO (POLIWAYS), depois do script de estrutura.
-- Pode rodar mais de uma vez sem problema.
-- =============================================================================

-- 1) Trilhas (cada trilha é uma turma; o conteúdo fica separado por trilha).
--    O "slug" precisa ser exatamente este: é o que a landing e o cadastro enviam.
insert into public.turmas (nome, slug)
select 'Medicina / ENEM', 'medicina-enem'
where not exists (select 1 from public.turmas where slug = 'medicina-enem');

insert into public.turmas (nome, slug)
select 'ITA / IME', 'ita-ime'
where not exists (select 1 from public.turmas where slug = 'ita-ime');

-- 2) Turno do presencial: Turma A (manhã) ou Turma B (tarde). Definido pela coordenação.
alter table public.profiles add column if not exists turno text;
do $$ begin
  alter table public.profiles add constraint profiles_turno_check check (turno in ('A', 'B'));
exception when duplicate_object then null; end $$;

-- 3) A trava de colunas sensíveis passa a incluir o turno (só admin muda).
create or replace function public.proteger_colunas_acesso()
returns trigger
language plpgsql
as $$
declare
  v_old jsonb := to_jsonb(old);
  v_new jsonb := to_jsonb(new);
  v_col text;
  v_colunas text[] := array[
    'tipo_acesso', 'data_expiracao_pack', 'acesso_livre', 'is_admin', 'role',
    'turma_id', 'turno', 'xp', 'dias_seguidos', 'dias_estudados_semana'
  ];
begin
  if current_user in ('authenticated', 'anon') then
    foreach v_col in array v_colunas loop
      if (v_new -> v_col) is distinct from (v_old -> v_col) then
        if not exists (
          select 1 from public.profiles p where p.id = auth.uid() and p.is_admin
        ) then
          raise exception 'Sem permissão para alterar "%".', v_col using errcode = '42501';
        end if;
      end if;
    end loop;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_proteger_colunas_acesso on public.profiles;
create trigger trg_proteger_colunas_acesso
  before update on public.profiles
  for each row execute function public.proteger_colunas_acesso();

-- 4) Bucket das imagens das questões (se o script de estrutura já criou, nada muda).
insert into storage.buckets (id, name, public)
values ('questoes_imagens', 'questoes_imagens', true)
on conflict (id) do nothing;

notify pgrst, 'reload schema';

-- =============================================================================
-- PASSO 4 — DEPOIS de criar a sua conta pelo site, transforme-a em admin.
-- Troque o e-mail e rode só este bloco:
--
--   update public.profiles
--   set is_admin = true, acesso_livre = true
--   where id = (select id from auth.users where email = 'SEU-EMAIL-AQUI');
-- =============================================================================
