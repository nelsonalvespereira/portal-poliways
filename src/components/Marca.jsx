import React from 'react';
import { CLIENTE } from '../config/cliente';

// Logo + nome da instituição. tema 'escuro' para fundos pretos, 'claro' para fundos brancos.
export default function Marca({ tema = 'escuro', tamanho = 'md', className = '' }) {
  const alturaLogo = { sm: 'h-8', md: 'h-10', lg: 'h-14' }[tamanho];
  const nome = tema === 'escuro' ? 'text-white' : 'text-slate-900';
  const sub = tema === 'escuro' ? 'text-brand-yellow' : 'text-brand-orange';
  return (
    <span className={`flex items-center gap-2.5 ${className}`}>
      <img src={CLIENTE.logo} alt={CLIENTE.nome} className={`${alturaLogo} w-auto object-contain shrink-0`} />
      <span className="flex flex-col leading-none">
        <span className={`text-sm font-black tracking-wide ${nome}`}>{CLIENTE.nome}</span>
        <span className={`text-[9px] font-black tracking-[0.18em] mt-1 ${sub}`}>{CLIENTE.complemento}</span>
      </span>
    </span>
  );
}
