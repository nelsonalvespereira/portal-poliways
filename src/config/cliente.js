// Identidade e recursos do cliente desta instalação (POLIWAYS Knowledge Center).
// Tudo que muda de um cliente para outro fica aqui, para o resto do código não
// precisar saber de quem é a plataforma.

import logo from '../assets/logo-poliways.png';

export const CLIENTE = {
  nome: 'POLIWAYS',
  nomeCompleto: 'POLIWAYS Knowledge Center',
  complemento: 'KNOWLEDGE CENTER',
  cidade: 'Palmas (TO)',
  professor: 'Prof. Paulo Prado',
  professorCurto: 'Paulo',
  logo,
};

// Matérias e turmas. Cada turma é uma linha da tabela turmas (o id é o slug) e tem o
// próprio conteúdo. O aluno pode estar matriculado em várias e troca a turma ativa pelo menu.
// Os slugs precisam bater com supabase/poliways/4_turmas_por_materia.sql.
export const MATERIAS = [
  {
    id: 'fisica',
    nome: 'Física',
    descricao: 'Da base do ENEM aos problemas de alta complexidade das escolas militares.',
    turmas: [
      { id: 'fisica-enem', nome: 'ENEM', descricao: 'Física para o ENEM, do básico às questões mais cobradas.' },
      { id: 'fisica-enem-medicina', nome: 'ENEM Medicina', descricao: 'Física para quem precisa de nota alta para Medicina.' },
      { id: 'fisica-escolas-militares', nome: 'Escolas Militares', descricao: 'ITA, IME, AFA, Escola Naval e EsPCEx.' },
      { id: 'fisica-clube', nome: 'Clube da Física', descricao: 'Aprofundamento e desafios para quem gosta de Física.' },
    ],
  },
  {
    id: 'matematica',
    nome: 'Matemática',
    descricao: 'Raciocínio, técnica e treino para as provas mais concorridas.',
    turmas: [
      { id: 'matematica-enem', nome: 'ENEM', descricao: 'Matemática para o ENEM, do básico às questões mais cobradas.' },
      { id: 'matematica-enem-medicina', nome: 'ENEM Medicina', descricao: 'Matemática para quem precisa de nota alta para Medicina.' },
      { id: 'matematica-escolas-militares', nome: 'Escolas Militares', descricao: 'ITA, IME, AFA, Escola Naval e EsPCEx.' },
      { id: 'matematica-clube', nome: 'Clube da Matemática', descricao: 'Aprofundamento e desafios para quem gosta de Matemática.' },
    ],
  },
];

// Lista única de turmas, com a matéria junto: { id, nome, descricao, materia, materiaNome, nomeCompleto }.
export const TURMAS = MATERIAS.flatMap((m) =>
  m.turmas.map((t) => ({
    ...t,
    materia: m.id,
    materiaNome: m.nome,
    nomeCompleto: t.nome.startsWith('Clube') ? t.nome : `${m.nome} · ${t.nome}`,
  }))
);

export const turmaPorSlug = (slug) => TURMAS.find((t) => t.id === slug);

// Turnos do presencial (Turma A de manhã, Turma B à tarde). Fica no perfil do aluno.
export const TURNOS = [
  { id: 'A', nome: 'Turma A', horario: 'Manhã · 8h00–12h20' },
  { id: 'B', nome: 'Turma B', horario: 'Tarde · 14h00–18h20' },
];

// Liga/desliga partes herdadas da plataforma base.
// pagamentoOnline: false → a matrícula é feita na secretaria e a coordenação libera o acesso.
// packs: false → esconde a loja de packs avulsos.
// assuntosEnem: false → esconde a página "Assuntos que mais caem no ENEM" (lista herdada, só de Matemática).
export const RECURSOS = {
  pagamentoOnline: false,
  packs: false,
  assuntosEnem: false,
};
