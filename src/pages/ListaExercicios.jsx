import React, { useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeft, Loader2, CheckCircle2, XCircle, RotateCcw, MessageSquare, Star } from 'lucide-react';
import Sidebar from './Sidebar';
import RenderBlocos from '../components/RenderBlocos';
import TextoComFormulas from '../components/TextoComFormulas';
import ResolucaoProfessor from '../components/ResolucaoProfessor';
import { useAvisos } from '../components/Avisos';
import { useLista } from '../hooks/useListas';
import { responderQuestaoAvulsa, obterGabarito } from '../hooks/useQuestoes';
import { NIVEIS, nivelInfo } from '../lib/niveis';

function Estrelas({ n }) {
  return (
    <span className="inline-flex gap-0.5" aria-hidden="true">
      {Array.from({ length: n }).map((_, i) => <Star key={i} className="w-3.5 h-3.5" fill="currentColor" strokeWidth={0} />)}
    </span>
  );
}

// Uma questão da lista: escolhe, responde, vê na hora se acertou e a resolução.
function QuestaoDaLista({ numero, questao, respostaAnterior, onRespondida }) {
  const avisos = useAvisos();
  const [escolha, setEscolha] = useState(null);
  const [resultado, setResultado] = useState(null); // { correta, resposta_correta, comentario, video_resolucao_url }
  const [enviando, setEnviando] = useState(false);
  const [refazendo, setRefazendo] = useState(false);
  const [mostrarResolucao, setMostrarResolucao] = useState(false);
  const [carregandoGabarito, setCarregandoGabarito] = useState(false);

  // Já respondida antes (e o aluno não pediu para refazer): mostra a resposta dele.
  const respondidaAntes = respostaAnterior && !refazendo && !resultado;
  const marcada = resultado ? escolha : respondidaAntes ? respostaAnterior.alternativa : escolha;
  const certaLetra = resultado?.resposta_correta;
  const acertou = resultado ? resultado.correta : respondidaAntes ? respostaAnterior.correta : null;

  const responder = async () => {
    if (!escolha || enviando) return;
    setEnviando(true);
    const { resultado: r, error } = await responderQuestaoAvulsa(questao.id, escolha);
    setEnviando(false);
    if (error) { avisos.erro('Não foi possível registrar sua resposta. Tente de novo.'); return; }
    setResultado(r || { correta: false });
    setRefazendo(false);
    onRespondida(questao.id, escolha, !!r?.correta);
  };

  const verResolucaoAnterior = async () => {
    setCarregandoGabarito(true);
    const { gabarito } = await obterGabarito(questao.id);
    setCarregandoGabarito(false);
    if (gabarito) { setResultado({ ...gabarito, correta: respostaAnterior.correta }); setEscolha(respostaAnterior.alternativa); setMostrarResolucao(true); }
    else avisos.erro('A resolução ainda não está disponível.');
  };

  const refazer = () => { setRefazendo(true); setResultado(null); setEscolha(null); setMostrarResolucao(false); };

  const bloqueada = !!resultado || respondidaAntes;

  // Alternativas curtas (números, unidades) ou só figuras ficam lado a lado, como na lista impressa.
  const alternativas = questao.alternativas || [];
  const curta = (alt) => {
    if (alt.blocos?.length === 1 && alt.blocos[0].tipo === 'imagem') return true;
    const t = (alt.texto || '').replace(/\$|\\[a-z]+|[{}]/gi, '');
    return t.length <= 16;
  };
  const emGrade = alternativas.length > 0 && alternativas.every(curta);
  const colunas = alternativas.length === 4 ? 'sm:grid-cols-4' : 'sm:grid-cols-5';
  const estiloAlternativa = (letra) => {
    if (resultado && letra === certaLetra) return 'border-emerald-500 bg-emerald-50/70';
    if (bloqueada && letra === marcada) return acertou ? 'border-emerald-500 bg-emerald-50/70' : 'border-red-400 bg-red-50/70';
    if (letra === escolha) return 'border-brand-orange bg-orange-50/60';
    return 'border-slate-200 hover:border-slate-300 bg-white';
  };

  return (
    <article id={`q${numero}`} className="bg-white rounded-2xl border border-slate-200 overflow-hidden scroll-mt-4">
      <div className="p-4 md:p-6 select-none" onCopy={(e) => e.preventDefault()} onContextMenu={(e) => e.preventDefault()}>
        <div className="flex items-center gap-2 mb-2">
          <span className="inline-flex items-center justify-center min-w-7 h-6 px-1.5 rounded-md bg-brand-orange text-white text-xs font-black">
            {numero}
          </span>
          {questao.banca && questao.banca !== 'Inédita' && (
            <span className="text-sm font-black text-brand-orange">({questao.banca}{questao.ano ? ` ${questao.ano}` : ''})</span>
          )}
        </div>
        <div className="text-[15px] md:text-base text-slate-800 leading-relaxed md:text-justify">
          {questao.blocos_enunciado?.length ? (
            <RenderBlocos blocos={questao.blocos_enunciado} />
          ) : (
            <span className="whitespace-pre-wrap"><TextoComFormulas texto={questao.enunciado} /></span>
          )}
        </div>
        {questao.imagem_url && (
          <div className="my-3 text-center">
            <img src={questao.imagem_url} alt="Figura da questão" className="max-h-80 max-w-full w-auto inline-block" />
          </div>
        )}

        <div className={`mt-4 ${emGrade ? `grid grid-cols-2 ${colunas} gap-2` : 'space-y-2'}`}>
          {alternativas.map((alt) => (
            <button
              key={alt.letra}
              type="button"
              disabled={bloqueada}
              onClick={() => setEscolha(alt.letra)}
              className={`w-full flex items-center gap-3 p-3 rounded-xl border text-left transition-colors ${estiloAlternativa(alt.letra)} ${bloqueada ? 'cursor-default' : 'cursor-pointer'}`}
            >
              <span className={`w-7 h-7 rounded-lg flex items-center justify-center font-black text-xs shrink-0 ${
                alt.letra === marcada || (resultado && alt.letra === certaLetra) ? 'bg-brand-orange text-white' : 'bg-slate-100 text-slate-500'
              }`}>
                {alt.letra.toLowerCase()})
              </span>
              <span className="text-sm text-slate-700 flex-1">
                {alt.blocos?.length ? <RenderBlocos blocos={alt.blocos} imgHeight="h-10" /> : <TextoComFormulas texto={alt.texto} />}
              </span>
            </button>
          ))}
        </div>
      </div>

      <div className="bg-slate-50 border-t border-slate-100 px-4 md:px-6 py-3 flex flex-wrap items-center justify-between gap-2">
        <div className="text-sm font-bold">
          {acertou === true && <span className="inline-flex items-center gap-1.5 text-emerald-600"><CheckCircle2 className="w-4 h-4" /> Acertou</span>}
          {acertou === false && (
            <span className="inline-flex items-center gap-1.5 text-red-600">
              <XCircle className="w-4 h-4" /> Errou{certaLetra ? ` · resposta: ${certaLetra.toLowerCase()})` : ''}
            </span>
          )}
        </div>
        <div className="flex items-center gap-2">
          {resultado && (
            <button type="button" onClick={() => setMostrarResolucao((v) => !v)} className="inline-flex items-center gap-1.5 px-3 py-2 text-sm font-bold text-slate-600 hover:text-brand-orange">
              <MessageSquare className="w-4 h-4" /> Resolução
            </button>
          )}
          {respondidaAntes && (
            <button type="button" onClick={verResolucaoAnterior} disabled={carregandoGabarito} className="inline-flex items-center gap-1.5 px-3 py-2 text-sm font-bold text-slate-600 hover:text-brand-orange disabled:opacity-60">
              {carregandoGabarito ? <Loader2 className="w-4 h-4 animate-spin" /> : <MessageSquare className="w-4 h-4" />} Resolução
            </button>
          )}
          {bloqueada ? (
            <button type="button" onClick={refazer} className="inline-flex items-center gap-1.5 px-3 py-2 text-sm font-bold text-slate-600 hover:text-slate-900">
              <RotateCcw className="w-4 h-4" /> Refazer
            </button>
          ) : (
            <button
              type="button"
              onClick={responder}
              disabled={!escolha || enviando}
              className="px-5 py-2 bg-brand-orange hover:bg-brand-orangeHover disabled:bg-slate-300 text-white font-bold text-sm rounded-lg transition-colors"
            >
              {enviando ? 'Enviando…' : 'Responder'}
            </button>
          )}
        </div>
      </div>

      {resultado && mostrarResolucao && (
        <div className="px-4 md:px-6 py-5 bg-orange-50/60 border-t border-orange-100 select-none">
          {resultado.comentario || resultado.video_resolucao_url ? (
            <ResolucaoProfessor comentario={resultado.comentario} videoUrl={resultado.video_resolucao_url} />
          ) : (
            <p className="text-sm text-slate-600">O professor ainda não publicou a resolução desta questão.</p>
          )}
        </div>
      )}
    </article>
  );
}

