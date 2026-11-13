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

// Trilhas = turmas do banco (tabela turmas). O id é o slug da turma.
// O conteúdo (questões, aulas, simulados) é separado por trilha.
export const TRILHAS = [
  {
    id: 'medicina-enem',
    titulo: 'Medicina / ENEM',
    materias: 'Física, Química, Biologia e Produção Textual',
    descricao: 'Alto desempenho nas provas de maior concorrência, com foco em Medicina.',
  },
  {
    id: 'ita-ime',
    titulo: 'ITA / IME',
    materias: 'Física, Matemática e Produção Textual em nível avançado',
    descricao: 'Raciocínio lógico e problemas de alta complexidade para as carreiras militares de engenharia.',
  },
];

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
