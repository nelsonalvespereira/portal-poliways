// Níveis das listas do POLIWAYS (I a IV) e a dificuldade equivalente usada nos filtros antigos.
export const NIVEIS = [
  { valor: 1, romano: 'I', estrelas: 1, dificuldade: 'facil' },
  { valor: 2, romano: 'II', estrelas: 2, dificuldade: 'medio' },
  { valor: 3, romano: 'III', estrelas: 3, dificuldade: 'dificil' },
  { valor: 4, romano: 'IV', estrelas: 4, dificuldade: 'dificil' },
];

export const nivelInfo = (n) => NIVEIS.find((x) => x.valor === Number(n)) || null;
