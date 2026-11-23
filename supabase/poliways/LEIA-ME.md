# Banco de dados do POLIWAYS (Supabase novo)

O POLIWAYS usa um projeto Supabase **só dele**. A estrutura é copiada do projeto do Ari,
mas **nenhum dado** vai junto (questões, alunos e aulas do Ari ficam onde estão).

## 1. Criar o projeto

1. Em supabase.com, crie um projeto novo chamado `poliways`, região **South America (São Paulo)**.
2. Guarde a senha do banco num lugar seguro.

## 2. Copiar a estrutura do Ari

1. Abra o **projeto do Ari** → SQL Editor → cole o arquivo `1_exportar_estrutura_do_ari.sql` → Run.
   Ele só lê, não altera nada.
2. Aparece uma linha com a coluna `script`. Clique na célula e copie o conteúdo inteiro
   ("Copy cell content").
3. Abra o **projeto POLIWAYS** → SQL Editor → New query → cole → Run.
   Se der algum erro, nada é gravado; me mande a mensagem de erro.

## 3. Ajustes do POLIWAYS

No **projeto POLIWAYS** → SQL Editor → rode `3_ajustes_poliways.sql` e depois `4_turmas_por_materia.sql`.

- O 3 cria o campo de turno (Turma A/B) e garante o bucket das imagens.
- O 4 cria as 8 turmas (Física e Matemática: ENEM, ENEM Medicina, Escolas Militares e Clube)
  e as matrículas: o aluno pode estar em várias turmas e troca a turma ativa pelo menu.

### Listas de exercícios e a Lista 01

- `5_listas_e_niveis.sql`: nível I–IV nas questões e as tabelas de listas.
- `6_lista01_vetores.sql`: importa a Lista 01 (Vetores e Cinemática Vetorial, 45 questões, com gabarito)
  na turma Física · Escolas Militares. As figuras ficam no próprio site, em `public/listas/lista-01/`,
  então o site precisa estar publicado com essa pasta para as figuras aparecerem.

## 4. Login e e-mails

Em Authentication → URL Configuration:

- **Site URL**: o endereço do site na Vercel (ex.: `https://poliways.vercel.app`, ou o domínio próprio).
- **Redirect URLs**: o mesmo endereço com `/**` no final.

Em Authentication → Email Templates, troque o nome "Aritmática Gabaritando" por "POLIWAYS" nos textos.

## 5. Função de gestão de alunos

No terminal, dentro da pasta do projeto:

```bash
supabase login
supabase link --project-ref ID-DO-PROJETO-POLIWAYS
supabase functions deploy admin-gerenciar-aluno
```

As funções do Stripe (`criar-checkout-stripe`, `stripe-webhook`, `portal-cliente`, `create-checkout-session`)
**não** precisam ser publicadas: o pagamento online está desligado nesta plataforma.

## 6. Site na Vercel

1. Crie um projeto novo na Vercel apontando para a pasta/repositório `portal-poliways`.
2. Em Settings → Environment Variables, coloque `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY`
   do projeto POLIWAYS (Supabase → Project Settings → API).

## 7. Primeiro admin

1. Crie a sua conta pelo site (Entrar → Criar conta).
2. No SQL Editor do POLIWAYS, rode o bloco do final de `3_ajustes_poliways.sql`
   trocando pelo seu e-mail. Saia e entre de novo: você cai no painel admin.

Depois disso, cadastre os assuntos (Gerenciar Assuntos), os módulos e as questões de cada trilha.

## Importar lista em PDF (com IA)

Tela: **Admin → Listas de Exercícios → Importar PDF**. A IA (Claude) lê o PDF, monta as questões, recorta as figuras e lê o gabarito. O professor confere tudo antes de salvar; a lista é criada oculta.

A chave da Anthropic fica guardada no Supabase (nunca no site). Uma vez só, no terminal, dentro da pasta do projeto:

```bash
npx supabase login
npx supabase link --project-ref SEU_PROJECT_REF      # o código do projeto POLIWAYS (Settings → General)
npx supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
npx supabase functions deploy importar-lista-pdf
```

Opcional: `npx supabase secrets set ANTHROPIC_MODEL=claude-opus-5-5` para usar um modelo mais forte (custa o dobro). O padrão é `claude-sonnet-5-5`.

Custo: uma lista de 10 páginas sai por volta de US$ 0,50 (a tela mostra o custo de cada leitura).
