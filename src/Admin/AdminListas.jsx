import React, { useCallback, useEffect, useState } from 'react';
import { ClipboardList, Plus, Trash2, ArrowUp, ArrowDown, Eye, EyeOff, Loader2, Search, ChevronDown, ChevronRight, Sparkles } from 'lucide-react';
import { Link } from 'react-router-dom';
import AdminSidebar from './AdminSidebar';
import { useTurmas } from '../hooks/useAdmin';
import { supabase } from '../lib/supabaseClient';
import { useAvisos } from '../components/Avisos';
import SeloNivel from '../components/SeloNivel';
import { TURMAS } from '../config/cliente';

const ordemTurma = (slug) => { const i = TURMAS.findIndex((t) => t.id === slug); return i === -1 ? 99 : i; };
const resumo = (q) => (q.enunciado || '').replace(/\s+/g, ' ').slice(0, 110);

// Questões de uma lista: reordenar, tirar e adicionar do banco da turma.
function EditorQuestoesDaLista({ lista, turmaId, onMudou }) {
  const avisos = useAvisos();
  const [itens, setItens] = useState([]);
  const [loading, setLoading] = useState(true);
  const [busca, setBusca] = useState('');
  const [resultados, setResultados] = useState([]);
  const [buscando, setBuscando] = useState(false);

  const carregar = useCallback(async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from('lista_questoes')
      .select('questao_id, ordem, questoes ( id, enunciado, banca, ano, nivel )')
      .eq('lista_id', lista.id)
      .order('ordem', { ascending: true });
    if (error) avisos.erro('Erro ao carregar as questões da lista.');
    setItens((data || []).filter((i) => i.questoes));
    setLoading(false);
  }, [lista.id, avisos]);

  useEffect(() => { carregar(); }, [carregar]);

  const salvarOrdem = async (novos) => {
    setItens(novos);
    const { error } = await supabase
      .from('lista_questoes')
      .upsert(novos.map((it, i) => ({ lista_id: lista.id, questao_id: it.questao_id, ordem: i + 1 })), { onConflict: 'lista_id,questao_id' });
    if (error) { avisos.erro('Erro ao salvar a ordem.'); carregar(); }
  };

  const mover = (i, d) => {
    const j = i + d;
    if (j < 0 || j >= itens.length) return;
    const novos = [...itens];
    [novos[i], novos[j]] = [novos[j], novos[i]];
    salvarOrdem(novos);
  };

  const tirar = async (questaoId) => {
    const { error } = await supabase.from('lista_questoes').delete().eq('lista_id', lista.id).eq('questao_id', questaoId);
    if (error) return avisos.erro('Erro ao tirar a questão.');
    const novos = itens.filter((i) => i.questao_id !== questaoId);
    await salvarOrdem(novos);
    onMudou?.();
  };

  const buscar = async (e) => {
    e?.preventDefault();
    setBuscando(true);
    let q = supabase.from('questoes').select('id, enunciado, banca, ano, nivel').eq('turma_id', turmaId).order('created_at', { ascending: false }).limit(30);
    if (busca.trim()) q = q.ilike('enunciado', `%${busca.trim()}%`);
    const { data, error } = await q;
    setBuscando(false);
    if (error) return avisos.erro('Erro ao buscar questões.');
    setResultados(data || []);
  };

  const adicionar = async (questao) => {
    const { error } = await supabase.from('lista_questoes').insert({ lista_id: lista.id, questao_id: questao.id, ordem: itens.length + 1 });
    if (error) return avisos.erro(error.code === '23505' ? 'Essa questão já está na lista.' : 'Erro ao adicionar a questão.');
    await carregar();
    onMudou?.();
  };

  const naLista = new Set(itens.map((i) => i.questao_id));

  return (
    <div className="border-t border-slate-100 p-4 md:p-5 space-y-5">
      <div>
        <p className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Questões da lista ({itens.length})</p>
        {loading ? (
          <p className="text-sm text-slate-500 flex items-center gap-2"><Loader2 className="w-4 h-4 animate-spin" /> Carregando…</p>
        ) : itens.length === 0 ? (
          <p className="text-sm text-slate-500">Nenhuma questão ainda. Busque abaixo e adicione.</p>
        ) : (
          <ol className="space-y-1.5">
            {itens.map((it, i) => (
              <li key={it.questao_id} className="flex items-center gap-2 bg-slate-50 border border-slate-200 rounded-lg px-3 py-2">
                <span className="w-7 h-6 rounded-md bg-brand-orange text-white text-xs font-black flex items-center justify-center shrink-0">{i + 1}</span>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-1.5 flex-wrap">
                    <SeloNivel nivel={it.questoes.nivel} className="!py-0.5" />
                    {it.questoes.banca && <span className="text-xs font-bold text-slate-500">{it.questoes.banca}</span>}
                  </div>
                  <p className="text-sm text-slate-700 truncate">{resumo(it.questoes)}</p>
                </div>
                <button type="button" onClick={() => mover(i, -1)} disabled={i === 0} className="p-1 text-slate-400 hover:text-slate-700 disabled:opacity-30" aria-label="Subir"><ArrowUp className="w-4 h-4" /></button>
                <button type="button" onClick={() => mover(i, 1)} disabled={i === itens.length - 1} className="p-1 text-slate-400 hover:text-slate-700 disabled:opacity-30" aria-label="Descer"><ArrowDown className="w-4 h-4" /></button>
                <button type="button" onClick={() => tirar(it.questao_id)} className="p-1 text-red-400 hover:text-red-600" aria-label="Tirar da lista"><Trash2 className="w-4 h-4" /></button>
              </li>
            ))}
          </ol>
        )}
      </div>

      <div>
        <p className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Adicionar questões desta turma</p>
        <form onSubmit={buscar} className="flex gap-2">
          <div className="relative flex-1">
            <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input value={busca} onChange={(e) => setBusca(e.target.value)} placeholder="Buscar no enunciado (vazio = mais recentes)" className="w-full pl-9 pr-3 py-2 text-sm bg-white border border-slate-200 rounded-lg outline-none focus:border-brand-orange" />
          </div>
          <button type="submit" className="px-4 py-2 bg-slate-900 hover:bg-slate-800 text-white text-sm font-bold rounded-lg">
            {buscando ? <Loader2 className="w-4 h-4 animate-spin" /> : 'Buscar'}
          </button>
        </form>
        {resultados.length > 0 && (
          <ul className="mt-2 space-y-1.5 max-h-80 overflow-y-auto">
            {resultados.map((q) => (
              <li key={q.id} className="flex items-center gap-2 border border-slate-200 rounded-lg px-3 py-2">
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-1.5 flex-wrap">
                    <SeloNivel nivel={q.nivel} className="!py-0.5" />
                    {q.banca && <span className="text-xs font-bold text-slate-500">{q.banca}</span>}
                  </div>
                  <p className="text-sm text-slate-700 truncate">{resumo(q)}</p>
                </div>
                <button
                  type="button"
                  disabled={naLista.has(q.id)}
                  onClick={() => adicionar(q)}
                  className="px-3 py-1.5 text-xs font-bold rounded-lg bg-orange-50 text-brand-orange hover:bg-orange-100 disabled:bg-slate-100 disabled:text-slate-400"
                >
                  {naLista.has(q.id) ? 'Na lista' : '+ Adicionar'}
                </button>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

export default function AdminListas() {
  const avisos = useAvisos();
  const { turmas: turmasBrutas } = useTurmas();
  const turmas = [...turmasBrutas].sort((a, b) => ordemTurma(a.slug) - ordemTurma(b.slug));
  const [turmaId, setTurmaId] = useState('');
  const [listas, setListas] = useState([]);
  const [loading, setLoading] = useState(false);
  const [aberta, setAberta] = useState(null);
  const [nova, setNova] = useState({ titulo: '', subtitulo: '' });
  const [criando, setCriando] = useState(false);

  useEffect(() => { if (!turmaId && turmas.length) setTurmaId(turmas[0].id); }, [turmas, turmaId]);

  const carregar = useCallback(async () => {
    if (!turmaId) return;
    setLoading(true);
    const { data, error } = await supabase
      .from('listas')
      .select('id, titulo, subtitulo, descricao, ordem, publicada, lista_questoes ( count )')
      .eq('turma_id', turmaId)
      .order('ordem', { ascending: true })
      .order('created_at', { ascending: true });
    if (error) avisos.erro('Erro ao carregar as listas. O script 5_listas_e_niveis.sql já foi rodado?');
    setListas(data || []);
    setLoading(false);
  }, [turmaId, avisos]);

  useEffect(() => { carregar(); }, [carregar]);

  const criar = async (e) => {
    e.preventDefault();
    if (!nova.titulo.trim()) return;
    setCriando(true);
    const { error } = await supabase.from('listas').insert({
      turma_id: turmaId,
      titulo: nova.titulo.trim(),
      subtitulo: nova.subtitulo.trim() || null,
      ordem: listas.length + 1,
    });
    setCriando(false);
    if (error) return avisos.erro('Erro ao criar a lista.');
    setNova({ titulo: '', subtitulo: '' });
    carregar();
  };

  const alternarPublicada = async (l) => {
    const { error } = await supabase.from('listas').update({ publicada: !l.publicada }).eq('id', l.id);
    if (error) return avisos.erro('Erro ao atualizar.');
    carregar();
  };

  const excluir = async (l) => {
    if (!(await avisos.confirmar({ titulo: 'Excluir lista?', mensagem: `A lista "${l.titulo}" sai do portal. As questões continuam no banco.`, confirmarTexto: 'Excluir', perigo: true }))) return;
    const { error } = await supabase.from('listas').delete().eq('id', l.id);
    if (error) return avisos.erro('Erro ao excluir.');
    carregar();
  };

  return (
    <div className="min-h-screen bg-slate-50 flex font-sans">
      <AdminSidebar />
      <main className="flex-1 h-screen overflow-y-auto">
        <header className="h-16 bg-white border-b border-slate-200 px-6 md:px-8 flex items-center gap-3 sticky top-0 z-10">
          <div className="w-9 h-9 bg-orange-50 text-brand-orange rounded-xl flex items-center justify-center shrink-0">
            <ClipboardList className="w-[18px] h-[18px]" />
          </div>
          <div>
            <h2 className="text-lg font-black text-slate-900 leading-tight">Listas de Exercícios</h2>
            <p className="text-xs font-medium text-slate-500">Monte listas com questões do banco de cada turma</p>
          </div>
          <Link to="/admin/listas/importar" className="ml-auto inline-flex items-center gap-1.5 px-4 py-2 bg-brand-orange hover:bg-brand-orangeHover text-white text-sm font-bold rounded-lg">
            <Sparkles className="w-4 h-4" /> <span className="hidden sm:inline">Importar</span> PDF
          </Link>
        </header>

        <div className="p-6 md:p-8 max-w-4xl space-y-6">
          <label className="block">
            <span className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Turma</span>
            <select value={turmaId} onChange={(e) => { setTurmaId(e.target.value); setAberta(null); }} className="w-full md:w-96 bg-white border border-slate-200 rounded-xl py-2.5 px-4 text-sm font-medium focus:outline-none focus:ring-1 focus:ring-brand-orange">
              {turmas.map((t) => <option key={t.id} value={t.id}>{t.nome}</option>)}
            </select>
          </label>

          <form onSubmit={criar} className="bg-white border border-slate-200 rounded-2xl p-4 md:p-5 grid md:grid-cols-[1fr_1fr_auto] gap-3 items-end">
            <label className="block">
              <span className="block text-xs font-bold text-slate-700 mb-1">Título</span>
              <input value={nova.titulo} onChange={(e) => setNova({ ...nova, titulo: e.target.value })} placeholder="Vetores e Cinemática Vetorial" className="w-full px-3 py-2 text-sm bg-slate-50 border border-slate-200 rounded-lg outline-none focus:border-brand-orange" />
            </label>
            <label className="block">
              <span className="block text-xs font-bold text-slate-700 mb-1">Subtítulo (opcional)</span>
              <input value={nova.subtitulo} onChange={(e) => setNova({ ...nova, subtitulo: e.target.value })} placeholder="Questões de escolas militares e vestibulares" className="w-full px-3 py-2 text-sm bg-slate-50 border border-slate-200 rounded-lg outline-none focus:border-brand-orange" />
            </label>
            <button type="submit" disabled={criando || !nova.titulo.trim()} className="inline-flex items-center justify-center gap-1.5 px-4 py-2 bg-brand-orange hover:bg-brand-orangeHover disabled:bg-slate-300 text-white text-sm font-bold rounded-lg">
              <Plus className="w-4 h-4" /> Criar lista
            </button>
          </form>

          {loading ? (
            <p className="text-sm text-slate-500 flex items-center gap-2"><Loader2 className="w-4 h-4 animate-spin" /> Carregando…</p>
          ) : listas.length === 0 ? (
            <p className="text-sm text-slate-500">Nenhuma lista nesta turma ainda.</p>
          ) : (
            <div className="space-y-3">
              {listas.map((l, i) => (
                <div key={l.id} className="bg-white border border-slate-200 rounded-2xl overflow-hidden">
                  <div className="flex items-center gap-3 p-4">
                    <button type="button" onClick={() => setAberta(aberta === l.id ? null : l.id)} className="flex items-center gap-3 flex-1 min-w-0 text-left">
                      {aberta === l.id ? <ChevronDown className="w-4 h-4 text-slate-400 shrink-0" /> : <ChevronRight className="w-4 h-4 text-slate-400 shrink-0" />}
                      <span className="text-xs font-black text-brand-orange shrink-0">Lista {String(i + 1).padStart(2, '0')}</span>
                      <span className="min-w-0">
                        <span className="block font-bold text-slate-900 truncate">{l.titulo}</span>
                        <span className="block text-xs text-slate-500">{l.lista_questoes?.[0]?.count ?? 0} questões{l.publicada ? '' : ' · oculta para os alunos'}</span>
                      </span>
                    </button>
                    <button type="button" onClick={() => alternarPublicada(l)} title={l.publicada ? 'Ocultar dos alunos' : 'Publicar para os alunos'} className={`p-2 rounded-lg ${l.publicada ? 'text-emerald-600 hover:bg-emerald-50' : 'text-slate-400 hover:bg-slate-100'}`}>
                      {l.publicada ? <Eye className="w-4 h-4" /> : <EyeOff className="w-4 h-4" />}
                    </button>
                    <button type="button" onClick={() => excluir(l)} title="Excluir lista" className="p-2 rounded-lg text-red-400 hover:bg-red-50 hover:text-red-600">
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                  {aberta === l.id && <EditorQuestoesDaLista lista={l} turmaId={turmaId} onMudou={carregar} />}
                </div>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
