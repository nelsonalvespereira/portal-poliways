import React, { useEffect, useState } from 'react';
import { ChevronDown, Loader2 } from 'lucide-react';
import { supabase } from '../lib/supabaseClient';
import { useAuth } from '../hooks/useAuth';
import { TURMAS, turmaPorSlug } from '../config/cliente';

// Mostra a turma ativa do aluno e deixa trocar entre as turmas em que ele está matriculado.
// Todo o portal (questões, aulas, simulados, ranking) segue a turma ativa (profiles.turma_id).
// A troca passa pela função trocar_turma_ativa do banco, que confere a matrícula.
export default function SeletorTurma({ className = '' }) {
  const { profile } = useAuth();
  const [matriculas, setMatriculas] = useState([]);
  const [trocando, setTrocando] = useState(false);
  const [erro, setErro] = useState('');

  useEffect(() => {
    if (!profile?.id) return;
    let ativo = true;
    supabase
      .from('matriculas')
      .select('turma_id, turmas ( id, nome, slug )')
      .eq('user_id', profile.id)
      .then(({ data, error }) => {
        if (!ativo) return;
        if (error) { console.error('Erro ao carregar matrículas:', error); return; }
        // Mesma ordem da configuração (Física primeiro, depois Matemática).
        const ordem = (slug) => { const i = TURMAS.findIndex((t) => t.id === slug); return i === -1 ? 99 : i; };
        setMatriculas((data || []).filter((m) => m.turmas).sort((a, b) => ordem(a.turmas.slug) - ordem(b.turmas.slug)));
      });
    return () => { ativo = false; };
  }, [profile?.id]);

  if (!profile || profile.is_admin) return null;

  const nomeDe = (turma) => turmaPorSlug(turma?.slug)?.nomeCompleto || turma?.nome || 'Sem turma';
  const atual = profile.turmas;

  const trocar = async (turmaId) => {
    if (!turmaId || turmaId === profile.turma_id) return;
    setTrocando(true);
    setErro('');
    const { error } = await supabase.rpc('trocar_turma_ativa', { p_turma_id: turmaId });
    if (error) {
      setTrocando(false);
      setErro('Não foi possível trocar de turma.');
      return;
    }
    // Recarrega para todas as telas buscarem o conteúdo da nova turma.
    window.location.reload();
  };

  return (
    <div className={className}>
      <p className="px-1 mb-1.5 text-[10px] font-bold uppercase tracking-widest text-slate-400">Turma ativa</p>
      {matriculas.length > 1 ? (
        <label className="relative block">
          <span className="sr-only">Trocar de turma</span>
          <select
            value={profile.turma_id || ''}
            onChange={(e) => trocar(e.target.value)}
            disabled={trocando}
            className="w-full appearance-none rounded-xl bg-white/5 border border-white/10 hover:border-white/20 text-white text-sm font-bold py-2.5 pl-3 pr-9 focus:outline-none focus:ring-2 focus:ring-brand-yellow/60 disabled:opacity-60 cursor-pointer"
          >
            {!profile.turma_id && <option value="">Escolha uma turma</option>}
            {matriculas.map((m) => (
              <option key={m.turma_id} value={m.turma_id} className="text-slate-900">
                {nomeDe(m.turmas)}
              </option>
            ))}
          </select>
          {trocando
            ? <Loader2 className="w-4 h-4 text-brand-yellow animate-spin absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none" />
            : <ChevronDown className="w-4 h-4 text-slate-400 absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none" />}
        </label>
      ) : (
        <p className="rounded-xl bg-white/5 border border-white/10 text-white text-sm font-bold py-2.5 px-3">
          {nomeDe(atual)}
        </p>
      )}
      {erro && <p className="mt-1.5 px-1 text-xs text-red-300">{erro}</p>}
    </div>
  );
}
