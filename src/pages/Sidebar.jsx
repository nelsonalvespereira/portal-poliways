import React from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import {
  LayoutDashboard, FileText, ListOrdered, Target, PlayCircle, Radio, TrendingUp,
  Trophy, LogOut, Calendar, AlertCircle, Bookmark, ShoppingBag, ClipboardList,
  ShieldCheck,
} from 'lucide-react';
import BarraNavMobile from '../components/BarraNavMobile';
import { useAuth } from '../hooks/useAuth';
import { CLIENTE, RECURSOS } from '../config/cliente';
import Marca from '../components/Marca';
import SeletorTurma from '../components/SeletorTurma';

const NAV_ITEMS_SECONDARY = [
  { to: '/desempenho', label: 'Meu Desempenho', icon: TrendingUp },
  { to: '/ranking', label: 'Ranking', icon: Trophy },
  { to: '/plano-estudos', label: 'Plano de Estudos', icon: Calendar },
  { to: '/caderno-erros', label: 'Caderno de Erros', icon: AlertCircle },
  { to: '/favoritos', label: 'Favoritos', icon: Bookmark },
];

// Item ativo em vermelho sólido com o filete amarelo da marca à esquerda.
const navLinkClass = ({ isActive }) =>
  `relative flex items-center px-4 py-2.5 rounded-xl font-semibold text-sm transition-colors ${
    isActive
      ? 'bg-brand-orange text-white shadow-lg shadow-black/30 before:absolute before:left-0 before:top-2 before:bottom-2 before:w-1 before:rounded-r before:bg-brand-yellow'
      : 'text-neutral-400 hover:bg-white/5 hover:text-white'
  }`;

const rotuloSecao = 'px-4 text-[10px] font-black uppercase tracking-[0.18em] text-brand-yellow/80 mb-2';

// Atalhos fixos da barra do celular; o resto vai para a gaveta "Mais".
const BARRA_MOBILE = [
  { to: '/dashboard', label: 'Início', icon: LayoutDashboard, end: true },
  { to: '/banco-questoes', label: 'Questões', icon: FileText },
  { to: '/player', label: 'Aulas', icon: PlayCircle },
  ...(RECURSOS.packs ? [{ to: '/packs', label: 'Packs', icon: ShoppingBag, prefixos: ['/pack/'] }] : []),
];

