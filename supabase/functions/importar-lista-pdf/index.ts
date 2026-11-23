// supabase/functions/importar-lista-pdf/index.ts
//
// Lê páginas de uma lista de exercícios em PDF e devolve as questões estruturadas.
// O navegador renderiza as páginas como imagem (com uma grade de coordenadas por cima)
// e manda de 2 em 2 páginas. Esta função:
//   1. confere que quem chama está logado e é admin;
//   2. manda as imagens para o Claude (API da Anthropic) com instruções de extração;
//   3. devolve o JSON das questões (texto com LaTeX, posição das figuras, alternativas, gabarito).
//
// A chave da Anthropic fica só aqui, como segredo do Supabase:
//   supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
// Modelo opcional (padrão claude-sonnet-5-5):
//   supabase secrets set ANTHROPIC_MODEL=claude-sonnet-5-5

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, 'Content-Type': 'application/json' } });

// Formato que o Claude deve devolver (ferramenta obrigatória = JSON garantido).
const regiao = {
  type: 'object',
  description: 'Retângulo da figura na página, em porcentagem (0 a 100) da grade desenhada na imagem. Inclua rótulos da figura (letras, medidas, eixos); não inclua o número da questão nem o texto do enunciado.',
  properties: {
    pagina: { type: 'integer', description: 'Número da página (como indicado no texto antes de cada imagem).' },
    x0: { type: 'number' }, y0: { type: 'number' }, x1: { type: 'number' }, y1: { type: 'number' },
  },
  required: ['pagina', 'x0', 'y0', 'x1', 'y1'],
};

const ferramenta = {
  name: 'registrar_questoes',
  description: 'Registra as questões encontradas nas páginas.',
  input_schema: {
    type: 'object',
    properties: {
      titulo_lista: { type: 'string', description: 'Título da lista, se aparecer no cabeçalho (ex.: "Vetores e Cinemática Vetorial"). Vazio se não houver.' },
      subtitulo_lista: { type: 'string', description: 'Subtítulo, se houver. Vazio se não houver.' },
      secoes_nivel: {
        type: 'array',
        description: 'Cabeçalhos de nível/dificuldade vistos nas páginas (ex.: "NÍVEL II") e o número da primeira questão depois de cada um.',
        items: {
          type: 'object',
          properties: {
            nivel: { type: 'integer', minimum: 1, maximum: 4 },
            a_partir_da_questao: { type: 'integer' },
          },
          required: ['nivel', 'a_partir_da_questao'],
        },
      },
      gabarito: {
        type: 'array',
        description: 'Se alguma página tiver a tabela de gabarito, liste todas as respostas dela.',
        items: {
          type: 'object',
          properties: { numero: { type: 'integer' }, resposta: { type: 'string', description: 'Letra maiúscula A a E.' } },
          required: ['numero', 'resposta'],
        },
      },
      questoes: {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            numero: { type: 'integer' },
            banca: { type: 'string', description: 'Banca/fonte entre parênteses no início (ex.: "UNIFESP", "EsPCEx"). Vazio se não houver.' },
            ano: { type: 'integer', description: 'Ano, se aparecer junto da banca. 0 se não houver.' },
            enunciado: {
              type: 'array',
              description: 'Enunciado em ordem de leitura, dividido em blocos. Não inclua o número da questão nem a banca.',
              items: {
                type: 'object',
                properties: {
                  tipo: { type: 'string', enum: ['texto', 'figura', 'tabela'] },
                  texto: { type: 'string', description: 'Para tipo texto: o texto exato, fórmulas em LaTeX entre $...$. Para tipo tabela: uma linha por linha da tabela, células separadas por " | ".' },
                  cabecalho: { type: 'string', enum: ['linha', 'coluna'], description: 'Só para tabela: qual é o cabeçalho destacado.' },
                  regiao,
                },
                required: ['tipo'],
              },
            },
            alternativas: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  letra: { type: 'string', description: 'A, B, C, D ou E (maiúscula).' },
                  texto: { type: 'string', description: 'Texto da alternativa, fórmulas em LaTeX entre $...$. Vazio se a alternativa for só uma figura.' },
                  regiao: { ...regiao, description: 'Só se a alternativa for uma figura/gráfico: o retângulo dela, sem a letra "a)".' },
                },
                required: ['letra'],
              },
            },
            resposta: { type: 'string', description: 'Letra correta se estiver indicada nas páginas enviadas; vazio caso contrário.' },
          },
          required: ['numero', 'enunciado', 'alternativas'],
        },
      },
    },
    required: ['questoes'],
  },
};

