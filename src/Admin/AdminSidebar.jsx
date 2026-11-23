import React from 'react';
import { NavLink } from 'react-router-dom';
import { RECURSOS } from '../config/cliente';
import Marca from '../components/Marca';
import { LayoutDashboard, Users, FileQuestion, Video, Calendar, Settings, FolderTree, Package, ClipboardList } from 'lucide-react';

const NAV_ITEMS = [
  { to: '/admin', label: 'Visão Geral', icon: LayoutDashboard, end: true },
  { to: '/admin/alunos', label: 'Gestão de Alunos', icon: Users },
  { to: '/admin/simulados-questoes', label: 'Simulados e Questões', icon: FileQuestion },
  { to: '/admin/listas', label: 'Listas de Exercícios', icon: ClipboardList },
  { to: '/admin/assuntos', label: 'Gerenciar Assuntos', icon: FolderTree },
  { to: '/admin/modulos', label: 'Módulos e Aulas', icon: Video },
  { to: '/admin/aulas-lives', label: 'Aulas e Lives', icon: Video },
  { to: '/admin/cronograma', label: 'Plano de Estudos', icon: Calendar },
  ...(RECURSOS.packs ? [{ to: '/admin/pack', label: 'Pack Avulso', icon: Package }] : []),
];

const navLinkClass = ({ isActive }) =>
  `flex items-center px-4 py-2.5 rounded-xl font-semibold text-sm transition-colors ${
    isActive
      ? 'bg-brand-orange text-white'
      : 'text-neutral-400 hover:bg-white/5 hover:text-white'
  }`;

export default function AdminSidebar() {
  return (
    <aside className="w-64 bg-brand-black flex-col hidden lg:flex shrink-0">
      <div className="bg-gradient-to-r from-[#9D3A3B] to-[#E1333E]">
        <div className="h-16 flex items-center justify-between px-5">
          <Marca tema="escuro" tamanho="sm" />
          <span className="text-[10px] font-black uppercase tracking-widest bg-black/30 text-brand-yellow px-2 py-1 rounded-md">Admin</span>
        </div>
        <div className="h-1 bg-brand-yellow" />
      </div>

      <nav className="flex-1 px-3 py-6 space-y-1 overflow-y-auto">
        {NAV_ITEMS.map(({ to, label, icon: Icon, end }) => (
          <NavLink key={to} to={to} end={end} className={navLinkClass}>
            <Icon className="w-4.5 h-4.5 mr-3 shrink-0" />
            {label}
          </NavLink>
        ))}
      </nav>

      <div className="p-3 border-t border-slate-700/50">
        <NavLink to="/admin/configuracoes" className={navLinkClass}>
          <Settings className="w-4.5 h-4.5 mr-3 shrink-0" /> Configurações
        </NavLink>
      </div>
    </aside>
  );
}