// ocultarNoComputador: telas de "foco" (videoaula) escondem a barra lateral no computador
// para o conteúdo ganhar espaço. No celular a barra do rodapé continua aparecendo.
export default function Sidebar({ ocultarNoComputador = false }) {
  const navigate = useNavigate();
  const { profile, signOut } = useAuth();

  // A turma vem do perfil já carregado (profiles.turma_id -> turmas.slug / nome).
  const turma = `${profile?.turmas?.slug ?? ''} ${profile?.turmas?.nome ?? ''}`.toLowerCase();
  // A lista "Assuntos do ENEM" herdada é de Matemática; fica desligada até haver a lista das matérias do POLIWAYS.
  const isEnem = RECURSOS.assuntosEnem && turma.includes('enem');

  const sair = async () => {
    await signOut();
    navigate('/login');
  };

  // Tudo que não está na barra do rodapé vai para a gaveta "Mais".
  const maisItens = [
    { to: '/listas', label: 'Listas', icon: ClipboardList },
    { to: '/simulados', label: 'Simulados', icon: Target },
    { to: '/lives', label: 'Lives', icon: Radio },
    ...(isEnem ? [{ to: '/assuntos-enem', label: 'Assuntos do ENEM', icon: ListOrdered }] : []),
    ...NAV_ITEMS_SECONDARY,
    { to: '/termos', label: 'Termos e privacidade', icon: ShieldCheck },
  ];

  return (
    <>
    <BarraNavMobile itens={BARRA_MOBILE} maisItens={maisItens} onSair={sair} topo={<SeletorTurma />} />
    <aside className={`w-64 bg-brand-black flex-col hidden shrink-0 ${ocultarNoComputador ? '' : 'lg:flex'}`}>
      {/* Topo no estilo da capa institucional: faixa vermelha, filete amarelo */}
      <div className="bg-gradient-to-r from-[#9D3A3B] to-[#E1333E]">
        <div className="h-16 flex items-center px-5">
          <Marca tema="escuro" tamanho="sm" />
        </div>
        <div className="h-1 bg-brand-yellow" />
      </div>

      <SeletorTurma className="px-4 pt-5" />

      <nav className="flex-1 px-3 py-6 space-y-1 overflow-y-auto">
        <p className={rotuloSecao}>Estudar</p>

        <NavLink to="/dashboard" end className={navLinkClass}>
          <LayoutDashboard className="w-[18px] h-[18px] mr-3 shrink-0" />
          Dashboard
        </NavLink>

        <NavLink to="/banco-questoes" className={navLinkClass}>
          <FileText className="w-[18px] h-[18px] mr-3 shrink-0" />
          Banco de Questões
        </NavLink>

        {/* Aparece só para a turma do ENEM */}
        {isEnem && (
          <NavLink to="/assuntos-enem" className={navLinkClass}>
            <ListOrdered className="w-[18px] h-[18px] mr-3 shrink-0" />
            Assuntos do ENEM
          </NavLink>
        )}

        <NavLink to="/listas" className={navLinkClass}>
          <ClipboardList className="w-[18px] h-[18px] mr-3 shrink-0" />
          Listas de Exercícios
        </NavLink>

        <NavLink to="/simulados" className={navLinkClass}>
          <Target className="w-[18px] h-[18px] mr-3 shrink-0" />
          Simulados
        </NavLink>

        <NavLink to="/player" className={navLinkClass}>
          <PlayCircle className="w-[18px] h-[18px] mr-3 shrink-0" />
          Videoaulas
        </NavLink>

        <NavLink to="/lives" className={navLinkClass}>
          <Radio className="w-[18px] h-[18px] mr-3 shrink-0" />
          Lives
        </NavLink>

        {/* Loja de Packs: fica ativo também dentro de um pack (/pack/...) */}
        {RECURSOS.packs && (
          <NavLink
            to="/packs"
            className={({ isActive }) =>
              navLinkClass({ isActive: isActive || window.location.pathname.startsWith('/pack/') })
            }
          >
            <ShoppingBag className="w-[18px] h-[18px] mr-3 shrink-0" />
            Packs Avulsos
            <span className="ml-auto text-[10px] font-black uppercase tracking-wider px-1.5 py-0.5 rounded-md bg-brand-orange/15 text-brand-orangeLight">
              Novo
            </span>
          </NavLink>

        )}

        <p className={`${rotuloSecao} !mt-6`}>Acompanhamento</p>
        {NAV_ITEMS_SECONDARY.map(({ to, label, icon: Icon }) => (
          <NavLink key={to} to={to} className={navLinkClass}>
            <Icon className="w-[18px] h-[18px] mr-3 shrink-0" />
            {label}
          </NavLink>
        ))}
      </nav>

      <div className="p-3 border-t border-white/10 flex items-center gap-3">
        <div className="w-9 h-9 rounded-full bg-brand-orange text-white flex items-center justify-center font-black text-sm shrink-0">
          {(profile?.nome || '?').trim().charAt(0).toUpperCase()}
        </div>
        <div className="min-w-0 flex-1">
          <p className="text-sm font-bold text-white truncate">{(profile?.nome || 'Aluno').split(' ')[0]}</p>
          <p className="text-[11px] text-neutral-500 truncate">Aluno {CLIENTE.nome}</p>
        </div>
        <button
          onClick={sair}
          aria-label="Sair"
          title="Sair"
          className="p-2 text-neutral-400 hover:text-red-300 hover:bg-red-500/10 rounded-lg transition-colors cursor-pointer"
        >
          <LogOut className="w-4 h-4" />
        </button>
      </div>
    </aside>
    </>
  );
}
