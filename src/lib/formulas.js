// Separação de texto e fórmulas LaTeX. Regras explicadas em components/TextoComFormulas.jsx.

// Divide o texto em pedaços { tipo: 'texto' | 'inline' | 'display', valor }.
export function separarFormulas(texto) {
  const partes = [];
  let buffer = '';
  let i = 0;
  const n = texto.length;

  const empurrarTexto = () => {
    if (buffer) partes.push({ tipo: 'texto', valor: buffer });
    buffer = '';
  };

  while (i < n) {
    const c = texto[i];

    // \$ fora de fórmula = cifrão literal
    if (c === '\\' && texto[i + 1] === '$') { buffer += '$'; i += 2; continue; }

    // \[ ... \]  e  \( ... \)
    if (c === '\\' && (texto[i + 1] === '[' || texto[i + 1] === '(')) {
      const fecha = texto[i + 1] === '[' ? '\\]' : '\\)';
      const fim = texto.indexOf(fecha, i + 2);
      if (fim !== -1) {
        empurrarTexto();
        partes.push({ tipo: texto[i + 1] === '[' ? 'display' : 'inline', valor: texto.slice(i + 2, fim) });
        i = fim + 2;
        continue;
      }
    }

    // $$ ... $$
    if (c === '$' && texto[i + 1] === '$') {
      const fim = texto.indexOf('$$', i + 2);
      if (fim !== -1 && fim > i + 2) {
        empurrarTexto();
        partes.push({ tipo: 'display', valor: texto.slice(i + 2, fim) });
        i = fim + 2;
        continue;
      }
    }

    // $ ... $  (regras para não pegar dinheiro)
    if (c === '$' && texto[i - 1] !== 'R' && texto[i + 1] && !/\s/.test(texto[i + 1])) {
      let j = i + 1;
      let fim = -1;
      while (j < n) {
        if (texto[j] === '\\') { j += 2; continue; }
        if (texto[j] === '$') {
          const antes = texto[j - 1];
          const depois = texto[j + 1];
          if (!/\s/.test(antes) && !(depois && /\d/.test(depois))) { fim = j; break; }
        }
        if (texto[j] === '\n') break;
        j += 1;
      }
      if (fim !== -1) {
        empurrarTexto();
        partes.push({ tipo: 'inline', valor: texto.slice(i + 1, fim) });
        i = fim + 1;
        continue;
      }
    }

    buffer += c;
    i += 1;
  }
  empurrarTexto();
  return partes;
}
