import { useCallback, useEffect, useState } from 'react';
import { supabase } from '../lib/supabaseClient';

// Última resposta do aluno em cada questão: { [questao_id]: { alternativa, correta } }.
async function ultimasRespostas(questaoIds) {
  if (!questaoIds.length) return {};
  const { data, error } = await supabase
    .from('respostas_questoes')
    .select('questao_id, alternativa_escolhida, correta, respondido_em')
    .in('questao_id', questaoIds)
    .order('respondido_em', { ascending: true });
  if (error) { console.error('Erro ao buscar respostas:', error); return {}; }
  const mapa = {};
  (data || []).forEach((r) => {
    if (r.alternativa_escolhida === '__revisado__') return;
    mapa[r.questao_id] = { alternativa: r.alternativa_escolhida, correta: !!r.correta };
  });
  return mapa;
}

// Listas publicadas da turma ativa (a segurança do banco já filtra), com o progresso do aluno.
export function useListas() {
  const [listas, setListas] = useState([]);
  const [loading, setLoading] = useState(true);
  const [erro, setErro] = useState(null);

  useEffect(() => {
    let ativo = true;
    (async () => {
      setLoading(true);
      const { data, error } = await supabase
        .from('listas')
        .select('id, titulo, subtitulo, descricao, ordem, lista_questoes ( questao_id )')
        .order('ordem', { ascending: true })
        .order('created_at', { ascending: true });
      if (!ativo) return;
      if (error) { setErro(error); setLoading(false); return; }

      const todasIds = [...new Set((data || []).flatMap((l) => (l.lista_questoes || []).map((q) => q.questao_id)))];
      const respostas = await ultimasRespostas(todasIds);
      if (!ativo) return;

      setListas((data || []).map((l) => {
        const ids = (l.lista_questoes || []).map((q) => q.questao_id);
        const feitas = ids.filter((id) => respostas[id]);
        return {
          ...l,
          total: ids.length,
          resolvidas: feitas.length,
          acertos: feitas.filter((id) => respostas[id].correta).length,
        };
      }));
      setLoading(false);
    })();
    return () => { ativo = false; };
  }, []);

  return { listas, loading, erro };
}

// Uma lista com as questões em ordem e as respostas que o aluno já deu.
export function useLista(listaId) {
  const [lista, setLista] = useState(null);
  const [questoes, setQuestoes] = useState([]);
  const [respostas, setRespostas] = useState({});
  const [loading, setLoading] = useState(true);
  const [erro, setErro] = useState(null);

  const carregar = useCallback(async () => {
    if (!listaId) return;
    setLoading(true);
    const [{ data: l, error: e1 }, { data: itens, error: e2 }] = await Promise.all([
      supabase.from('listas').select('id, titulo, subtitulo, descricao, turmas ( nome, slug )').eq('id', listaId).maybeSingle(),
      supabase.from('lista_questoes').select('ordem, questoes (*)').eq('lista_id', listaId).order('ordem', { ascending: true }),
    ]);
    if (e1 || e2) { setErro(e1 || e2); setLoading(false); return; }
    const qs = (itens || []).map((i) => i.questoes).filter(Boolean);
    setLista(l);
    setQuestoes(qs);
    setRespostas(await ultimasRespostas(qs.map((q) => q.id)));
    setLoading(false);
  }, [listaId]);

  useEffect(() => { carregar(); }, [carregar]);

  const registrar = (questaoId, alternativa, correta) =>
    setRespostas((r) => ({ ...r, [questaoId]: { alternativa, correta } }));

  return { lista, questoes, respostas, loading, erro, registrar, recarregar: carregar };
}
