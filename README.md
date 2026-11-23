# Plataforma POLIWAYS

Plataforma de estudos do POLIWAYS Knowledge Center (Palmas/TO): Física e Matemática.
React + Vite + Tailwind, com Supabase (banco, login e arquivos).

Feita a partir da plataforma base (Aritmática Gabaritando), com estas mudanças:

- Marca POLIWAYS: nome, cores (vermelho, amarelo e preto), logo, ícones do app e landing page nova.
- 8 turmas: Física e Matemática, cada uma com ENEM, ENEM Medicina, Escolas Militares e Clube. Cada turma tem o próprio conteúdo.
- O aluno pode estar matriculado em várias turmas e troca a turma ativa pelo menu (seletor "Turma ativa"). Turno do presencial (A/B) no perfil.
- Fórmulas matemáticas (LaTeX/KaTeX) em enunciados, alternativas e resoluções.
- Questões com banca, nível I–IV, figura grande e tabela; Listas de Exercícios (aluno em /listas, admin em /admin/listas).
- Matrícula feita na secretaria: o aluno se cadastra e a coordenação libera o acesso em Gestão de Alunos
  ("Liberar acesso"). Pagamento online e packs avulsos ficam desligados (veja `src/config/cliente.js`).

## Onde muda o quê

| O quê | Arquivo |
| --- | --- |
| Nome, logo, matérias e turmas, turnos, recursos ligados/desligados | `src/config/cliente.js` |
| Cores | `tailwind.config.js` |
| Dados legais (Termos e Privacidade) | `src/config/responsavel.js` |
| Banco de dados | `supabase/poliways/LEIA-ME.md` |

## Rodar no computador

```bash
npm install
copy .env.example .env.local   # e preencha com a URL e a chave do Supabase
npm run dev
```

## Fórmulas nas questões

No cadastro da questão, escreva a fórmula entre cifrões: `$v = \frac{\Delta s}{\Delta t}$`, `$H_2SO_4$`.
Para uma fórmula em destaque numa linha só: `$$ ... $$`. "R$ 10" continua aparecendo como dinheiro.