export default function ListaExercicios() {
  const { id } = useParams();
  const { lista, questoes, respostas, loading, erro, registrar } = useLista(id);

  const total = questoes.length;
  const resolvidas = questoes.filter((q) => respostas[q.id]).length;
  const acertos = questoes.filter((q) => respostas[q.id]?.correta).length;

  // Agrupa por nível, mantendo a numeração corrida da lista.
  const numerada = questoes.map((q, i) => ({ q, numero: i + 1 }));
  const grupos = [
    ...NIVEIS.map((n) => ({ nivel: n, itens: numerada.filter(({ q }) => Number(q.nivel) === n.valor) })),
    { nivel: null, itens: numerada.filter(({ q }) => !nivelInfo(q.nivel)) },
  ].filter((g) => g.itens.length);

  return (
    <div className="flex h-screen bg-[#f3f4f6] font-sans overflow-hidden">
      <Sidebar />
      <main className="flex-1 flex flex-col h-screen overflow-hidden">
        <div className="flex-1 overflow-y-auto p-4 md:p-8 pb-28 lg:pb-10">
          <div className="max-w-3xl mx-auto space-y-5">
            <Link to="/listas" className="inline-flex items-center gap-1.5 text-sm font-bold text-slate-500 hover:text-slate-900">
              <ArrowLeft className="w-4 h-4" /> Listas
            </Link>

            {loading ? (
              <div className="flex items-center justify-center gap-2 text-slate-500 py-20">
                <Loader2 className="w-5 h-5 animate-spin" /> Carregando lista...
              </div>
            ) : erro || !lista ? (
              <p className="text-center text-slate-600 py-20">Lista não encontrada nesta turma.</p>
            ) : (
              <>
                {/* Cabeçalho no estilo da lista impressa */}
                <section className="rounded-3xl overflow-hidden bg-white border border-slate-200">
                  <div className="bg-gradient-to-r from-[#9D3A3B] to-[#E1333E] text-white px-5 md:px-7 py-5">
                    <p className="text-[11px] font-black uppercase tracking-widest text-brand-yellow">Lista de Exercícios</p>
                    <h1 className="text-2xl md:text-3xl font-black leading-tight mt-1">{lista.titulo}</h1>
                    {lista.subtitulo && <p className="text-white/85 mt-1">{lista.subtitulo}</p>}
                  </div>
                  <div className="h-1.5 bg-brand-yellow" />
                  <div className="px-5 md:px-7 py-4 grid grid-cols-3 gap-3 text-center">
                    <div><p className="text-2xl font-black text-slate-900">{total}</p><p className="text-xs text-slate-500">questões</p></div>
                    <div><p className="text-2xl font-black text-slate-900">{resolvidas}</p><p className="text-xs text-slate-500">resolvidas</p></div>
                    <div><p className="text-2xl font-black text-emerald-600">{acertos}</p><p className="text-xs text-slate-500">acertos</p></div>
                  </div>
                  {lista.descricao && (
                    <p className="px-5 md:px-7 pb-4 text-sm text-slate-600 whitespace-pre-line">
                      <TextoComFormulas texto={lista.descricao} />
                    </p>
                  )}
                  {/* Mapa das questões: verde acertou, vermelho errou, cinza ainda não fez */}
                  <nav aria-label="Ir para a questão" className="px-5 md:px-7 pb-5 flex flex-wrap gap-1.5">
                    {numerada.map(({ q, numero }) => {
                      const r = respostas[q.id];
                      return (
                        <a
                          key={q.id}
                          href={`#q${numero}`}
                          className={`w-8 h-8 rounded-lg text-xs font-black flex items-center justify-center transition-colors ${
                            !r ? 'bg-slate-100 text-slate-500 hover:bg-slate-200' : r.correta ? 'bg-emerald-500 text-white' : 'bg-red-500 text-white'
                          }`}
                        >
                          {numero}
                        </a>
                      );
                    })}
                  </nav>
                </section>

                {grupos.map((g) => (
                  <section key={g.nivel?.valor ?? 'sem'} className="space-y-4">
                    {g.nivel && (
                      <div className="flex items-center justify-between bg-white border-l-4 border-brand-orange rounded-r-xl px-4 py-2.5">
                        <h2 className="font-black text-brand-orange tracking-wide">NÍVEL {g.nivel.romano}</h2>
                        <span className="text-brand-orange"><Estrelas n={g.nivel.estrelas} /></span>
                      </div>
                    )}
                    {g.itens.map(({ q, numero }) => (
                      <QuestaoDaLista key={q.id} numero={numero} questao={q} respostaAnterior={respostas[q.id]} onRespondida={registrar} />
                    ))}
                  </section>
                ))}
              </>
            )}
          </div>
        </div>
      </main>
    </div>
  );
}
