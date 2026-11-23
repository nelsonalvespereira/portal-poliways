import React, { useMemo } from 'react';
import katex from 'katex';
import { separarFormulas } from '../lib/formulas';

// Mostra texto com fórmulas em LaTeX (KaTeX), para Física, Química e Matemática.
//
// Como escrever no cadastro da questão:
//   $x^2 + y^2 = r^2$          → fórmula na linha do texto
//   $$\int_0^1 x\,dx$$          → fórmula em destaque, numa linha só dela
//   \( ... \) e \[ ... \]      → mesma coisa, forma alternativa
//
// Para não confundir com dinheiro ("R$ 10"), o $ só abre fórmula se vier colado
// no conteúdo ($x$, e não "$ 10") e não vier logo depois de "R". Para escrever um
// cifrão de verdade dentro de uma fórmula, use \$.

const cache = new Map();

function renderizar(tex, display) {
  const chave = `${display ? 'D' : 'I'}${tex}`;
  if (cache.has(chave)) return cache.get(chave);
  let html;
  try {
    html = katex.renderToString(tex, { displayMode: display, throwOnError: false, strict: 'ignore', output: 'html' });
  } catch {
    html = null;
  }
  if (cache.size > 500) cache.clear();
  cache.set(chave, html);
  return html;
}

export default function TextoComFormulas({ texto }) {
  const partes = useMemo(() => (typeof texto === 'string' ? separarFormulas(texto) : null), [texto]);
  if (texto === null || texto === undefined || texto === '') return null;
  if (!partes) return <>{String(texto)}</>;
  if (partes.length === 1 && partes[0].tipo === 'texto') return <>{partes[0].valor}</>;

  return (
    <>
      {partes.map((p, idx) => {
        if (p.tipo === 'texto') return <React.Fragment key={idx}>{p.valor}</React.Fragment>;
        const html = renderizar(p.valor, p.tipo === 'display');
        if (!html) return <code key={idx}>{p.valor}</code>;
        return p.tipo === 'display' ? (
          <span key={idx} className="formula-display" dangerouslySetInnerHTML={{ __html: html }} />
        ) : (
          <span key={idx} className="formula-inline" dangerouslySetInnerHTML={{ __html: html }} />
        );
      })}
    </>
  );
}
