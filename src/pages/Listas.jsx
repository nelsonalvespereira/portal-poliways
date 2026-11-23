import React from 'react';
import { Link } from 'react-router-dom';
import { ClipboardList, Loader2, ChevronRight } from 'lucide-react';
import Sidebar from './Sidebar';
import { useAuth } from '../hooks/useAuth';
import { useListas } from '../hooks/useListas';
import { turmaPorSlug } from '../config/cliente';

export default function Listas() {
  const { profile } = useAuth();
  const { listas, loading, erro } = useListas();
  const turmaNome = turmaPorSlug(profile?.turmas?.slug)?.nomeCompleto || profile?.turmas?.nome || '';

  return (
    <div className="flex h-screen bg-[#f3f4f6] font-sans overflow-hidden">
      <Sidebar />
      <main className="flex-1 flex flex-col h-screen overflow-hidden">
        <header className="h-16 bg-white border-b border-slate-200 px-4 md:px-8 flex items-center gap-3 shrink-0">
          <div className="w-9 h-9 bg-orange-50 text-brand-orange rounded-xl flex items-center justify-center shrink-0">
            <ClipboardList className="w-[18px] h-[18px]" />
          </div>
          <div>
            <h2 className="text-lg font-black text-slate-900 leading-tight">Listas de Exercícios</h2>
            <p className="text-xs font-medium text-slate-500">{turmaNome}</p>
          </div>
        </header>

        <div className="flex-1 overflow-y-auto p-4 md:p-8 pb-28 lg:pb-8">
          <div className="max-w-4xl mx-auto">
            {loading ? (
              <div className="flex items-center justify-center gap-2 text-slate-500 py-20">
                <Loader2 className="w-5 h-5 animate-spin" /> Carregando listas...
              </div>
            ) : erro ? (
              <p className="text-center text-red-600 py-20">Não foi possível carregar as listas.</p>
            ) : listas.length === 0 ? (
              <div className="text-center py-20">
                <ClipboardList className="w-10 h-10 text-slate-300 mx-auto mb-3" />
                <p className="font-bold text-slate-700">Ainda não há listas nesta turma.</p>
                <p className="text-sm text-slate-500 mt-1">Quando o professor publicar, elas aparecem aqui.</p>
              </div>
            ) : (
              <div className="grid sm:grid-cols-2 gap-4">
                {listas.map((l, i) => {
                  const pct = l.total ? Math.round((l.resolvidas / l.total) * 100) : 0;
                  return (
                    <Link
                      key={l.id}
                      to={`/listas/${l.id}`}
                      className="group bg-white border border-slate-200 hover:border-brand-orange rounded-3xl overflow-hidden transition-colors"
                    >
                      <div className="bg-gradient-to-r from-[#9D3A3B] to-[#E1333E] px-5 py-4 text-white">
                        <p className="text-[11px] font-black uppercase tracking-widest text-brand-yellow">
                          Lista {String(i + 1).padStart(2, '0')}
                        </p>
                        <h3 className="text-xl font-black leading-tight mt-0.5">{l.titulo}</h3>
                        {l.subtitulo && <p className="text-sm text-white/80 mt-0.5">{l.subtitulo}</p>}
                      </div>
                      <div className="h-1 bg-brand-yellow" />
                      <div className="p-5">
                        <div className="flex items-center justify-between text-sm mb-2">
                          <span className="font-bold text-slate-700">{l.resolvidas} de {l.total} resolvidas</span>
                          {l.resolvidas > 0 && <span className="text-slate-500">{l.acertos} acertos</span>}
                        </div>
                        <div className="h-2 bg-slate-100 rounded-full overflow-hidden">
                          <div className="h-full bg-brand-orange rounded-full" style={{ width: `${pct}%` }} />
                        </div>
                        <span className="mt-4 inline-flex items-center gap-1 text-sm font-black text-brand-orange">
                          {l.resolvidas === 0 ? 'Começar' : l.resolvidas === l.total ? 'Revisar' : 'Continuar'}
                          <ChevronRight className="w-4 h-4 group-hover:translate-x-0.5 transition-transform" />
                        </span>
                      </div>
                    </Link>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </main>
    </div>
  );
}
