// Importação de listas em PDF: tudo que acontece no navegador.
//  1. Abre o PDF com pdf.js e desenha cada página num canvas (alta resolução, para recortar figuras).
//  2. Gera uma cópia de cada página com uma grade de coordenadas por cima (0–100%), que vai para a IA.
//  3. Manda as páginas em lotes para a função importar-lista-pdf (2 páginas + a seguinte como contexto).
//  4. Junta as respostas: questões, níveis, gabarito.
//  5. Recorta as figuras das páginas nas regiões que a IA indicou (o admin pode ajustar na revisão).

import * as pdfjsLib from 'pdfjs-dist';
import workerUrl from 'pdfjs-dist/build/pdf.worker.min.mjs?url';
import { supabase } from './supabaseClient';

pdfjsLib.GlobalWorkerOptions.workerSrc = workerUrl;

const ESCALA_RECORTE = 3; // ~216 dpi: figuras nítidas
const LARGURA_IA = 1400; // px da imagem enviada à IA

export async function abrirPdf(arquivo) {
  const dados = new Uint8Array(await arquivo.arrayBuffer());
  return pdfjsLib.getDocument({ data: dados }).promise;
}

// Desenha a página n (1..) num canvas em alta resolução.
export async function renderizarPagina(pdf, n) {
  const pagina = await pdf.getPage(n);
  const viewport = pagina.getViewport({ scale: ESCALA_RECORTE });
  const canvas = document.createElement('canvas');
  canvas.width = Math.ceil(viewport.width);
  canvas.height = Math.ceil(viewport.height);
  const ctx = canvas.getContext('2d');
  ctx.fillStyle = '#ffffff';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  await pagina.render({ canvasContext: ctx, viewport }).promise;
  return canvas;
}

// Cópia reduzida da página com a grade 0–100% desenhada por cima (base64 JPEG, sem prefixo).
export function imagemComGrade(canvas) {
  const escala = Math.min(1, LARGURA_IA / canvas.width);
  const w = Math.round(canvas.width * escala);
  const h = Math.round(canvas.height * escala);
  const c = document.createElement('canvas');
  c.width = w;
  c.height = h;
  const ctx = c.getContext('2d');
  ctx.drawImage(canvas, 0, 0, w, h);

  ctx.font = `${Math.max(11, Math.round(w / 110))}px sans-serif`;
  for (let p = 0; p <= 100; p += 5) {
    const forte = p % 10 === 0;
    ctx.strokeStyle = forte ? 'rgba(0,140,255,0.55)' : 'rgba(0,140,255,0.22)';
    ctx.lineWidth = 1;
    const x = (p / 100) * w;
    const y = (p / 100) * h;
    ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, h); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(w, y); ctx.stroke();
    if (forte) {
      ctx.fillStyle = 'rgba(0,90,220,0.9)';
      ctx.fillText(String(p), x + 2, 12);
      ctx.fillText(String(p), x + 2, h - 3);
      ctx.fillText(String(p), 2, y - 2 || 12);
      ctx.fillText(String(p), w - 22, y - 2 || 12);
    }
  }
  return c.toDataURL('image/jpeg', 0.82).split(',')[1];
}

// Lotes: extrai as páginas i e i+1, com a i+2 como contexto (questão que continua na página seguinte).
function montarLotes(total) {
  const lotes = [];
  for (let i = 1; i <= total; i += 2) {
    const extrair = [i, i + 1].filter((n) => n <= total);
    const contexto = i + 2 <= total ? [i + 2] : [];
    lotes.push({ extrair, contexto });
  }
  return lotes;
}

async function chamarFuncao(paginas) {
  const { data, error } = await supabase.functions.invoke('importar-lista-pdf', { body: { paginas } });
  if (error) {
    let msg = error.message;
    try { const corpo = await error.context?.json?.(); if (corpo?.error) msg = corpo.error; } catch { /* sem corpo */ }
    throw new Error(msg);
  }
  if (data?.error) throw new Error(data.error);
  return data;
}

