import React from 'react';
import TextoComFormulas from './TextoComFormulas';

// Renderiza um array de blocos em fluxo — texto e imagem se intercalam na mesma linha.
// Usado no enunciado e nas alternativas.
//
// Tipos de bloco:
//   { tipo: 'texto',  valor }                         texto com fórmulas ($...$); "\n" quebra linha
//   { tipo: 'imagem', valor: url, tamanho? }          tamanho: 'p' (na linha), 'm' (média), 'g' (figura grande, linha própria)
//   { tipo: 'tabela', valor, cabecalho? }             valor: uma linha por linha da tabela, células separadas por "|"
//                                                     cabecalho: 'linha' (1ª linha, padrão) ou 'coluna' (1ª coluna)
const ALTURA_IMAGEM = { p: null, m: 'h-24 md:h-28', g: 'max-h-80' };

export function TabelaBloco({ valor, cabecalho = 'linha' }) {
  const linhas = String(valor || '')
    .split('\n')
    .map((l) => l.trim())
    .filter(Boolean)
    .map((l) => l.split('|').map((c) => c.trim()));
  if (linhas.length === 0) return null;

  return (
    <span className="block basis-full w-full overflow-x-auto my-2">
      <table className="mx-auto border-collapse text-sm">
        <tbody>
          {linhas.map((celulas, i) => (
            <tr key={i}>
              {celulas.map((c, j) => {
                const eCabecalho = cabecalho === 'coluna' ? j === 0 : i === 0;
                const Tag = eCabecalho ? 'th' : 'td';
                return (
                  <Tag
                    key={j}
                    scope={eCabecalho ? (cabecalho === 'coluna' ? 'row' : 'col') : undefined}
                    className={`border border-slate-300 px-3 py-1.5 text-center ${
                      eCabecalho ? 'bg-brand-orange text-white font-bold text-left' : 'bg-white text-slate-800'
                    }`}
                  >
                    <TextoComFormulas texto={c} />
                  </Tag>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </span>
  );
}

export default function RenderBlocos({ blocos, imgHeight = 'h-12', placeholder }) {
  if (!blocos || blocos.length === 0) {
    return placeholder ? <span className="text-slate-300 italic">{placeholder}</span> : null;
  }

  return (
    <span className="inline-flex flex-wrap items-center gap-1.5 align-middle w-full">
      {blocos.map((b, i) => {
        if (b.tipo === 'tabela') return <TabelaBloco key={i} valor={b.valor} cabecalho={b.cabecalho} />;

        if (b.tipo === 'imagem') {
          if (!b.valor) return null;
          if (b.tamanho === 'g') {
            // Figura grande: ocupa a linha inteira, centralizada (figuras de Física, gráficos).
            return (
              <span key={i} className="block basis-full w-full my-2 text-center">
                <img
                  src={b.valor}
                  alt={b.legenda || 'Figura da questão'}
                  className={`${ALTURA_IMAGEM.g} max-w-full w-auto object-contain inline-block bg-white rounded-lg`}
                />
                {b.legenda && <span className="block text-xs text-slate-500 mt-1">{b.legenda}</span>}
              </span>
            );
          }
          return (
            <img
              key={i}
              src={b.valor}
              alt={b.legenda || 'Imagem da questão'}
              className={`${ALTURA_IMAGEM[b.tamanho] || imgHeight} w-auto max-w-full object-contain rounded border border-slate-200 bg-white p-0.5 inline-block align-middle`}
            />
          );
        }

        return (
          <span key={i} className="whitespace-pre-line">
            <TextoComFormulas texto={b.valor} />
          </span>
        );
      })}
    </span>
  );
}
