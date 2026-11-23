// Dados de quem responde legalmente pelo portal. Aparecem nos Termos de uso e na
// Política de privacidade. Campo vazio ('') simplesmente não aparece nos documentos.
//
// PARA PREENCHER quando o POLIWAYS mandar:
//   documento: 'CNPJ 12.345.678/0001-90'
//   endereco:  'Rua Tal, 100 - Bairro, Palmas/TO, CEP 77000-000'
//   cidadeForo: 'Palmas/TO'   (cidade do foro; se vazio, vale o domicílio do aluno)
//   email: e-mail de contato para assuntos de privacidade

export const RESPONSAVEL = {
  nome: 'POLIWAYS Knowledge Center',
  documento: '',
  endereco: '',
  cidadeForo: 'Palmas/TO',
  email: '',
};

export const NOME_PLATAFORMA = 'POLIWAYS Knowledge Center';

// Mude esta data sempre que alterar o texto dos Termos ou da Privacidade.
// Ela fica gravada na conta de quem aceitou no cadastro.
export const TERMOS_VERSAO = '2026-11-11';