const INSTRUCOES = `Você está digitalizando uma lista de exercícios de Física/Matemática (vestibulares e escolas militares) para uma plataforma de estudos.

Cada imagem é uma página do PDF com uma GRADE de coordenadas desenhada por cima: linhas a cada 5% e rótulos de 0 a 100 nas bordas (eixo x da esquerda para a direita, eixo y de cima para baixo). Use a grade para dar a posição das figuras em porcentagem da página. Ignore a grade em todo o resto.

Regras:
- Extraia SÓ as questões que COMEÇAM nas páginas marcadas como "PÁGINA PARA EXTRAIR". Uma página marcada como "SÓ CONTEXTO" serve apenas para completar uma questão que continua nela.
- Transcreva o texto exatamente como está, em português, sem resumir nem corrigir. Junte palavras hifenizadas na quebra de linha ("veloci-dade" → "velocidade").
- Toda notação matemática vai em LaTeX entre $...$: vetores \\vec{a}, índices v_{0}, potências m/s$^2$, raízes \\sqrt{2}, frações \\dfrac{a}{b}, graus 45^\\circ, letras gregas \\theta, \\omega. Números com vírgula decimal podem ficar como texto (0,5).
- Seno em português: \\operatorname{sen}.
- Figuras, diagramas e gráficos viram blocos "figura" com a região. A região deve cobrir a figura inteira com seus rótulos e uma pequena folga, sem pegar texto do enunciado, de outra questão ou das alternativas.
- Tabelas de dados viram blocos "tabela" (não figura).
- Alternativas que são desenhos ou gráficos: texto vazio e a região de cada uma.
- Listas com marcadores dentro do enunciado: mantenha no texto com "• " e quebra de linha "\\n".
- Cabeçalhos como "NÍVEL I", "NÍVEL II ★★": registre em secoes_nivel.
- Se houver página de gabarito, registre todas as respostas em gabarito.
- Ignore cabeçalho/rodapé da página, logotipo e instruções gerais da lista.`;

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) return json({ error: 'Não autenticado' }, 401);

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: authHeader } } },
    );
    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) return json({ error: 'Não autenticado' }, 401);
    const { data: perfil } = await supabase.from('profiles').select('is_admin').eq('id', user.id).single();
    if (!perfil?.is_admin) return json({ error: 'Acesso restrito a administradores' }, 403);

    const chave = Deno.env.get('ANTHROPIC_API_KEY');
    if (!chave) return json({ error: 'A chave ANTHROPIC_API_KEY não está configurada no Supabase.' }, 500);
    const modelo = Deno.env.get('ANTHROPIC_MODEL') || 'claude-sonnet-5-5';

    // paginas: [{ numero, imagem (base64 jpeg, sem prefixo), extrair: boolean }]
    const { paginas } = await req.json();
    if (!Array.isArray(paginas) || paginas.length === 0 || paginas.length > 4) {
      return json({ error: 'Envie de 1 a 4 páginas por vez.' }, 400);
    }

    const conteudo: unknown[] = [];
    for (const p of paginas) {
      conteudo.push({ type: 'text', text: `Página ${p.numero} — ${p.extrair ? 'PÁGINA PARA EXTRAIR' : 'SÓ CONTEXTO (não extraia questões que começam aqui)'}:` });
      conteudo.push({ type: 'image', source: { type: 'base64', media_type: 'image/jpeg', data: p.imagem } });
    }
    conteudo.push({ type: 'text', text: 'Registre as questões dessas páginas com a ferramenta registrar_questoes.' });

    const resposta = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'x-api-key': chave,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: JSON.stringify({
        model: modelo,
        max_tokens: 16000,
        system: INSTRUCOES,
        tools: [ferramenta],
        tool_choice: { type: 'tool', name: 'registrar_questoes' },
        messages: [{ role: 'user', content: conteudo }],
      }),
    });

    const corpo = await resposta.json();
    if (!resposta.ok) {
      const msg = corpo?.error?.message || `Erro ${resposta.status} na API da Anthropic`;
      return json({ error: msg }, 502);
    }

    const uso = corpo.usage || {};
    const bloco = (corpo.content || []).find((c: { type: string }) => c.type === 'tool_use');
    if (!bloco) return json({ error: 'A IA não devolveu as questões. Tente de novo.' }, 502);

    return json({ ...bloco.input, uso: { entrada: uso.input_tokens || 0, saida: uso.output_tokens || 0 }, modelo, cortado: corpo.stop_reason === 'max_tokens' });
  } catch (e) {
    return json({ error: e instanceof Error ? e.message : String(e) }, 500);
  }
});
