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

No **projeto POLIWAYS** → SQL Editor → rode `3_ajustes_poliways.sql`.
Ele cria as trilhas (Medicina/ENEM e ITA/IME), o campo de turno (Turma A/B) e garante o bucket das imagens.

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