// Lê todas as páginas com a IA. onProgresso({ feitos, total, etapa }).
export async function lerPdfComIA(imagensGrade, onProgresso, concorrencia = 3) {
  const lotes = montarLotes(imagensGrade.length);
  const resultados = new Array(lotes.length);
  let feitos = 0;
  let proximo = 0;
  onProgresso?.({ feitos, total: lotes.length });

  const trabalhador = async () => {
    while (proximo < lotes.length) {
      const idx = proximo++;
      const { extrair, contexto } = lotes[idx];
      const paginas = [
        ...extrair.map((n) => ({ numero: n, imagem: imagensGrade[n - 1], extrair: true })),
        ...contexto.map((n) => ({ numero: n, imagem: imagensGrade[n - 1], extrair: false })),
      ];
      let tentativa = 0;
      // uma nova tentativa em caso de falha passageira
      for (;;) {
        try {
          resultados[idx] = await chamarFuncao(paginas);
          break;
        } catch (e) {
          if (++tentativa >= 2) throw new Error(`Páginas ${extrair.join(' e ')}: ${e.message}`);
        }
      }
      feitos += 1;
      onProgresso?.({ feitos, total: lotes.length });
    }
  };

  await Promise.all(Array.from({ length: Math.min(concorrencia, lotes.length) }, trabalhador));
  return resultados;
}

const pesoQuestao = (q) => JSON.stringify(q.enunciado || []).length + JSON.stringify(q.alternativas || []).length;

// Junta os lotes numa lista só, com nível e gabarito aplicados.
export function mesclarResultados(resultados) {
  const porNumero = new Map();
  const secoes = [];
  const gabarito = {};
  let titulo = '';
  let subtitulo = '';
  const uso = { entrada: 0, saida: 0 };
  let cortado = false;

  for (const r of resultados) {
    if (!r) continue;
    if (!titulo && r.titulo_lista) titulo = r.titulo_lista;
    if (!subtitulo && r.subtitulo_lista) subtitulo = r.subtitulo_lista;
    (r.secoes_nivel || []).forEach((s) => secoes.push(s));
    (r.gabarito || []).forEach((g) => { if (g?.numero && g?.resposta) gabarito[g.numero] = String(g.resposta).trim().toUpperCase().charAt(0); });
    (r.questoes || []).forEach((q) => {
      if (!q?.numero) return;
      const atual = porNumero.get(q.numero);
      if (!atual || pesoQuestao(q) > pesoQuestao(atual)) porNumero.set(q.numero, q);
    });
    uso.entrada += r.uso?.entrada || 0;
    uso.saida += r.uso?.saida || 0;
    cortado = cortado || !!r.cortado;
  }

  secoes.sort((a, b) => a.a_partir_da_questao - b.a_partir_da_questao);
  const nivelDe = (n) => {
    let nivel = null;
    for (const s of secoes) if (s.a_partir_da_questao <= n) nivel = s.nivel;
    return nivel;
  };

  const questoes = [...porNumero.values()]
    .sort((a, b) => a.numero - b.numero)
    .map((q) => ({
      numero: q.numero,
      banca: (q.banca || '').trim(),
      ano: q.ano || null,
      nivel: nivelDe(q.numero) || 2,
      enunciado: (q.enunciado || []).filter((b) => b && (b.tipo !== 'texto' || (b.texto || '').trim())),
      alternativas: (q.alternativas || []).map((a) => ({
        letra: String(a.letra || '').trim().toUpperCase().charAt(0),
        texto: a.texto || '',
        regiao: a.regiao && (!a.texto || !a.texto.trim()) ? a.regiao : null,
      })).filter((a) => a.letra),
      resposta: (gabarito[q.numero] || (q.resposta || '').trim().toUpperCase().charAt(0) || ''),
      incluir: true,
    }));

  return { titulo, subtitulo, questoes, uso, cortado };
}

// Recorta uma região (em % da página) do canvas da página. Devolve um canvas novo.
export function recortar(canvasPagina, regiao, folga = 0.4) {
  const x0 = Math.max(0, Math.min(regiao.x0, regiao.x1) - folga);
  const y0 = Math.max(0, Math.min(regiao.y0, regiao.y1) - folga);
  const x1 = Math.min(100, Math.max(regiao.x0, regiao.x1) + folga);
  const y1 = Math.min(100, Math.max(regiao.y0, regiao.y1) + folga);
  const sx = (x0 / 100) * canvasPagina.width;
  const sy = (y0 / 100) * canvasPagina.height;
  const sw = Math.max(4, ((x1 - x0) / 100) * canvasPagina.width);
  const sh = Math.max(4, ((y1 - y0) / 100) * canvasPagina.height);
  const c = document.createElement('canvas');
  c.width = Math.round(sw);
  c.height = Math.round(sh);
  c.getContext('2d').drawImage(canvasPagina, sx, sy, sw, sh, 0, 0, c.width, c.height);
  return c;
}

export const canvasParaBlob = (canvas) => new Promise((ok) => canvas.toBlob(ok, 'image/png'));
