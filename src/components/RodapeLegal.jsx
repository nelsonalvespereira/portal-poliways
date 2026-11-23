import React from 'react';
import { Link } from 'react-router-dom';
import { NOME_PLATAFORMA, RESPONSAVEL } from '../config/responsavel';

// Rodapé com os dados de quem vende (Decreto 7.962/2013 — comércio eletrônico):
// nome, CPF/CNPJ, endereço e e-mail, mais os links de Termos e Privacidade.
// Os dados vêm de src/config/responsavel.js; campo vazio simplesmente não aparece.
// escuro = true nas telas de fundo escuro (pagamento).
export default function RodapeLegal({ escuro = false, responsavel = RESPONSAVEL, className = '' }) {
  const linha = [responsavel.nome !== NOME_PLATAFORMA ? responsavel.nome : '', responsavel.documento, responsavel.endereco].filter(Boolean);
  const fraco = escuro ? 'text-slate-400' : 'text-slate-600';
  const link = escuro ? 'text-slate-300 hover:text-white' : 'text-slate-600 hover:text-slate-900';

  return (
    <footer className={`py-8 px-6 text-center text-xs font-medium leading-relaxed ${fraco} ${className}`}>
      <p>
        © {new Date().getFullYear()} {NOME_PLATAFORMA}
        {linha.length > 0 && <> · {linha.join(' · ')}</>}
      </p>
      <p className="mt-1.5 flex flex-wrap items-center justify-center gap-x-3 gap-y-1">
        {responsavel.email && (
          <a href={`mailto:${responsavel.email}`} className={`${link} underline-offset-2 hover:underline break-all`}>
            {responsavel.email}
          </a>
        )}
        <Link to="/termos" className={`${link} underline-offset-2 hover:underline`}>Termos de uso</Link>
        <Link to="/privacidade" className={`${link} underline-offset-2 hover:underline`}>Política de privacidade</Link>
      </p>
    </footer>
  );
}
