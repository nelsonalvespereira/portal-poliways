-- =============================================================================
-- PASSO 5 — RODE NO PROJETO POLIWAYS (SQL Editor). Pode rodar mais de uma vez.
--
-- • Nível da questão (I a IV, como nas listas do professor). A banca e o ano
--   já existiam (colunas banca e ano).
-- • Listas de exercícios: um conjunto ordenado de questões de uma turma
--   ("Lista 01 · Vetores e Cinemática Vetorial"). O aluno vê as listas da
--   turma ativa e resolve no portal, com correção na hora.
-- =============================================================================

-- 1) Nível I a IV
alter table public.questoes add column if not exists nivel smallint;
do $$ begin
  alter table public.questoes add constraint questoes_nivel_check check (nivel between 1 and 4);
exception when duplicate_object then null; end $$;
-- A tabela de questões herdada libera leitura coluna por coluna; a coluna nova precisa entrar.
grant select (nivel) on public.questoes to authenticated, anon;

-- 2) Listas
create table if not exists public.listas (
  id          uuid primary key default gen_random_uuid(),
  turma_id    uuid not null references public.turmas(id) on delete cascade,
  titulo      text not null,
  subtitulo   text,
  descricao   text,
  ordem       integer not null default 0,
  publicada   boolean not null default true,
  created_at  timestamptz not null default now()
);
create index if not exists idx_listas_turma on public.listas(turma_id, ordem);

-- 3) Questões de cada lista, em ordem. O tipo do id da questão é lido do banco
--    (pode ser número ou uuid, conforme a estrutura de origem).
do $$
declare v_tipo text;
begin
  select format_type(a.atttypid, a.atttypmod) into v_tipo
  from pg_attribute a
  where a.attrelid = 'public.questoes'::regclass and a.attname = 'id';

  execute format($f$
    create table if not exists public.lista_questoes (
      lista_id    uuid not null references public.listas(id) on delete cascade,
      questao_id  %s not null references public.questoes(id) on delete cascade,
      ordem       integer not null default 0,
      primary key (lista_id, questao_id)
    )$f$, v_tipo);
end $$;
create index if not exists idx_lista_questoes_ordem on public.lista_questoes(lista_id, ordem);

-- 4) Segurança
alter table public.listas enable row level security;
alter table public.lista_questoes enable row level security;

drop policy if exists "listas: aluno ve as da turma ativa" on public.listas;
create policy "listas: aluno ve as da turma ativa" on public.listas
  for select to authenticated
  using (
    publicada
    and turma_id = (select p.turma_id from public.profiles p where p.id = auth.uid())
  );

drop policy if exists "listas: admin gerencia" on public.listas;
create policy "listas: admin gerencia" on public.listas
  for all to authenticated
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin))
  with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin));

-- O aluno vê as questões das listas que ele pode ver (a política de listas filtra).
drop policy if exists "lista_questoes: aluno ve das listas visiveis" on public.lista_questoes;
create policy "lista_questoes: aluno ve das listas visiveis" on public.lista_questoes
  for select to authenticated
  using (exists (select 1 from public.listas l where l.id = lista_id));

drop policy if exists "lista_questoes: admin gerencia" on public.lista_questoes;
create policy "lista_questoes: admin gerencia" on public.lista_questoes
  for all to authenticated
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin))
  with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin));

grant select, insert, update, delete on public.listas, public.lista_questoes to authenticated;

notify pgrst, 'reload schema';
