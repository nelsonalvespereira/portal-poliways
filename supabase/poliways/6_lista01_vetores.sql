-- =============================================================================
-- PASSO 6 — IMPORTA A LISTA 01 (45 questões) NO PROJETO POLIWAYS.
-- Lista: "Vetores e Cinemática Vetorial" · turma Física · Escolas Militares · Prof. Paulo Prado.
-- Pré-requisitos: 4_turmas_por_materia.sql e 5_listas_e_niveis.sql já rodados.
-- Pode rodar mais de uma vez: se a lista já tiver as questões, nada é duplicado.
-- As figuras ficam no próprio site (pasta public/listas/lista-01), não no Storage.
-- =============================================================================

-- Assunto da árvore (Gerenciar Assuntos), na turma Física · Escolas Militares
insert into public.assuntos_hierarquia (turma_id, nome)
select t.id, 'Vetores e Cinemática Vetorial' from public.turmas t
where t.slug = 'fisica-escolas-militares'
  and not exists (select 1 from public.assuntos_hierarquia a where a.turma_id = t.id and a.nome = 'Vetores e Cinemática Vetorial');

-- A lista
insert into public.listas (turma_id, titulo, subtitulo, descricao, ordem, publicada)
select t.id, 'Vetores e Cinemática Vetorial', 'Questões de escolas militares e vestibulares', 'As questões estão organizadas em níveis de dificuldade crescente: Nível I até Nível IV.
Faça um esboço dos vetores antes de calcular: decomponha em componentes $x$ e $y$ sempre que possível.
Lembretes: $|\vec{R}|^2 = a^2 + b^2 + 2ab\cos\theta$;  $\vec{v}_{abs} = \vec{v}_{rel} + \vec{v}_{arr}$;  $a_{cp} = v^2/R$.', 1, true from public.turmas t
where t.slug = 'fisica-escolas-militares'
  and not exists (select 1 from public.listas l where l.turma_id = t.id and l.titulo = 'Vetores e Cinemática Vetorial');

-- Questão 1 (UNIFESP) · Nível 1
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 1)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'facil', 1, 'UNIFESP', 'Na figura, são dados os vetores $\vec{a}$, $\vec{\omega}$ e $\vec{v}$. [FIGURA] Sendo $u$ a unidade de medida do módulo desses vetores, pode-se afirmar que o vetor $\vec{g} = \vec{a} - \vec{\omega} + \vec{v}$ tem módulo',
         '[{"tipo": "texto", "valor": "Na figura, são dados os vetores $\\vec{a}$, $\\vec{\\omega}$ e $\\vec{v}$."}, {"tipo": "imagem", "valor": "/listas/lista-01/q01.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Sendo $u$ a unidade de medida do módulo desses vetores, pode-se afirmar que o vetor $\\vec{g} = \\vec{a} - \\vec{\\omega} + \\vec{v}$ tem módulo"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Na figura, são dados os vetores $\\vec{a}$, $\\vec{\\omega}$ e $\\vec{v}$."}, {"tipo": "imagem", "valor": "/listas/lista-01/q01.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Sendo $u$ a unidade de medida do módulo desses vetores, pode-se afirmar que o vetor $\\vec{g} = \\vec{a} - \\vec{\\omega} + \\vec{v}$ tem módulo"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$2u$, e sua orientação é vertical, para cima.", "blocos": [{"tipo": "texto", "valor": "$2u$, e sua orientação é vertical, para cima."}]}, {"letra": "B", "texto": "$2u$, e sua orientação é vertical, para baixo.", "blocos": [{"tipo": "texto", "valor": "$2u$, e sua orientação é vertical, para baixo."}]}, {"letra": "C", "texto": "$4u$, e sua orientação é horizontal, para a direita.", "blocos": [{"tipo": "texto", "valor": "$4u$, e sua orientação é horizontal, para a direita."}]}, {"letra": "D", "texto": "$\\sqrt{2}\\,u$, e sua orientação forma $45^\\circ$ com a horizontal, no sentido horário.", "blocos": [{"tipo": "texto", "valor": "$\\sqrt{2}\\,u$, e sua orientação forma $45^\\circ$ com a horizontal, no sentido horário."}]}, {"letra": "E", "texto": "$\\sqrt{2}\\,u$, e sua orientação forma $45^\\circ$ com a horizontal, no sentido anti-horário.", "blocos": [{"tipo": "texto", "valor": "$\\sqrt{2}\\,u$, e sua orientação forma $45^\\circ$ com a horizontal, no sentido anti-horário."}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 1 from alvo, q;

-- Questão 2 (UFC) · Nível 1
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 2)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'facil', 1, 'UFC', 'Na figura a seguir, onde o reticulado forma quadrados de lados $\ell = 0{,}5$ cm, estão desenhados 10 vetores contidos no plano $xy$. O módulo da soma de todos esses vetores é, em centímetros: [FIGURA]',
         '[{"tipo": "texto", "valor": "Na figura a seguir, onde o reticulado forma quadrados de lados $\\ell = 0{,}5$ cm, estão desenhados 10 vetores contidos no plano $xy$. O módulo da soma de todos esses vetores é, em centímetros:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q02.png", "tamanho": "g"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Na figura a seguir, onde o reticulado forma quadrados de lados $\\ell = 0{,}5$ cm, estão desenhados 10 vetores contidos no plano $xy$. O módulo da soma de todos esses vetores é, em centímetros:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q02.png", "tamanho": "g"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$0{,}0$", "blocos": [{"tipo": "texto", "valor": "$0{,}0$"}]}, {"letra": "B", "texto": "$0{,}5$", "blocos": [{"tipo": "texto", "valor": "$0{,}5$"}]}, {"letra": "C", "texto": "$1{,}0$", "blocos": [{"tipo": "texto", "valor": "$1{,}0$"}]}, {"letra": "D", "texto": "$1{,}5$", "blocos": [{"tipo": "texto", "valor": "$1{,}5$"}]}, {"letra": "E", "texto": "$2{,}0$", "blocos": [{"tipo": "texto", "valor": "$2{,}0$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'E' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 2 from alvo, q;

-- Questão 3 (MACKENZIE) · Nível 1
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 3)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'facil', 1, 'MACKENZIE', 'Com seis vetores de módulos iguais a $8u$, construiu-se o hexágono regular a seguir. O módulo do vetor resultante desses 6 vetores é: [FIGURA]',
         '[{"tipo": "texto", "valor": "Com seis vetores de módulos iguais a $8u$, construiu-se o hexágono regular a seguir. O módulo do vetor resultante desses 6 vetores é:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q03.png", "tamanho": "g"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Com seis vetores de módulos iguais a $8u$, construiu-se o hexágono regular a seguir. O módulo do vetor resultante desses 6 vetores é:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q03.png", "tamanho": "g"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$40u$", "blocos": [{"tipo": "texto", "valor": "$40u$"}]}, {"letra": "B", "texto": "$32u$", "blocos": [{"tipo": "texto", "valor": "$32u$"}]}, {"letra": "C", "texto": "$24u$", "blocos": [{"tipo": "texto", "valor": "$24u$"}]}, {"letra": "D", "texto": "$16u$", "blocos": [{"tipo": "texto", "valor": "$16u$"}]}, {"letra": "E", "texto": "zero", "blocos": [{"tipo": "texto", "valor": "zero"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 3 from alvo, q;

-- Questão 4 (UFVJM-MG) · Nível 1
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 4)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'facil', 1, 'UFVJM-MG', 'Durante um estudo de deslocamento, um estudante encontra três vetores, como os representados na figura. [FIGURA] Suponha que cada quadrado da figura represente uma distância de 1,0 cm de aresta. Nesse caso, o vetor deslocamento resultante terá módulo, direção e sentido indicados em:',
         '[{"tipo": "texto", "valor": "Durante um estudo de deslocamento, um estudante encontra três vetores, como os representados na figura."}, {"tipo": "imagem", "valor": "/listas/lista-01/q04.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Suponha que cada quadrado da figura represente uma distância de 1,0 cm de aresta. Nesse caso, o vetor deslocamento resultante terá módulo, direção e sentido indicados em:"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Durante um estudo de deslocamento, um estudante encontra três vetores, como os representados na figura."}, {"tipo": "imagem", "valor": "/listas/lista-01/q04.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Suponha que cada quadrado da figura represente uma distância de 1,0 cm de aresta. Nesse caso, o vetor deslocamento resultante terá módulo, direção e sentido indicados em:"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "10,0 cm, diagonal, nordeste.", "blocos": [{"tipo": "texto", "valor": "10,0 cm, diagonal, nordeste."}]}, {"letra": "B", "texto": "100,0 cm, diagonal, sudoeste.", "blocos": [{"tipo": "texto", "valor": "100,0 cm, diagonal, sudoeste."}]}, {"letra": "C", "texto": "5,0 cm, diagonal, noroeste.", "blocos": [{"tipo": "texto", "valor": "5,0 cm, diagonal, noroeste."}]}, {"letra": "D", "texto": "12,0 cm, diagonal, nordeste.", "blocos": [{"tipo": "texto", "valor": "12,0 cm, diagonal, nordeste."}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'A' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 4 from alvo, q;

-- Questão 5 (EEAR) · Nível 1
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 5)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'facil', 1, 'EEAR', 'Dois vetores, $\vec{A}$ e $\vec{B}$, estão representados a seguir. Assinale, entre as alternativas, aquela que melhor representa a resultante da operação vetorial $\vec{A} - \vec{B}$. [FIGURA]',
         '[{"tipo": "texto", "valor": "Dois vetores, $\\vec{A}$ e $\\vec{B}$, estão representados a seguir. Assinale, entre as alternativas, aquela que melhor representa a resultante da operação vetorial $\\vec{A} - \\vec{B}$."}, {"tipo": "imagem", "valor": "/listas/lista-01/q05.png", "tamanho": "g"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Dois vetores, $\\vec{A}$ e $\\vec{B}$, estão representados a seguir. Assinale, entre as alternativas, aquela que melhor representa a resultante da operação vetorial $\\vec{A} - \\vec{B}$."}, {"tipo": "imagem", "valor": "/listas/lista-01/q05.png", "tamanho": "g"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "[FIGURA]", "blocos": [{"tipo": "imagem", "valor": "/listas/lista-01/q05a.png", "tamanho": "m"}]}, {"letra": "B", "texto": "[FIGURA]", "blocos": [{"tipo": "imagem", "valor": "/listas/lista-01/q05b.png", "tamanho": "m"}]}, {"letra": "C", "texto": "[FIGURA]", "blocos": [{"tipo": "imagem", "valor": "/listas/lista-01/q05c.png", "tamanho": "m"}]}, {"letra": "D", "texto": "[FIGURA]", "blocos": [{"tipo": "imagem", "valor": "/listas/lista-01/q05d.png", "tamanho": "m"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 5 from alvo, q;

-- Questão 6 (EEAR) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 6)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'EEAR', 'Dois vetores $\vec{V}_1$ e $\vec{V}_2$ formam entre si um ângulo $\theta$ e possuem módulos iguais a 5 unidades e 12 unidades, respectivamente. Se a resultante entre eles tem módulo igual a 13 unidades, podemos afirmar corretamente que o ângulo $\theta$ entre os vetores $\vec{V}_1$ e $\vec{V}_2$ vale:',
         '[{"tipo": "texto", "valor": "Dois vetores $\\vec{V}_1$ e $\\vec{V}_2$ formam entre si um ângulo $\\theta$ e possuem módulos iguais a 5 unidades e 12 unidades, respectivamente. Se a resultante entre eles tem módulo igual a 13 unidades, podemos afirmar corretamente que o ângulo $\\theta$ entre os vetores $\\vec{V}_1$ e $\\vec{V}_2$ vale:"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Dois vetores $\\vec{V}_1$ e $\\vec{V}_2$ formam entre si um ângulo $\\theta$ e possuem módulos iguais a 5 unidades e 12 unidades, respectivamente. Se a resultante entre eles tem módulo igual a 13 unidades, podemos afirmar corretamente que o ângulo $\\theta$ entre os vetores $\\vec{V}_1$ e $\\vec{V}_2$ vale:"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$0^\\circ$", "blocos": [{"tipo": "texto", "valor": "$0^\\circ$"}]}, {"letra": "B", "texto": "$45^\\circ$", "blocos": [{"tipo": "texto", "valor": "$45^\\circ$"}]}, {"letra": "C", "texto": "$90^\\circ$", "blocos": [{"tipo": "texto", "valor": "$90^\\circ$"}]}, {"letra": "D", "texto": "$180^\\circ$", "blocos": [{"tipo": "texto", "valor": "$180^\\circ$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'C' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 6 from alvo, q;

-- Questão 7 (FMP) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 7)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'FMP', 'Um jogador de futebol chuta uma bola sem provocar nela qualquer efeito de rotação. A resistência do ar é praticamente desprezível, e a trajetória da bola é uma parábola. Traça-se um sistema de eixos coordenados, com um eixo $x$ horizontal e paralelo ao chão do campo de futebol, e um eixo $y$ vertical com sentido positivo para cima. Na figura a seguir, o vetor $\vec{v}_0$ indica a velocidade com que a bola é lançada (velocidade inicial logo após o chute). [FIGURA] Abaixo estão indicados quatro vetores $\vec{w}_1$, $\vec{w}_2$, $\vec{w}_3$ e $\vec{w}_4$, sendo $\vec{w}_4$ o vetor nulo. [FIGURA] Os vetores que descrevem adequada e respectivamente a velocidade e a aceleração da bola no ponto mais alto de sua trajetória são',
         '[{"tipo": "texto", "valor": "Um jogador de futebol chuta uma bola sem provocar nela qualquer efeito de rotação. A resistência do ar é praticamente desprezível, e a trajetória da bola é uma parábola. Traça-se um sistema de eixos coordenados, com um eixo $x$ horizontal e paralelo ao chão do campo de futebol, e um eixo $y$ vertical com sentido positivo para cima. Na figura a seguir, o vetor $\\vec{v}_0$ indica a velocidade com que a bola é lançada (velocidade inicial logo após o chute)."}, {"tipo": "imagem", "valor": "/listas/lista-01/q07.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Abaixo estão indicados quatro vetores $\\vec{w}_1$, $\\vec{w}_2$, $\\vec{w}_3$ e $\\vec{w}_4$, sendo $\\vec{w}_4$ o vetor nulo."}, {"tipo": "imagem", "valor": "/listas/lista-01/q07b.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Os vetores que descrevem adequada e respectivamente a velocidade e a aceleração da bola no ponto mais alto de sua trajetória são"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um jogador de futebol chuta uma bola sem provocar nela qualquer efeito de rotação. A resistência do ar é praticamente desprezível, e a trajetória da bola é uma parábola. Traça-se um sistema de eixos coordenados, com um eixo $x$ horizontal e paralelo ao chão do campo de futebol, e um eixo $y$ vertical com sentido positivo para cima. Na figura a seguir, o vetor $\\vec{v}_0$ indica a velocidade com que a bola é lançada (velocidade inicial logo após o chute)."}, {"tipo": "imagem", "valor": "/listas/lista-01/q07.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Abaixo estão indicados quatro vetores $\\vec{w}_1$, $\\vec{w}_2$, $\\vec{w}_3$ e $\\vec{w}_4$, sendo $\\vec{w}_4$ o vetor nulo."}, {"tipo": "imagem", "valor": "/listas/lista-01/q07b.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Os vetores que descrevem adequada e respectivamente a velocidade e a aceleração da bola no ponto mais alto de sua trajetória são"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$\\vec{w}_1$ e $\\vec{w}_4$", "blocos": [{"tipo": "texto", "valor": "$\\vec{w}_1$ e $\\vec{w}_4$"}]}, {"letra": "B", "texto": "$\\vec{w}_4$ e $\\vec{w}_4$", "blocos": [{"tipo": "texto", "valor": "$\\vec{w}_4$ e $\\vec{w}_4$"}]}, {"letra": "C", "texto": "$\\vec{w}_1$ e $\\vec{w}_3$", "blocos": [{"tipo": "texto", "valor": "$\\vec{w}_1$ e $\\vec{w}_3$"}]}, {"letra": "D", "texto": "$\\vec{w}_1$ e $\\vec{w}_2$", "blocos": [{"tipo": "texto", "valor": "$\\vec{w}_1$ e $\\vec{w}_2$"}]}, {"letra": "E", "texto": "$\\vec{w}_4$ e $\\vec{w}_3$", "blocos": [{"tipo": "texto", "valor": "$\\vec{w}_4$ e $\\vec{w}_3$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'D' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 7 from alvo, q;

-- Questão 8 (VUNESP) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 8)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'VUNESP', 'O plano de voo de um avião comercial prevê os seguintes trechos: do aeroporto A ao aeroporto B, 1100 km para o norte, em 1,5 h; escala de 30 min em B; do aeroporto B ao aeroporto C, 800 km para o oeste, em 1,0 h; escala de 30 min em C; do aeroporto C ao aeroporto D, 500 km para o sul, em 30 min. O módulo da velocidade vetorial média total, de A até D, desenvolvida por esse avião, em km/h, terá sido de',
         '[{"tipo": "texto", "valor": "O plano de voo de um avião comercial prevê os seguintes trechos: do aeroporto A ao aeroporto B, 1100 km para o norte, em 1,5 h; escala de 30 min em B; do aeroporto B ao aeroporto C, 800 km para o oeste, em 1,0 h; escala de 30 min em C; do aeroporto C ao aeroporto D, 500 km para o sul, em 30 min. O módulo da velocidade vetorial média total, de A até D, desenvolvida por esse avião, em km/h, terá sido de"}]'::jsonb,
         '[{"tipo": "texto", "valor": "O plano de voo de um avião comercial prevê os seguintes trechos: do aeroporto A ao aeroporto B, 1100 km para o norte, em 1,5 h; escala de 30 min em B; do aeroporto B ao aeroporto C, 800 km para o oeste, em 1,0 h; escala de 30 min em C; do aeroporto C ao aeroporto D, 500 km para o sul, em 30 min. O módulo da velocidade vetorial média total, de A até D, desenvolvida por esse avião, em km/h, terá sido de"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "250", "blocos": [{"tipo": "texto", "valor": "250"}]}, {"letra": "B", "texto": "300", "blocos": [{"tipo": "texto", "valor": "300"}]}, {"letra": "C", "texto": "350", "blocos": [{"tipo": "texto", "valor": "350"}]}, {"letra": "D", "texto": "400", "blocos": [{"tipo": "texto", "valor": "400"}]}, {"letra": "E", "texto": "450", "blocos": [{"tipo": "texto", "valor": "450"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'A' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 8 from alvo, q;

-- Questão 9 (CEPS-UFPA) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 9)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'CEPS-UFPA', 'Uma viatura policial P encontra-se a 800 m a leste da origem de um eixo cartesiano e se move em direção à origem (de leste para oeste), com 80 km/h. Neste mesmo instante, um motorista M encontra-se a 600 m a norte da origem e se move em direção a esta (de norte para sul), com 60 km/h. Para este instante, a velocidade do motorista M, tal como vista pela viatura policial P, é',
         '[{"tipo": "texto", "valor": "Uma viatura policial P encontra-se a 800 m a leste da origem de um eixo cartesiano e se move em direção à origem (de leste para oeste), com 80 km/h. Neste mesmo instante, um motorista M encontra-se a 600 m a norte da origem e se move em direção a esta (de norte para sul), com 60 km/h. Para este instante, a velocidade do motorista M, tal como vista pela viatura policial P, é"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Uma viatura policial P encontra-se a 800 m a leste da origem de um eixo cartesiano e se move em direção à origem (de leste para oeste), com 80 km/h. Neste mesmo instante, um motorista M encontra-se a 600 m a norte da origem e se move em direção a esta (de norte para sul), com 60 km/h. Para este instante, a velocidade do motorista M, tal como vista pela viatura policial P, é"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "95 km/h na direção sul.", "blocos": [{"tipo": "texto", "valor": "95 km/h na direção sul."}]}, {"letra": "B", "texto": "95 km/h na direção norte.", "blocos": [{"tipo": "texto", "valor": "95 km/h na direção norte."}]}, {"letra": "C", "texto": "100 km/h na direção sudeste.", "blocos": [{"tipo": "texto", "valor": "100 km/h na direção sudeste."}]}, {"letra": "D", "texto": "100 km/h na direção noroeste.", "blocos": [{"tipo": "texto", "valor": "100 km/h na direção noroeste."}]}, {"letra": "E", "texto": "105 km/h na direção nordeste.", "blocos": [{"tipo": "texto", "valor": "105 km/h na direção nordeste."}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'C' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 9 from alvo, q;

-- Questão 10 (LIQUIGAS) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 10)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'LIQUIGAS', 'Um navio carregado de gás liquefeito de petróleo é observado a 60 km ao sul (ponto A) do porto de destino (ponto D). Para chegar a esse porto, o navio precisa circunavegar uma grande ilha que está situada entre o navio e o porto. Para passar por essa ilha, o navio navega, então, 30 km para o leste até o ponto B e 20 km para o norte até o ponto C, de onde pode traçar uma rota direta para o porto. Qual é o módulo do vetor deslocamento, em km, que o navio deve percorrer nesse trecho final, do ponto C até o ponto D?',
         '[{"tipo": "texto", "valor": "Um navio carregado de gás liquefeito de petróleo é observado a 60 km ao sul (ponto A) do porto de destino (ponto D). Para chegar a esse porto, o navio precisa circunavegar uma grande ilha que está situada entre o navio e o porto. Para passar por essa ilha, o navio navega, então, 30 km para o leste até o ponto B e 20 km para o norte até o ponto C, de onde pode traçar uma rota direta para o porto. Qual é o módulo do vetor deslocamento, em km, que o navio deve percorrer nesse trecho final, do ponto C até o ponto D?"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um navio carregado de gás liquefeito de petróleo é observado a 60 km ao sul (ponto A) do porto de destino (ponto D). Para chegar a esse porto, o navio precisa circunavegar uma grande ilha que está situada entre o navio e o porto. Para passar por essa ilha, o navio navega, então, 30 km para o leste até o ponto B e 20 km para o norte até o ponto C, de onde pode traçar uma rota direta para o porto. Qual é o módulo do vetor deslocamento, em km, que o navio deve percorrer nesse trecho final, do ponto C até o ponto D?"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "90", "blocos": [{"tipo": "texto", "valor": "90"}]}, {"letra": "B", "texto": "85", "blocos": [{"tipo": "texto", "valor": "85"}]}, {"letra": "C", "texto": "67", "blocos": [{"tipo": "texto", "valor": "67"}]}, {"letra": "D", "texto": "61", "blocos": [{"tipo": "texto", "valor": "61"}]}, {"letra": "E", "texto": "50", "blocos": [{"tipo": "texto", "valor": "50"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'E' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 10 from alvo, q;

-- Questão 11 (PETROBRAS) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 11)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'PETROBRAS', 'Um barco atravessa um rio com 40 m de largura em 10 segundos. Se a correnteza do rio possui uma velocidade de 3 m/s, a velocidade constante do barco, em m/s, vista da margem do rio será de',
         '[{"tipo": "texto", "valor": "Um barco atravessa um rio com 40 m de largura em 10 segundos. Se a correnteza do rio possui uma velocidade de 3 m/s, a velocidade constante do barco, em m/s, vista da margem do rio será de"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um barco atravessa um rio com 40 m de largura em 10 segundos. Se a correnteza do rio possui uma velocidade de 3 m/s, a velocidade constante do barco, em m/s, vista da margem do rio será de"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "3", "blocos": [{"tipo": "texto", "valor": "3"}]}, {"letra": "B", "texto": "4", "blocos": [{"tipo": "texto", "valor": "4"}]}, {"letra": "C", "texto": "5", "blocos": [{"tipo": "texto", "valor": "5"}]}, {"letra": "D", "texto": "6", "blocos": [{"tipo": "texto", "valor": "6"}]}, {"letra": "E", "texto": "8", "blocos": [{"tipo": "texto", "valor": "8"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'C' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 11 from alvo, q;

-- Questão 12 (LIQUIGAS) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 12)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'LIQUIGAS', 'Uma pessoa caminha num parque, num plano horizontal. Inicialmente, desloca-se de um ponto O até um ponto A, os quais distam entre si $d_A$. A seguir, muda a direção de sua caminhada e vai até o ponto B, que está a uma distância $d_B$ ($d_B < d_A$) do ponto A. Após esses dois deslocamentos, a que distância $d$ a pessoa estará, ao final da caminhada, desde o seu ponto de partida?',
         '[{"tipo": "texto", "valor": "Uma pessoa caminha num parque, num plano horizontal. Inicialmente, desloca-se de um ponto O até um ponto A, os quais distam entre si $d_A$. A seguir, muda a direção de sua caminhada e vai até o ponto B, que está a uma distância $d_B$ ($d_B < d_A$) do ponto A. Após esses dois deslocamentos, a que distância $d$ a pessoa estará, ao final da caminhada, desde o seu ponto de partida?"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Uma pessoa caminha num parque, num plano horizontal. Inicialmente, desloca-se de um ponto O até um ponto A, os quais distam entre si $d_A$. A seguir, muda a direção de sua caminhada e vai até o ponto B, que está a uma distância $d_B$ ($d_B < d_A$) do ponto A. Após esses dois deslocamentos, a que distância $d$ a pessoa estará, ao final da caminhada, desde o seu ponto de partida?"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$d = 0$", "blocos": [{"tipo": "texto", "valor": "$d = 0$"}]}, {"letra": "B", "texto": "$d = d_A - d_B$", "blocos": [{"tipo": "texto", "valor": "$d = d_A - d_B$"}]}, {"letra": "C", "texto": "$d \\geq d_A + d_B$", "blocos": [{"tipo": "texto", "valor": "$d \\geq d_A + d_B$"}]}, {"letra": "D", "texto": "$d = d_A + d_B$", "blocos": [{"tipo": "texto", "valor": "$d = d_A + d_B$"}]}, {"letra": "E", "texto": "$d_A - d_B \\leq d \\leq d_A + d_B$", "blocos": [{"tipo": "texto", "valor": "$d_A - d_B \\leq d \\leq d_A + d_B$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'E' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 12 from alvo, q;

-- Questão 13 (CESGRANRIO) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 13)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'CESGRANRIO', 'Um barco se move com velocidade de 2,0 km/h em relação à água e paralelamente às margens do rio. Ao se mover a favor da correnteza ou contra ela, suas velocidades em relação ao solo são, respectivamente, $v_1$ e $v_2$. Sabendo-se que a água do rio flui em paralelo à sua margem, com velocidade de 1,0 km/h, qual é a razão dos módulos $v_1/v_2$?',
         '[{"tipo": "texto", "valor": "Um barco se move com velocidade de 2,0 km/h em relação à água e paralelamente às margens do rio. Ao se mover a favor da correnteza ou contra ela, suas velocidades em relação ao solo são, respectivamente, $v_1$ e $v_2$. Sabendo-se que a água do rio flui em paralelo à sua margem, com velocidade de 1,0 km/h, qual é a razão dos módulos $v_1/v_2$?"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um barco se move com velocidade de 2,0 km/h em relação à água e paralelamente às margens do rio. Ao se mover a favor da correnteza ou contra ela, suas velocidades em relação ao solo são, respectivamente, $v_1$ e $v_2$. Sabendo-se que a água do rio flui em paralelo à sua margem, com velocidade de 1,0 km/h, qual é a razão dos módulos $v_1/v_2$?"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$1{,}0$", "blocos": [{"tipo": "texto", "valor": "$1{,}0$"}]}, {"letra": "B", "texto": "$2{,}0$", "blocos": [{"tipo": "texto", "valor": "$2{,}0$"}]}, {"letra": "C", "texto": "$3{,}0$", "blocos": [{"tipo": "texto", "valor": "$3{,}0$"}]}, {"letra": "D", "texto": "$4{,}0$", "blocos": [{"tipo": "texto", "valor": "$4{,}0$"}]}, {"letra": "E", "texto": "$5{,}0$", "blocos": [{"tipo": "texto", "valor": "$5{,}0$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'C' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 13 from alvo, q;

-- Questão 14 (LIQUIGAS) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 14)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'LIQUIGAS', 'A chuva de vento ocorre quando as gotas da água da chuva sofrem ação do vento enquanto caem. Em um determinado instante, uma das gotas de uma chuva de vento possui componentes horizontal e vertical da sua velocidade iguais a 1,50 m/s e 2,00 m/s, respectivamente. Qual é, aproximadamente, em m/s, o módulo do vetor velocidade dessa gota?',
         '[{"tipo": "texto", "valor": "A chuva de vento ocorre quando as gotas da água da chuva sofrem ação do vento enquanto caem. Em um determinado instante, uma das gotas de uma chuva de vento possui componentes horizontal e vertical da sua velocidade iguais a 1,50 m/s e 2,00 m/s, respectivamente. Qual é, aproximadamente, em m/s, o módulo do vetor velocidade dessa gota?"}]'::jsonb,
         '[{"tipo": "texto", "valor": "A chuva de vento ocorre quando as gotas da água da chuva sofrem ação do vento enquanto caem. Em um determinado instante, uma das gotas de uma chuva de vento possui componentes horizontal e vertical da sua velocidade iguais a 1,50 m/s e 2,00 m/s, respectivamente. Qual é, aproximadamente, em m/s, o módulo do vetor velocidade dessa gota?"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "6,25", "blocos": [{"tipo": "texto", "valor": "6,25"}]}, {"letra": "B", "texto": "5,50", "blocos": [{"tipo": "texto", "valor": "5,50"}]}, {"letra": "C", "texto": "3,50", "blocos": [{"tipo": "texto", "valor": "3,50"}]}, {"letra": "D", "texto": "2,50", "blocos": [{"tipo": "texto", "valor": "2,50"}]}, {"letra": "E", "texto": "1,75", "blocos": [{"tipo": "texto", "valor": "1,75"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'D' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 14 from alvo, q;

-- Questão 15 (SEDUC-RJ) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 15)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'SEDUC-RJ', 'Uma partícula está percorrendo a trajetória circular de centro em C e de raio R, mostrada na figura abaixo. Nela estão representados, por segmentos orientados, o vetor velocidade $\vec{V}$ e o vetor aceleração $\vec{a}$ da partícula no instante em que ela passa pela extremidade da direita do diâmetro horizontal. [FIGURA] O vetor $\vec{V}$ forma um ângulo de $150^\circ$ com o vetor $\vec{a}$. Sendo $|\vec{V}| = 12$ m/s e $|\vec{a}| = 8$ m/s$^2$, o raio R do círculo-trajetória mede:',
         '[{"tipo": "texto", "valor": "Uma partícula está percorrendo a trajetória circular de centro em C e de raio R, mostrada na figura abaixo. Nela estão representados, por segmentos orientados, o vetor velocidade $\\vec{V}$ e o vetor aceleração $\\vec{a}$ da partícula no instante em que ela passa pela extremidade da direita do diâmetro horizontal."}, {"tipo": "imagem", "valor": "/listas/lista-01/q15.png", "tamanho": "g"}, {"tipo": "texto", "valor": "O vetor $\\vec{V}$ forma um ângulo de $150^\\circ$ com o vetor $\\vec{a}$. Sendo $|\\vec{V}| = 12$ m/s e $|\\vec{a}| = 8$ m/s$^2$, o raio R do círculo-trajetória mede:"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Uma partícula está percorrendo a trajetória circular de centro em C e de raio R, mostrada na figura abaixo. Nela estão representados, por segmentos orientados, o vetor velocidade $\\vec{V}$ e o vetor aceleração $\\vec{a}$ da partícula no instante em que ela passa pela extremidade da direita do diâmetro horizontal."}, {"tipo": "imagem", "valor": "/listas/lista-01/q15.png", "tamanho": "g"}, {"tipo": "texto", "valor": "O vetor $\\vec{V}$ forma um ângulo de $150^\\circ$ com o vetor $\\vec{a}$. Sendo $|\\vec{V}| = 12$ m/s e $|\\vec{a}| = 8$ m/s$^2$, o raio R do círculo-trajetória mede:"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "18 m", "blocos": [{"tipo": "texto", "valor": "18 m"}]}, {"letra": "B", "texto": "24 m", "blocos": [{"tipo": "texto", "valor": "24 m"}]}, {"letra": "C", "texto": "36 m", "blocos": [{"tipo": "texto", "valor": "36 m"}]}, {"letra": "D", "texto": "48 m", "blocos": [{"tipo": "texto", "valor": "48 m"}]}, {"letra": "E", "texto": "72 m", "blocos": [{"tipo": "texto", "valor": "72 m"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'C' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 15 from alvo, q;

-- Questão 16 (DECEA) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 16)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'DECEA', 'Um helicóptero H se movimenta na descendente com velocidade inicial $\vec{v}$, de módulo 10 m/s, formando um ângulo de $3^\circ$ com a horizontal, conforme mostra a figura abaixo. A aceleração $\vec{a}$ do helicóptero é constante, horizontal e contrária ao movimento. Quando o helicóptero atinge o ponto P, 50 m abaixo da posição inicial, o seu movimento passa a ser vertical com aceleração zero. [FIGURA] Qual é, aproximadamente, em m, o deslocamento horizontal X do helicóptero?
Dados: $\cos 3^\circ = 1$; $\operatorname{sen} 3^\circ = 0{,}05$.',
         '[{"tipo": "texto", "valor": "Um helicóptero H se movimenta na descendente com velocidade inicial $\\vec{v}$, de módulo 10 m/s, formando um ângulo de $3^\\circ$ com a horizontal, conforme mostra a figura abaixo. A aceleração $\\vec{a}$ do helicóptero é constante, horizontal e contrária ao movimento. Quando o helicóptero atinge o ponto P, 50 m abaixo da posição inicial, o seu movimento passa a ser vertical com aceleração zero."}, {"tipo": "imagem", "valor": "/listas/lista-01/q16.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Qual é, aproximadamente, em m, o deslocamento horizontal X do helicóptero?\nDados: $\\cos 3^\\circ = 1$; $\\operatorname{sen} 3^\\circ = 0{,}05$."}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um helicóptero H se movimenta na descendente com velocidade inicial $\\vec{v}$, de módulo 10 m/s, formando um ângulo de $3^\\circ$ com a horizontal, conforme mostra a figura abaixo. A aceleração $\\vec{a}$ do helicóptero é constante, horizontal e contrária ao movimento. Quando o helicóptero atinge o ponto P, 50 m abaixo da posição inicial, o seu movimento passa a ser vertical com aceleração zero."}, {"tipo": "imagem", "valor": "/listas/lista-01/q16.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Qual é, aproximadamente, em m, o deslocamento horizontal X do helicóptero?\nDados: $\\cos 3^\\circ = 1$; $\\operatorname{sen} 3^\\circ = 0{,}05$."}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "32", "blocos": [{"tipo": "texto", "valor": "32"}]}, {"letra": "B", "texto": "50", "blocos": [{"tipo": "texto", "valor": "50"}]}, {"letra": "C", "texto": "167", "blocos": [{"tipo": "texto", "valor": "167"}]}, {"letra": "D", "texto": "500", "blocos": [{"tipo": "texto", "valor": "500"}]}, {"letra": "E", "texto": "1000", "blocos": [{"tipo": "texto", "valor": "1000"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'D' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 16 from alvo, q;

-- Questão 17 (PETROBRAS) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 17)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'PETROBRAS', 'Uma partícula percorre uma trajetória plana tal que seu vetor velocidade é descrito, temporalmente, no Sistema Internacional (SI), pela expressão $\vec{V} = (3t,\ 3t^2 - 7)$. No instante $t = 1$ s, a sua aceleração tangencial tem intensidade, em unidades do SI, igual a',
         '[{"tipo": "texto", "valor": "Uma partícula percorre uma trajetória plana tal que seu vetor velocidade é descrito, temporalmente, no Sistema Internacional (SI), pela expressão $\\vec{V} = (3t,\\ 3t^2 - 7)$. No instante $t = 1$ s, a sua aceleração tangencial tem intensidade, em unidades do SI, igual a"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Uma partícula percorre uma trajetória plana tal que seu vetor velocidade é descrito, temporalmente, no Sistema Internacional (SI), pela expressão $\\vec{V} = (3t,\\ 3t^2 - 7)$. No instante $t = 1$ s, a sua aceleração tangencial tem intensidade, em unidades do SI, igual a"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$3$", "blocos": [{"tipo": "texto", "valor": "$3$"}]}, {"letra": "B", "texto": "$5$", "blocos": [{"tipo": "texto", "valor": "$5$"}]}, {"letra": "C", "texto": "$\\sqrt{3}$", "blocos": [{"tipo": "texto", "valor": "$\\sqrt{3}$"}]}, {"letra": "D", "texto": "$\\sqrt{5}$", "blocos": [{"tipo": "texto", "valor": "$\\sqrt{5}$"}]}, {"letra": "E", "texto": "$5\\sqrt{3}$", "blocos": [{"tipo": "texto", "valor": "$5\\sqrt{3}$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'A' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 17 from alvo, q;

-- Questão 18 (EEAR) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 18)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'EEAR', 'Os radares são equipamentos imprescindíveis nos sistemas de controle de tráfego aéreo dos aeroportos modernos. Os radares funcionam pelo princípio da reflexão de ondas eletromagnéticas em objetos metálicos. Considere:
• a velocidade de propagação das ondas eletromagnéticas, no ar, como $v = 300\,000$ km/s; e
• que o avião está a 150 km de distância da antena.
O intervalo de tempo entre o envio da onda pela antena do radar e o recebimento pela mesma antena do sinal refletido no avião é, em milissegundos, igual a ______.',
         '[{"tipo": "texto", "valor": "Os radares são equipamentos imprescindíveis nos sistemas de controle de tráfego aéreo dos aeroportos modernos. Os radares funcionam pelo princípio da reflexão de ondas eletromagnéticas em objetos metálicos. Considere:\n• a velocidade de propagação das ondas eletromagnéticas, no ar, como $v = 300\\,000$ km/s; e\n• que o avião está a 150 km de distância da antena.\nO intervalo de tempo entre o envio da onda pela antena do radar e o recebimento pela mesma antena do sinal refletido no avião é, em milissegundos, igual a ______."}]'::jsonb,
         '[{"tipo": "texto", "valor": "Os radares são equipamentos imprescindíveis nos sistemas de controle de tráfego aéreo dos aeroportos modernos. Os radares funcionam pelo princípio da reflexão de ondas eletromagnéticas em objetos metálicos. Considere:\n• a velocidade de propagação das ondas eletromagnéticas, no ar, como $v = 300\\,000$ km/s; e\n• que o avião está a 150 km de distância da antena.\nO intervalo de tempo entre o envio da onda pela antena do radar e o recebimento pela mesma antena do sinal refletido no avião é, em milissegundos, igual a ______."}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "0,5", "blocos": [{"tipo": "texto", "valor": "0,5"}]}, {"letra": "B", "texto": "1,0", "blocos": [{"tipo": "texto", "valor": "1,0"}]}, {"letra": "C", "texto": "1,5", "blocos": [{"tipo": "texto", "valor": "1,5"}]}, {"letra": "D", "texto": "2,0", "blocos": [{"tipo": "texto", "valor": "2,0"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 18 from alvo, q;

-- Questão 19 (EEAR) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 19)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'EEAR', 'Os participantes de corrida de rua costumam estabelecer sua performance pela razão entre o tempo e o deslocamento percorrido em um trecho da prova. A tabela a seguir relaciona as informações de um desses corredores em função do tempo. A aceleração média, conforme a definição física de aceleração, desse corredor entre os instantes 12 e 18 minutos, em km/min$^2$, foi de [TABELA]',
         '[{"tipo": "texto", "valor": "Os participantes de corrida de rua costumam estabelecer sua performance pela razão entre o tempo e o deslocamento percorrido em um trecho da prova. A tabela a seguir relaciona as informações de um desses corredores em função do tempo. A aceleração média, conforme a definição física de aceleração, desse corredor entre os instantes 12 e 18 minutos, em km/min$^2$, foi de"}, {"tipo": "tabela", "valor": "Performance (min/km) | 4 | 5 | 6 | 5 | 4\nTempo (min) | 6 | 12 | 18 | 24 | 30", "cabecalho": "coluna"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Os participantes de corrida de rua costumam estabelecer sua performance pela razão entre o tempo e o deslocamento percorrido em um trecho da prova. A tabela a seguir relaciona as informações de um desses corredores em função do tempo. A aceleração média, conforme a definição física de aceleração, desse corredor entre os instantes 12 e 18 minutos, em km/min$^2$, foi de"}, {"tipo": "tabela", "valor": "Performance (min/km) | 4 | 5 | 6 | 5 | 4\nTempo (min) | 6 | 12 | 18 | 24 | 30", "cabecalho": "coluna"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$-1/180$", "blocos": [{"tipo": "texto", "valor": "$-1/180$"}]}, {"letra": "B", "texto": "$-1/6$", "blocos": [{"tipo": "texto", "valor": "$-1/6$"}]}, {"letra": "C", "texto": "$1/180$", "blocos": [{"tipo": "texto", "valor": "$1/180$"}]}, {"letra": "D", "texto": "$1/6$", "blocos": [{"tipo": "texto", "valor": "$1/6$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'A' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 19 from alvo, q;

-- Questão 20 (EEAR) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 20)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'EEAR', 'Duas crianças resolvem apostar corrida em uma praça cuja geometria é representada na figura abaixo. Sabendo que a criança I percorre o caminho ABC e que a criança II percorre o caminho AC, podemos afirmar que a diferença entre a distância percorrida pela criança I e a criança II vale, em metros: [FIGURA]',
         '[{"tipo": "texto", "valor": "Duas crianças resolvem apostar corrida em uma praça cuja geometria é representada na figura abaixo. Sabendo que a criança I percorre o caminho ABC e que a criança II percorre o caminho AC, podemos afirmar que a diferença entre a distância percorrida pela criança I e a criança II vale, em metros:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q20.png", "tamanho": "g"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Duas crianças resolvem apostar corrida em uma praça cuja geometria é representada na figura abaixo. Sabendo que a criança I percorre o caminho ABC e que a criança II percorre o caminho AC, podemos afirmar que a diferença entre a distância percorrida pela criança I e a criança II vale, em metros:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q20.png", "tamanho": "g"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "20", "blocos": [{"tipo": "texto", "valor": "20"}]}, {"letra": "B", "texto": "30", "blocos": [{"tipo": "texto", "valor": "30"}]}, {"letra": "C", "texto": "40", "blocos": [{"tipo": "texto", "valor": "40"}]}, {"letra": "D", "texto": "50", "blocos": [{"tipo": "texto", "valor": "50"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'A' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 20 from alvo, q;

-- Questão 21 (EEAR) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 21)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'EEAR', 'O conceito de grandezas vetoriais e escalares é fundamental no estudo da Física para garantir uma correta compreensão dos fenômenos e a precisa determinação das intensidades destas grandezas. Dentre as alternativas a seguir, assinale aquela que contém, do ponto de vista da Física, apenas grandezas escalares.',
         '[{"tipo": "texto", "valor": "O conceito de grandezas vetoriais e escalares é fundamental no estudo da Física para garantir uma correta compreensão dos fenômenos e a precisa determinação das intensidades destas grandezas. Dentre as alternativas a seguir, assinale aquela que contém, do ponto de vista da Física, apenas grandezas escalares."}]'::jsonb,
         '[{"tipo": "texto", "valor": "O conceito de grandezas vetoriais e escalares é fundamental no estudo da Física para garantir uma correta compreensão dos fenômenos e a precisa determinação das intensidades destas grandezas. Dentre as alternativas a seguir, assinale aquela que contém, do ponto de vista da Física, apenas grandezas escalares."}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "Massa, peso e tempo.", "blocos": [{"tipo": "texto", "valor": "Massa, peso e tempo."}]}, {"letra": "B", "texto": "Potência mecânica, comprimento e força.", "blocos": [{"tipo": "texto", "valor": "Potência mecânica, comprimento e força."}]}, {"letra": "C", "texto": "Intensidade da corrente elétrica, temperatura e velocidade.", "blocos": [{"tipo": "texto", "valor": "Intensidade da corrente elétrica, temperatura e velocidade."}]}, {"letra": "D", "texto": "Intensidade da corrente elétrica, potência mecânica e tempo.", "blocos": [{"tipo": "texto", "valor": "Intensidade da corrente elétrica, potência mecânica e tempo."}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'D' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 21 from alvo, q;

-- Questão 22 (CBM-MG) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 22)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'CBM-MG', 'Considere que um garoto desce um rio em uma pequena jangada cujas águas possuem velocidade constante de 10 km/h em todos os pontos e que esse garoto precisa ser resgatado. A equipe de salvamento do Corpo de Bombeiros Militar fará o resgate em um barco cuja velocidade própria é de 50 km/h. Analise a imagem a seguir. [FIGURA] Enquanto não chega à jangada, e para resgatar o garoto sem alterar a direção da proa do barco, o vetor velocidade desse barco deve apontar para o sentido',
         '[{"tipo": "texto", "valor": "Considere que um garoto desce um rio em uma pequena jangada cujas águas possuem velocidade constante de 10 km/h em todos os pontos e que esse garoto precisa ser resgatado. A equipe de salvamento do Corpo de Bombeiros Militar fará o resgate em um barco cuja velocidade própria é de 50 km/h. Analise a imagem a seguir."}, {"tipo": "imagem", "valor": "/listas/lista-01/q22.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Enquanto não chega à jangada, e para resgatar o garoto sem alterar a direção da proa do barco, o vetor velocidade desse barco deve apontar para o sentido"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Considere que um garoto desce um rio em uma pequena jangada cujas águas possuem velocidade constante de 10 km/h em todos os pontos e que esse garoto precisa ser resgatado. A equipe de salvamento do Corpo de Bombeiros Militar fará o resgate em um barco cuja velocidade própria é de 50 km/h. Analise a imagem a seguir."}, {"tipo": "imagem", "valor": "/listas/lista-01/q22.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Enquanto não chega à jangada, e para resgatar o garoto sem alterar a direção da proa do barco, o vetor velocidade desse barco deve apontar para o sentido"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "I, e o tempo gasto para atingir a jangada será o mesmo com ou sem correnteza.", "blocos": [{"tipo": "texto", "valor": "I, e o tempo gasto para atingir a jangada será o mesmo com ou sem correnteza."}]}, {"letra": "B", "texto": "I, e o tempo gasto para atingir a jangada será menor sem correnteza.", "blocos": [{"tipo": "texto", "valor": "I, e o tempo gasto para atingir a jangada será menor sem correnteza."}]}, {"letra": "C", "texto": "II, e o tempo gasto para atingir a jangada será o mesmo com ou sem correnteza.", "blocos": [{"tipo": "texto", "valor": "II, e o tempo gasto para atingir a jangada será o mesmo com ou sem correnteza."}]}, {"letra": "D", "texto": "II, e o tempo gasto para atingir a jangada será menor sem correnteza.", "blocos": [{"tipo": "texto", "valor": "II, e o tempo gasto para atingir a jangada será menor sem correnteza."}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'A' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 22 from alvo, q;

-- Questão 23 (PUC-MG) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 23)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'PUC-MG', 'Para o diagrama vetorial abaixo, a única igualdade correta é: [FIGURA]',
         '[{"tipo": "texto", "valor": "Para o diagrama vetorial abaixo, a única igualdade correta é:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q23.png", "tamanho": "g"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Para o diagrama vetorial abaixo, a única igualdade correta é:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q23.png", "tamanho": "g"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$\\vec{a} + \\vec{b} = \\vec{c}$", "blocos": [{"tipo": "texto", "valor": "$\\vec{a} + \\vec{b} = \\vec{c}$"}]}, {"letra": "B", "texto": "$\\vec{b} - \\vec{a} = \\vec{c}$", "blocos": [{"tipo": "texto", "valor": "$\\vec{b} - \\vec{a} = \\vec{c}$"}]}, {"letra": "C", "texto": "$\\vec{a} - \\vec{b} = \\vec{c}$", "blocos": [{"tipo": "texto", "valor": "$\\vec{a} - \\vec{b} = \\vec{c}$"}]}, {"letra": "D", "texto": "$\\vec{b} + \\vec{c} = -\\vec{a}$", "blocos": [{"tipo": "texto", "valor": "$\\vec{b} + \\vec{c} = -\\vec{a}$"}]}, {"letra": "E", "texto": "$\\vec{c} - \\vec{b} = \\vec{a}$", "blocos": [{"tipo": "texto", "valor": "$\\vec{c} - \\vec{b} = \\vec{a}$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 23 from alvo, q;

-- Questão 24 (PUC-Campinas) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 24)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'PUC-Campinas', 'Num bairro, todos os quarteirões são quadrados e as ruas paralelas distam 100 m umas das outras. Um transeunte faz o percurso de P a Q pela trajetória representada no esquema abaixo. [FIGURA] O deslocamento vetorial desse transeunte tem módulo, em metros, igual a:',
         '[{"tipo": "texto", "valor": "Num bairro, todos os quarteirões são quadrados e as ruas paralelas distam 100 m umas das outras. Um transeunte faz o percurso de P a Q pela trajetória representada no esquema abaixo."}, {"tipo": "imagem", "valor": "/listas/lista-01/q24.png", "tamanho": "g"}, {"tipo": "texto", "valor": "O deslocamento vetorial desse transeunte tem módulo, em metros, igual a:"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Num bairro, todos os quarteirões são quadrados e as ruas paralelas distam 100 m umas das outras. Um transeunte faz o percurso de P a Q pela trajetória representada no esquema abaixo."}, {"tipo": "imagem", "valor": "/listas/lista-01/q24.png", "tamanho": "g"}, {"tipo": "texto", "valor": "O deslocamento vetorial desse transeunte tem módulo, em metros, igual a:"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "300", "blocos": [{"tipo": "texto", "valor": "300"}]}, {"letra": "B", "texto": "350", "blocos": [{"tipo": "texto", "valor": "350"}]}, {"letra": "C", "texto": "400", "blocos": [{"tipo": "texto", "valor": "400"}]}, {"letra": "D", "texto": "500", "blocos": [{"tipo": "texto", "valor": "500"}]}, {"letra": "E", "texto": "700", "blocos": [{"tipo": "texto", "valor": "700"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'D' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 24 from alvo, q;

-- Questão 25 (MARINHA) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 25)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'MARINHA', 'Sabe-se que dois navios estão prestes a colidir. No instante $t = 0$ s, o navio A está na origem do sistema de coordenadas cartesianas ($x_A = 0$, $y_A = 0$), em movimento retilíneo uniforme, com velocidade de módulo $v_A = 50$ m/s, e o navio B está na posição ($x_B = 400$ m, $y_B = 1000$ m), também em movimento retilíneo uniforme, com velocidade $v_B$. Após $\Delta t$ segundos, há a colisão no ponto ($x_C = 800$ m, $y_C = 600$ m). Qual é o módulo da velocidade $v_B$, em m/s?',
         '[{"tipo": "texto", "valor": "Sabe-se que dois navios estão prestes a colidir. No instante $t = 0$ s, o navio A está na origem do sistema de coordenadas cartesianas ($x_A = 0$, $y_A = 0$), em movimento retilíneo uniforme, com velocidade de módulo $v_A = 50$ m/s, e o navio B está na posição ($x_B = 400$ m, $y_B = 1000$ m), também em movimento retilíneo uniforme, com velocidade $v_B$. Após $\\Delta t$ segundos, há a colisão no ponto ($x_C = 800$ m, $y_C = 600$ m). Qual é o módulo da velocidade $v_B$, em m/s?"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Sabe-se que dois navios estão prestes a colidir. No instante $t = 0$ s, o navio A está na origem do sistema de coordenadas cartesianas ($x_A = 0$, $y_A = 0$), em movimento retilíneo uniforme, com velocidade de módulo $v_A = 50$ m/s, e o navio B está na posição ($x_B = 400$ m, $y_B = 1000$ m), também em movimento retilíneo uniforme, com velocidade $v_B$. Após $\\Delta t$ segundos, há a colisão no ponto ($x_C = 800$ m, $y_C = 600$ m). Qual é o módulo da velocidade $v_B$, em m/s?"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "20,0", "blocos": [{"tipo": "texto", "valor": "20,0"}]}, {"letra": "B", "texto": "28,3", "blocos": [{"tipo": "texto", "valor": "28,3"}]}, {"letra": "C", "texto": "36,3", "blocos": [{"tipo": "texto", "valor": "36,3"}]}, {"letra": "D", "texto": "40,0", "blocos": [{"tipo": "texto", "valor": "40,0"}]}, {"letra": "E", "texto": "56,6", "blocos": [{"tipo": "texto", "valor": "56,6"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 25 from alvo, q;

-- Questão 26 (MARINHA) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 26)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'MARINHA', 'Observe a figura abaixo. [FIGURA] Considere a seguinte situação hipotética, representada pela figura acima: um navio de guerra detecta a aproximação de uma aeronave hostil, com velocidade constante de $216\sqrt{3}$ km/h e altitude constante de 500 m. Quando esta aeronave está a $1100\sqrt{3}$ metros de distância do navio, na horizontal, conforme mostra a figura, um míssil é lançado com velocidade inicial zero. O míssil tem propulsão própria e está programado para manter uma trajetória retilínea de inclinação $\theta$ e com aceleração constante $\vec{a}$. A altura do navio é desprezível, comparada com a altitude de voo. Sabendo que, após 10 s de lançado, o míssil intercepta a aeronave, qual é o módulo da aceleração $\vec{a}$, em m/s$^2$?',
         '[{"tipo": "texto", "valor": "Observe a figura abaixo."}, {"tipo": "imagem", "valor": "/listas/lista-01/q26.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Considere a seguinte situação hipotética, representada pela figura acima: um navio de guerra detecta a aproximação de uma aeronave hostil, com velocidade constante de $216\\sqrt{3}$ km/h e altitude constante de 500 m. Quando esta aeronave está a $1100\\sqrt{3}$ metros de distância do navio, na horizontal, conforme mostra a figura, um míssil é lançado com velocidade inicial zero. O míssil tem propulsão própria e está programado para manter uma trajetória retilínea de inclinação $\\theta$ e com aceleração constante $\\vec{a}$. A altura do navio é desprezível, comparada com a altitude de voo. Sabendo que, após 10 s de lançado, o míssil intercepta a aeronave, qual é o módulo da aceleração $\\vec{a}$, em m/s$^2$?"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Observe a figura abaixo."}, {"tipo": "imagem", "valor": "/listas/lista-01/q26.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Considere a seguinte situação hipotética, representada pela figura acima: um navio de guerra detecta a aproximação de uma aeronave hostil, com velocidade constante de $216\\sqrt{3}$ km/h e altitude constante de 500 m. Quando esta aeronave está a $1100\\sqrt{3}$ metros de distância do navio, na horizontal, conforme mostra a figura, um míssil é lançado com velocidade inicial zero. O míssil tem propulsão própria e está programado para manter uma trajetória retilínea de inclinação $\\theta$ e com aceleração constante $\\vec{a}$. A altura do navio é desprezível, comparada com a altitude de voo. Sabendo que, após 10 s de lançado, o míssil intercepta a aeronave, qual é o módulo da aceleração $\\vec{a}$, em m/s$^2$?"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "5", "blocos": [{"tipo": "texto", "valor": "5"}]}, {"letra": "B", "texto": "10", "blocos": [{"tipo": "texto", "valor": "10"}]}, {"letra": "C", "texto": "20", "blocos": [{"tipo": "texto", "valor": "20"}]}, {"letra": "D", "texto": "30", "blocos": [{"tipo": "texto", "valor": "30"}]}, {"letra": "E", "texto": "40", "blocos": [{"tipo": "texto", "valor": "40"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'C' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 26 from alvo, q;

-- Questão 27 (EEAR) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 27)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'EEAR', 'Um nadador A atravessa diagonalmente uma piscina percorrendo um total de 45 m. Um corredor B sai ao mesmo tempo e do mesmo ponto do nadador, percorrendo a borda da piscina que tem 27 m de largura, chegando os dois no mesmo ponto ao mesmo tempo, como mostra a figura: [FIGURA] A diferença entre a distância percorrida pelo corredor B e pelo nadador A é, em metros:',
         '[{"tipo": "texto", "valor": "Um nadador A atravessa diagonalmente uma piscina percorrendo um total de 45 m. Um corredor B sai ao mesmo tempo e do mesmo ponto do nadador, percorrendo a borda da piscina que tem 27 m de largura, chegando os dois no mesmo ponto ao mesmo tempo, como mostra a figura:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q27.png", "tamanho": "g"}, {"tipo": "texto", "valor": "A diferença entre a distância percorrida pelo corredor B e pelo nadador A é, em metros:"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um nadador A atravessa diagonalmente uma piscina percorrendo um total de 45 m. Um corredor B sai ao mesmo tempo e do mesmo ponto do nadador, percorrendo a borda da piscina que tem 27 m de largura, chegando os dois no mesmo ponto ao mesmo tempo, como mostra a figura:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q27.png", "tamanho": "g"}, {"tipo": "texto", "valor": "A diferença entre a distância percorrida pelo corredor B e pelo nadador A é, em metros:"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "9", "blocos": [{"tipo": "texto", "valor": "9"}]}, {"letra": "B", "texto": "18", "blocos": [{"tipo": "texto", "valor": "18"}]}, {"letra": "C", "texto": "27", "blocos": [{"tipo": "texto", "valor": "27"}]}, {"letra": "D", "texto": "36", "blocos": [{"tipo": "texto", "valor": "36"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 27 from alvo, q;

-- Questão 28 (EEAR) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 28)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'EEAR', 'Um jovem desejando chegar a um determinado endereço recebe a seguinte orientação: “Para chegar ao destino desejado basta, a partir daqui, caminhar, em linha reta, uma distância de 300 metros. Em seguida, vire à direita, num ângulo de $90^\circ$, e percorra uma distância, em linha reta, de 400 metros.” Seguindo o trajeto proposto, o jovem chegou ao seu destino, onde percebeu que a distância, em uma única linha reta, do ponto de partida até o seu destino final, era de ______ metros.',
         '[{"tipo": "texto", "valor": "Um jovem desejando chegar a um determinado endereço recebe a seguinte orientação: “Para chegar ao destino desejado basta, a partir daqui, caminhar, em linha reta, uma distância de 300 metros. Em seguida, vire à direita, num ângulo de $90^\\circ$, e percorra uma distância, em linha reta, de 400 metros.” Seguindo o trajeto proposto, o jovem chegou ao seu destino, onde percebeu que a distância, em uma única linha reta, do ponto de partida até o seu destino final, era de ______ metros."}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um jovem desejando chegar a um determinado endereço recebe a seguinte orientação: “Para chegar ao destino desejado basta, a partir daqui, caminhar, em linha reta, uma distância de 300 metros. Em seguida, vire à direita, num ângulo de $90^\\circ$, e percorra uma distância, em linha reta, de 400 metros.” Seguindo o trajeto proposto, o jovem chegou ao seu destino, onde percebeu que a distância, em uma única linha reta, do ponto de partida até o seu destino final, era de ______ metros."}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "700", "blocos": [{"tipo": "texto", "valor": "700"}]}, {"letra": "B", "texto": "500", "blocos": [{"tipo": "texto", "valor": "500"}]}, {"letra": "C", "texto": "400", "blocos": [{"tipo": "texto", "valor": "400"}]}, {"letra": "D", "texto": "300", "blocos": [{"tipo": "texto", "valor": "300"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 28 from alvo, q;

-- Questão 29 (AFA) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 29)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'AFA', 'Um carro percorre uma curva circular com velocidade linear constante de 15 m/s completando-a em $5\sqrt{2}$ s, conforme figura abaixo. [FIGURA] É correto afirmar que o módulo da aceleração média experimentada pelo carro nesse trecho, em m/s$^2$, é',
         '[{"tipo": "texto", "valor": "Um carro percorre uma curva circular com velocidade linear constante de 15 m/s completando-a em $5\\sqrt{2}$ s, conforme figura abaixo."}, {"tipo": "imagem", "valor": "/listas/lista-01/q29.png", "tamanho": "g"}, {"tipo": "texto", "valor": "É correto afirmar que o módulo da aceleração média experimentada pelo carro nesse trecho, em m/s$^2$, é"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um carro percorre uma curva circular com velocidade linear constante de 15 m/s completando-a em $5\\sqrt{2}$ s, conforme figura abaixo."}, {"tipo": "imagem", "valor": "/listas/lista-01/q29.png", "tamanho": "g"}, {"tipo": "texto", "valor": "É correto afirmar que o módulo da aceleração média experimentada pelo carro nesse trecho, em m/s$^2$, é"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "0", "blocos": [{"tipo": "texto", "valor": "0"}]}, {"letra": "B", "texto": "1,8", "blocos": [{"tipo": "texto", "valor": "1,8"}]}, {"letra": "C", "texto": "3,0", "blocos": [{"tipo": "texto", "valor": "3,0"}]}, {"letra": "D", "texto": "5,3", "blocos": [{"tipo": "texto", "valor": "5,3"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'C' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 29 from alvo, q;

-- Questão 30 (AFA) · Nível 2
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 30)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'medio', 2, 'AFA', 'Um turista, passeando de bugre pelas areias de uma praia em Natal (RN), percorre uma trajetória triangular, que pode ser dividida em três trechos, conforme a figura abaixo. [FIGURA] Os trechos B e C possuem o mesmo comprimento, mas as velocidades médias desenvolvidas nos trechos A, B e C foram, respectivamente, $v$, $2v$ e $v$. A velocidade escalar média desenvolvida pelo turista para percorrer toda a trajetória triangular vale',
         '[{"tipo": "texto", "valor": "Um turista, passeando de bugre pelas areias de uma praia em Natal (RN), percorre uma trajetória triangular, que pode ser dividida em três trechos, conforme a figura abaixo."}, {"tipo": "imagem", "valor": "/listas/lista-01/q30.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Os trechos B e C possuem o mesmo comprimento, mas as velocidades médias desenvolvidas nos trechos A, B e C foram, respectivamente, $v$, $2v$ e $v$. A velocidade escalar média desenvolvida pelo turista para percorrer toda a trajetória triangular vale"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um turista, passeando de bugre pelas areias de uma praia em Natal (RN), percorre uma trajetória triangular, que pode ser dividida em três trechos, conforme a figura abaixo."}, {"tipo": "imagem", "valor": "/listas/lista-01/q30.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Os trechos B e C possuem o mesmo comprimento, mas as velocidades médias desenvolvidas nos trechos A, B e C foram, respectivamente, $v$, $2v$ e $v$. A velocidade escalar média desenvolvida pelo turista para percorrer toda a trajetória triangular vale"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$v\\sqrt{2}$", "blocos": [{"tipo": "texto", "valor": "$v\\sqrt{2}$"}]}, {"letra": "B", "texto": "$2v\\sqrt{2}$", "blocos": [{"tipo": "texto", "valor": "$2v\\sqrt{2}$"}]}, {"letra": "C", "texto": "$4v$", "blocos": [{"tipo": "texto", "valor": "$4v$"}]}, {"letra": "D", "texto": "$(4 - 2\\sqrt{2})\\,v$", "blocos": [{"tipo": "texto", "valor": "$(4 - 2\\sqrt{2})\\,v$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'D' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 30 from alvo, q;

-- Questão 31 (UFPB) · Nível 3
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 31)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 3, 'UFPB', 'Considere os vetores $\vec{A}$, $\vec{B}$ e $\vec{F}$, nos diagramas numerados de I a IV. [FIGURA] Os diagramas que, corretamente, representam a relação vetorial $\vec{F} = \vec{A} - \vec{B}$ são apenas:',
         '[{"tipo": "texto", "valor": "Considere os vetores $\\vec{A}$, $\\vec{B}$ e $\\vec{F}$, nos diagramas numerados de I a IV."}, {"tipo": "imagem", "valor": "/listas/lista-01/q31.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Os diagramas que, corretamente, representam a relação vetorial $\\vec{F} = \\vec{A} - \\vec{B}$ são apenas:"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Considere os vetores $\\vec{A}$, $\\vec{B}$ e $\\vec{F}$, nos diagramas numerados de I a IV."}, {"tipo": "imagem", "valor": "/listas/lista-01/q31.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Os diagramas que, corretamente, representam a relação vetorial $\\vec{F} = \\vec{A} - \\vec{B}$ são apenas:"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "I e III", "blocos": [{"tipo": "texto", "valor": "I e III"}]}, {"letra": "B", "texto": "II e IV", "blocos": [{"tipo": "texto", "valor": "II e IV"}]}, {"letra": "C", "texto": "II e III", "blocos": [{"tipo": "texto", "valor": "II e III"}]}, {"letra": "D", "texto": "III e IV", "blocos": [{"tipo": "texto", "valor": "III e IV"}]}, {"letra": "E", "texto": "I e IV", "blocos": [{"tipo": "texto", "valor": "I e IV"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'C' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 31 from alvo, q;

-- Questão 32 (PUC-RJ) · Nível 3
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 32)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 3, 'PUC-RJ', 'Os ponteiros de hora e minuto de um relógio suíço têm, respectivamente, 1 cm e 2 cm. Supondo que cada ponteiro do relógio é um vetor que sai do centro do relógio e aponta na direção dos números na extremidade do relógio, determine o vetor resultante da soma dos dois vetores correspondentes aos ponteiros de hora e minuto quando o relógio marca 6 horas.',
         '[{"tipo": "texto", "valor": "Os ponteiros de hora e minuto de um relógio suíço têm, respectivamente, 1 cm e 2 cm. Supondo que cada ponteiro do relógio é um vetor que sai do centro do relógio e aponta na direção dos números na extremidade do relógio, determine o vetor resultante da soma dos dois vetores correspondentes aos ponteiros de hora e minuto quando o relógio marca 6 horas."}]'::jsonb,
         '[{"tipo": "texto", "valor": "Os ponteiros de hora e minuto de um relógio suíço têm, respectivamente, 1 cm e 2 cm. Supondo que cada ponteiro do relógio é um vetor que sai do centro do relógio e aponta na direção dos números na extremidade do relógio, determine o vetor resultante da soma dos dois vetores correspondentes aos ponteiros de hora e minuto quando o relógio marca 6 horas."}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "O vetor tem módulo 1 cm e aponta na direção do número 12 do relógio.", "blocos": [{"tipo": "texto", "valor": "O vetor tem módulo 1 cm e aponta na direção do número 12 do relógio."}]}, {"letra": "B", "texto": "O vetor tem módulo 2 cm e aponta na direção do número 12 do relógio.", "blocos": [{"tipo": "texto", "valor": "O vetor tem módulo 2 cm e aponta na direção do número 12 do relógio."}]}, {"letra": "C", "texto": "O vetor tem módulo 1 cm e aponta na direção do número 6 do relógio.", "blocos": [{"tipo": "texto", "valor": "O vetor tem módulo 1 cm e aponta na direção do número 6 do relógio."}]}, {"letra": "D", "texto": "O vetor tem módulo 2 cm e aponta na direção do número 6 do relógio.", "blocos": [{"tipo": "texto", "valor": "O vetor tem módulo 2 cm e aponta na direção do número 6 do relógio."}]}, {"letra": "E", "texto": "O vetor tem módulo 1,5 cm e aponta na direção do número 6 do relógio.", "blocos": [{"tipo": "texto", "valor": "O vetor tem módulo 1,5 cm e aponta na direção do número 6 do relógio."}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'A' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 32 from alvo, q;

-- Questão 33 (UFC) · Nível 3
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 33)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 3, 'UFC', '$\vec{M}$ e $\vec{N}$ são vetores de módulos iguais ($|\vec{M}| = |\vec{N}| = M$). O vetor $\vec{M}$ é fixo e o vetor $\vec{N}$ pode girar em torno do ponto O (veja a figura) no plano formado por $\vec{M}$ e $\vec{N}$. Sendo $\vec{R} = \vec{M} + \vec{N}$, indique, entre os gráficos a seguir, aquele que pode representar a variação de $|\vec{R}|$ como função do ângulo $\theta$ entre $\vec{M}$ e $\vec{N}$. [FIGURA]',
         '[{"tipo": "texto", "valor": "$\\vec{M}$ e $\\vec{N}$ são vetores de módulos iguais ($|\\vec{M}| = |\\vec{N}| = M$). O vetor $\\vec{M}$ é fixo e o vetor $\\vec{N}$ pode girar em torno do ponto O (veja a figura) no plano formado por $\\vec{M}$ e $\\vec{N}$. Sendo $\\vec{R} = \\vec{M} + \\vec{N}$, indique, entre os gráficos a seguir, aquele que pode representar a variação de $|\\vec{R}|$ como função do ângulo $\\theta$ entre $\\vec{M}$ e $\\vec{N}$."}, {"tipo": "imagem", "valor": "/listas/lista-01/q33.png", "tamanho": "g"}]'::jsonb,
         '[{"tipo": "texto", "valor": "$\\vec{M}$ e $\\vec{N}$ são vetores de módulos iguais ($|\\vec{M}| = |\\vec{N}| = M$). O vetor $\\vec{M}$ é fixo e o vetor $\\vec{N}$ pode girar em torno do ponto O (veja a figura) no plano formado por $\\vec{M}$ e $\\vec{N}$. Sendo $\\vec{R} = \\vec{M} + \\vec{N}$, indique, entre os gráficos a seguir, aquele que pode representar a variação de $|\\vec{R}|$ como função do ângulo $\\theta$ entre $\\vec{M}$ e $\\vec{N}$."}, {"tipo": "imagem", "valor": "/listas/lista-01/q33.png", "tamanho": "g"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "[FIGURA]", "blocos": [{"tipo": "imagem", "valor": "/listas/lista-01/q33a.png", "tamanho": "m"}]}, {"letra": "B", "texto": "[FIGURA]", "blocos": [{"tipo": "imagem", "valor": "/listas/lista-01/q33b.png", "tamanho": "m"}]}, {"letra": "C", "texto": "[FIGURA]", "blocos": [{"tipo": "imagem", "valor": "/listas/lista-01/q33c.png", "tamanho": "m"}]}, {"letra": "D", "texto": "[FIGURA]", "blocos": [{"tipo": "imagem", "valor": "/listas/lista-01/q33d.png", "tamanho": "m"}]}, {"letra": "E", "texto": "[FIGURA]", "blocos": [{"tipo": "imagem", "valor": "/listas/lista-01/q33e.png", "tamanho": "m"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 33 from alvo, q;

-- Questão 34 (UNESP) · Nível 3
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 34)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 3, 'UNESP', 'Um caminhoneiro efetuou duas entregas de mercadorias e, para isso, seguiu o itinerário indicado pelos vetores deslocamentos $\vec{d}_1$ e $\vec{d}_2$ ilustrados na figura. [FIGURA] Para a primeira entrega, ele deslocou-se 10 km e, para a segunda entrega, percorreu uma distância de 6 km. Ao final da segunda entrega, a distância a que o caminhoneiro se encontra do ponto de partida é',
         '[{"tipo": "texto", "valor": "Um caminhoneiro efetuou duas entregas de mercadorias e, para isso, seguiu o itinerário indicado pelos vetores deslocamentos $\\vec{d}_1$ e $\\vec{d}_2$ ilustrados na figura."}, {"tipo": "imagem", "valor": "/listas/lista-01/q34.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Para a primeira entrega, ele deslocou-se 10 km e, para a segunda entrega, percorreu uma distância de 6 km. Ao final da segunda entrega, a distância a que o caminhoneiro se encontra do ponto de partida é"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um caminhoneiro efetuou duas entregas de mercadorias e, para isso, seguiu o itinerário indicado pelos vetores deslocamentos $\\vec{d}_1$ e $\\vec{d}_2$ ilustrados na figura."}, {"tipo": "imagem", "valor": "/listas/lista-01/q34.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Para a primeira entrega, ele deslocou-se 10 km e, para a segunda entrega, percorreu uma distância de 6 km. Ao final da segunda entrega, a distância a que o caminhoneiro se encontra do ponto de partida é"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "4 km", "blocos": [{"tipo": "texto", "valor": "4 km"}]}, {"letra": "B", "texto": "8 km", "blocos": [{"tipo": "texto", "valor": "8 km"}]}, {"letra": "C", "texto": "$2\\sqrt{19}$ km", "blocos": [{"tipo": "texto", "valor": "$2\\sqrt{19}$ km"}]}, {"letra": "D", "texto": "$8\\sqrt{3}$ km", "blocos": [{"tipo": "texto", "valor": "$8\\sqrt{3}$ km"}]}, {"letra": "E", "texto": "16 km", "blocos": [{"tipo": "texto", "valor": "16 km"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'C' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 34 from alvo, q;

-- Questão 35 (FATEC) · Nível 3
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 35)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 3, 'FATEC', 'Dados os vetores $\vec{A}$, $\vec{B}$ e $\vec{C}$, representados na figura em que cada quadrícula apresenta lado correspondente a uma unidade de medida, é correto afirmar que a resultante dos vetores tem módulo: [FIGURA]',
         '[{"tipo": "texto", "valor": "Dados os vetores $\\vec{A}$, $\\vec{B}$ e $\\vec{C}$, representados na figura em que cada quadrícula apresenta lado correspondente a uma unidade de medida, é correto afirmar que a resultante dos vetores tem módulo:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q35.png", "tamanho": "g"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Dados os vetores $\\vec{A}$, $\\vec{B}$ e $\\vec{C}$, representados na figura em que cada quadrícula apresenta lado correspondente a uma unidade de medida, é correto afirmar que a resultante dos vetores tem módulo:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q35.png", "tamanho": "g"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "1", "blocos": [{"tipo": "texto", "valor": "1"}]}, {"letra": "B", "texto": "2", "blocos": [{"tipo": "texto", "valor": "2"}]}, {"letra": "C", "texto": "3", "blocos": [{"tipo": "texto", "valor": "3"}]}, {"letra": "D", "texto": "4", "blocos": [{"tipo": "texto", "valor": "4"}]}, {"letra": "E", "texto": "6", "blocos": [{"tipo": "texto", "valor": "6"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'A' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 35 from alvo, q;

-- Questão 36 (TRANSPETRO) · Nível 3
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 36)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 3, 'TRANSPETRO', 'A figura abaixo mostra um guindaste, que consiste em um trilho horizontal indeformável, que está a uma altura H, constante, do solo, por onde se desloca um carro T. Um cabo de aço inextensível sustenta a carga P. O operador do guindaste comanda tanto a velocidade horizontal do carro T quanto a velocidade de descida/subida da carga P. [FIGURA] Sabendo-se que a velocidade $V_P$ da carga P em relação ao trilho e a velocidade absoluta do carro $V_T$ são constantes e respectivamente iguais a 0,4 m/s e 0,3 m/s, o módulo da velocidade absoluta, em m/s, da carga P é igual a',
         '[{"tipo": "texto", "valor": "A figura abaixo mostra um guindaste, que consiste em um trilho horizontal indeformável, que está a uma altura H, constante, do solo, por onde se desloca um carro T. Um cabo de aço inextensível sustenta a carga P. O operador do guindaste comanda tanto a velocidade horizontal do carro T quanto a velocidade de descida/subida da carga P."}, {"tipo": "imagem", "valor": "/listas/lista-01/q36.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Sabendo-se que a velocidade $V_P$ da carga P em relação ao trilho e a velocidade absoluta do carro $V_T$ são constantes e respectivamente iguais a 0,4 m/s e 0,3 m/s, o módulo da velocidade absoluta, em m/s, da carga P é igual a"}]'::jsonb,
         '[{"tipo": "texto", "valor": "A figura abaixo mostra um guindaste, que consiste em um trilho horizontal indeformável, que está a uma altura H, constante, do solo, por onde se desloca um carro T. Um cabo de aço inextensível sustenta a carga P. O operador do guindaste comanda tanto a velocidade horizontal do carro T quanto a velocidade de descida/subida da carga P."}, {"tipo": "imagem", "valor": "/listas/lista-01/q36.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Sabendo-se que a velocidade $V_P$ da carga P em relação ao trilho e a velocidade absoluta do carro $V_T$ são constantes e respectivamente iguais a 0,4 m/s e 0,3 m/s, o módulo da velocidade absoluta, em m/s, da carga P é igual a"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "0,1", "blocos": [{"tipo": "texto", "valor": "0,1"}]}, {"letra": "B", "texto": "0,5", "blocos": [{"tipo": "texto", "valor": "0,5"}]}, {"letra": "C", "texto": "0,7", "blocos": [{"tipo": "texto", "valor": "0,7"}]}, {"letra": "D", "texto": "1,6", "blocos": [{"tipo": "texto", "valor": "1,6"}]}, {"letra": "E", "texto": "2,5", "blocos": [{"tipo": "texto", "valor": "2,5"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 36 from alvo, q;

-- Questão 37 (PETROBRAS) · Nível 3
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 37)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 3, 'PETROBRAS', 'Considere os vetores $\vec{u} = (1, -2, 3)$ e $\vec{v} = (1, 1, 3)$. Um vetor $\vec{w}$ do $\mathbb{R}^3$ é simultaneamente normal aos vetores $\vec{u}$ e $\vec{v}$ e possui componente $z$ igual a 1. A soma das duas outras componentes do vetor $\vec{w}$ é',
         '[{"tipo": "texto", "valor": "Considere os vetores $\\vec{u} = (1, -2, 3)$ e $\\vec{v} = (1, 1, 3)$. Um vetor $\\vec{w}$ do $\\mathbb{R}^3$ é simultaneamente normal aos vetores $\\vec{u}$ e $\\vec{v}$ e possui componente $z$ igual a 1. A soma das duas outras componentes do vetor $\\vec{w}$ é"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Considere os vetores $\\vec{u} = (1, -2, 3)$ e $\\vec{v} = (1, 1, 3)$. Um vetor $\\vec{w}$ do $\\mathbb{R}^3$ é simultaneamente normal aos vetores $\\vec{u}$ e $\\vec{v}$ e possui componente $z$ igual a 1. A soma das duas outras componentes do vetor $\\vec{w}$ é"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$-9$", "blocos": [{"tipo": "texto", "valor": "$-9$"}]}, {"letra": "B", "texto": "$-3$", "blocos": [{"tipo": "texto", "valor": "$-3$"}]}, {"letra": "C", "texto": "$0$", "blocos": [{"tipo": "texto", "valor": "$0$"}]}, {"letra": "D", "texto": "$3$", "blocos": [{"tipo": "texto", "valor": "$3$"}]}, {"letra": "E", "texto": "$9$", "blocos": [{"tipo": "texto", "valor": "$9$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 37 from alvo, q;

-- Questão 38 (EFOMM) · Nível 3
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 38)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 3, 'EFOMM', 'Observe a figura a seguir. [FIGURA] Um helicóptero decola de sua base, que está ao nível do mar, com uma aceleração constante de 2,0 m/s$^2$, fazendo um ângulo de $30^\circ$ com a horizontal, conforme indica a figura acima. Após 10 segundos, qual será a altitude do helicóptero, em metros?
Dados: $\operatorname{sen} 30^\circ = 0{,}50$ e $\cos 30^\circ = 0{,}87$.',
         '[{"tipo": "texto", "valor": "Observe a figura a seguir."}, {"tipo": "imagem", "valor": "/listas/lista-01/q38.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Um helicóptero decola de sua base, que está ao nível do mar, com uma aceleração constante de 2,0 m/s$^2$, fazendo um ângulo de $30^\\circ$ com a horizontal, conforme indica a figura acima. Após 10 segundos, qual será a altitude do helicóptero, em metros?\nDados: $\\operatorname{sen} 30^\\circ = 0{,}50$ e $\\cos 30^\\circ = 0{,}87$."}]'::jsonb,
         '[{"tipo": "texto", "valor": "Observe a figura a seguir."}, {"tipo": "imagem", "valor": "/listas/lista-01/q38.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Um helicóptero decola de sua base, que está ao nível do mar, com uma aceleração constante de 2,0 m/s$^2$, fazendo um ângulo de $30^\\circ$ com a horizontal, conforme indica a figura acima. Após 10 segundos, qual será a altitude do helicóptero, em metros?\nDados: $\\operatorname{sen} 30^\\circ = 0{,}50$ e $\\cos 30^\\circ = 0{,}87$."}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "38", "blocos": [{"tipo": "texto", "valor": "38"}]}, {"letra": "B", "texto": "45", "blocos": [{"tipo": "texto", "valor": "45"}]}, {"letra": "C", "texto": "50", "blocos": [{"tipo": "texto", "valor": "50"}]}, {"letra": "D", "texto": "72", "blocos": [{"tipo": "texto", "valor": "72"}]}, {"letra": "E", "texto": "87", "blocos": [{"tipo": "texto", "valor": "87"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'C' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 38 from alvo, q;

-- Questão 39 (EsPCEx) · Nível 3
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 39)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 3, 'EsPCEx', 'Um bote de assalto deve atravessar um rio de largura igual a 800 m, numa trajetória perpendicular à sua margem, num intervalo de tempo de 1 minuto e 40 segundos, com velocidade constante. Considerando o bote como uma partícula, desprezando a resistência do ar e sendo constante e igual a 6 m/s a velocidade da correnteza do rio em relação à sua margem, o módulo da velocidade do bote em relação à água do rio deverá ser de: [FIGURA]',
         '[{"tipo": "texto", "valor": "Um bote de assalto deve atravessar um rio de largura igual a 800 m, numa trajetória perpendicular à sua margem, num intervalo de tempo de 1 minuto e 40 segundos, com velocidade constante. Considerando o bote como uma partícula, desprezando a resistência do ar e sendo constante e igual a 6 m/s a velocidade da correnteza do rio em relação à sua margem, o módulo da velocidade do bote em relação à água do rio deverá ser de:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q39.png", "tamanho": "g"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um bote de assalto deve atravessar um rio de largura igual a 800 m, numa trajetória perpendicular à sua margem, num intervalo de tempo de 1 minuto e 40 segundos, com velocidade constante. Considerando o bote como uma partícula, desprezando a resistência do ar e sendo constante e igual a 6 m/s a velocidade da correnteza do rio em relação à sua margem, o módulo da velocidade do bote em relação à água do rio deverá ser de:"}, {"tipo": "imagem", "valor": "/listas/lista-01/q39.png", "tamanho": "g"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "4 m/s", "blocos": [{"tipo": "texto", "valor": "4 m/s"}]}, {"letra": "B", "texto": "6 m/s", "blocos": [{"tipo": "texto", "valor": "6 m/s"}]}, {"letra": "C", "texto": "8 m/s", "blocos": [{"tipo": "texto", "valor": "8 m/s"}]}, {"letra": "D", "texto": "10 m/s", "blocos": [{"tipo": "texto", "valor": "10 m/s"}]}, {"letra": "E", "texto": "14 m/s", "blocos": [{"tipo": "texto", "valor": "14 m/s"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'D' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 39 from alvo, q;

-- Questão 40 (FUVEST-SP) · Nível 3
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 40)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 3, 'FUVEST-SP', 'Num vagão ferroviário, que se move com velocidade $v_0 = 3$ m/s em relação aos trilhos, estão dois meninos, A e B, que correm um em direção do outro, cada um com velocidade $v = 3$ m/s em relação ao vagão. [FIGURA] As velocidades dos meninos A e B em relação aos trilhos serão, respectivamente:',
         '[{"tipo": "texto", "valor": "Num vagão ferroviário, que se move com velocidade $v_0 = 3$ m/s em relação aos trilhos, estão dois meninos, A e B, que correm um em direção do outro, cada um com velocidade $v = 3$ m/s em relação ao vagão."}, {"tipo": "imagem", "valor": "/listas/lista-01/q40.png", "tamanho": "g"}, {"tipo": "texto", "valor": "As velocidades dos meninos A e B em relação aos trilhos serão, respectivamente:"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Num vagão ferroviário, que se move com velocidade $v_0 = 3$ m/s em relação aos trilhos, estão dois meninos, A e B, que correm um em direção do outro, cada um com velocidade $v = 3$ m/s em relação ao vagão."}, {"tipo": "imagem", "valor": "/listas/lista-01/q40.png", "tamanho": "g"}, {"tipo": "texto", "valor": "As velocidades dos meninos A e B em relação aos trilhos serão, respectivamente:"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "6 m/s e 0 m/s", "blocos": [{"tipo": "texto", "valor": "6 m/s e 0 m/s"}]}, {"letra": "B", "texto": "3 m/s e 3 m/s", "blocos": [{"tipo": "texto", "valor": "3 m/s e 3 m/s"}]}, {"letra": "C", "texto": "0 m/s e 9 m/s", "blocos": [{"tipo": "texto", "valor": "0 m/s e 9 m/s"}]}, {"letra": "D", "texto": "9 m/s e 0 m/s", "blocos": [{"tipo": "texto", "valor": "9 m/s e 0 m/s"}]}, {"letra": "E", "texto": "0 m/s e 6 m/s", "blocos": [{"tipo": "texto", "valor": "0 m/s e 6 m/s"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'A' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 40 from alvo, q;

-- Questão 41 (EPCAR – adaptada) · Nível 4
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 41)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 4, 'EPCAR – adaptada', 'Os vetores $\vec{A}$ e $\vec{B}$, na figura abaixo, representam, respectivamente, a velocidade do vento, em relação ao solo, e a velocidade de um avião em pleno voo, em relação ao vento. Sabendo-se que o movimento resultante do avião acontece em uma direção perpendicular à direção da velocidade do vento, tem-se que o cosseno do ângulo $\theta$ entre os vetores velocidade $\vec{A}$ e $\vec{B}$ vale [FIGURA]',
         '[{"tipo": "texto", "valor": "Os vetores $\\vec{A}$ e $\\vec{B}$, na figura abaixo, representam, respectivamente, a velocidade do vento, em relação ao solo, e a velocidade de um avião em pleno voo, em relação ao vento. Sabendo-se que o movimento resultante do avião acontece em uma direção perpendicular à direção da velocidade do vento, tem-se que o cosseno do ângulo $\\theta$ entre os vetores velocidade $\\vec{A}$ e $\\vec{B}$ vale"}, {"tipo": "imagem", "valor": "/listas/lista-01/q41.png", "tamanho": "g"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Os vetores $\\vec{A}$ e $\\vec{B}$, na figura abaixo, representam, respectivamente, a velocidade do vento, em relação ao solo, e a velocidade de um avião em pleno voo, em relação ao vento. Sabendo-se que o movimento resultante do avião acontece em uma direção perpendicular à direção da velocidade do vento, tem-se que o cosseno do ângulo $\\theta$ entre os vetores velocidade $\\vec{A}$ e $\\vec{B}$ vale"}, {"tipo": "imagem", "valor": "/listas/lista-01/q41.png", "tamanho": "g"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$-\\dfrac{|\\vec{B}|}{|\\vec{A}|}$", "blocos": [{"tipo": "texto", "valor": "$-\\dfrac{|\\vec{B}|}{|\\vec{A}|}$"}]}, {"letra": "B", "texto": "$-\\dfrac{|\\vec{A}|}{|\\vec{B}|}$", "blocos": [{"tipo": "texto", "valor": "$-\\dfrac{|\\vec{A}|}{|\\vec{B}|}$"}]}, {"letra": "C", "texto": "$-|\\vec{A}| \\cdot |\\vec{B}|$", "blocos": [{"tipo": "texto", "valor": "$-|\\vec{A}| \\cdot |\\vec{B}|$"}]}, {"letra": "D", "texto": "$|\\vec{A}| \\cdot |\\vec{B}|$", "blocos": [{"tipo": "texto", "valor": "$|\\vec{A}| \\cdot |\\vec{B}|$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 41 from alvo, q;

-- Questão 42 (UFMS) · Nível 4
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 42)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 4, 'UFMS', 'Seja um rio sem curvas e de escoamento sereno, sem turbulências, de largura constante igual a $L$. Considere o escoamento representado por vetores velocidades paralelos às margens e que cresce uniformemente com a distância da margem, atingindo o valor máximo $v_{\text{máx}}$ no meio do rio. A partir daí, a velocidade de escoamento diminui uniformemente, atingindo o valor nulo nas margens. Isso acontece porque o atrito de escoamento é mais intenso próximo às margens. Um pescador, na tentativa de atravessar esse rio, parte da margem inferior no ponto O com um barco direcionado perpendicularmente às margens e com velocidade constante em relação à água, e igual a $u$. As linhas pontilhadas, nas figuras, representam possíveis trajetórias descritas pelo barco ao atravessar o rio, saindo do ponto O e chegando ao ponto P na margem superior. [FIGURA] Com fundamentos nos conceitos de cinemática, assinale a alternativa correta.',
         '[{"tipo": "texto", "valor": "Seja um rio sem curvas e de escoamento sereno, sem turbulências, de largura constante igual a $L$. Considere o escoamento representado por vetores velocidades paralelos às margens e que cresce uniformemente com a distância da margem, atingindo o valor máximo $v_{\\text{máx}}$ no meio do rio. A partir daí, a velocidade de escoamento diminui uniformemente, atingindo o valor nulo nas margens. Isso acontece porque o atrito de escoamento é mais intenso próximo às margens. Um pescador, na tentativa de atravessar esse rio, parte da margem inferior no ponto O com um barco direcionado perpendicularmente às margens e com velocidade constante em relação à água, e igual a $u$. As linhas pontilhadas, nas figuras, representam possíveis trajetórias descritas pelo barco ao atravessar o rio, saindo do ponto O e chegando ao ponto P na margem superior."}, {"tipo": "imagem", "valor": "/listas/lista-01/q42.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Com fundamentos nos conceitos de cinemática, assinale a alternativa correta."}]'::jsonb,
         '[{"tipo": "texto", "valor": "Seja um rio sem curvas e de escoamento sereno, sem turbulências, de largura constante igual a $L$. Considere o escoamento representado por vetores velocidades paralelos às margens e que cresce uniformemente com a distância da margem, atingindo o valor máximo $v_{\\text{máx}}$ no meio do rio. A partir daí, a velocidade de escoamento diminui uniformemente, atingindo o valor nulo nas margens. Isso acontece porque o atrito de escoamento é mais intenso próximo às margens. Um pescador, na tentativa de atravessar esse rio, parte da margem inferior no ponto O com um barco direcionado perpendicularmente às margens e com velocidade constante em relação à água, e igual a $u$. As linhas pontilhadas, nas figuras, representam possíveis trajetórias descritas pelo barco ao atravessar o rio, saindo do ponto O e chegando ao ponto P na margem superior."}, {"tipo": "imagem", "valor": "/listas/lista-01/q42.png", "tamanho": "g"}, {"tipo": "texto", "valor": "Com fundamentos nos conceitos de cinemática, assinale a alternativa correta."}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "A figura A representa corretamente a trajetória do barco; e o tempo $t$ para atravessar o rio é igual a $t = L/(v_{\\text{máx}} + u)$.", "blocos": [{"tipo": "texto", "valor": "A figura A representa corretamente a trajetória do barco; e o tempo $t$ para atravessar o rio é igual a $t = L/(v_{\\text{máx}} + u)$."}]}, {"letra": "B", "texto": "A figura B representa corretamente a trajetória do barco; e o tempo $t$ para atravessar o rio é igual a $t = L/u$.", "blocos": [{"tipo": "texto", "valor": "A figura B representa corretamente a trajetória do barco; e o tempo $t$ para atravessar o rio é igual a $t = L/u$."}]}, {"letra": "C", "texto": "A figura C representa corretamente a trajetória do barco; e o tempo $t$ para atravessar o rio é igual a $t = L/u$.", "blocos": [{"tipo": "texto", "valor": "A figura C representa corretamente a trajetória do barco; e o tempo $t$ para atravessar o rio é igual a $t = L/u$."}]}, {"letra": "D", "texto": "A figura B representa corretamente a trajetória do barco; e o tempo $t$ para atravessar o rio é igual a $t = L/(u + v_{\\text{máx}})$.", "blocos": [{"tipo": "texto", "valor": "A figura B representa corretamente a trajetória do barco; e o tempo $t$ para atravessar o rio é igual a $t = L/(u + v_{\\text{máx}})$."}]}, {"letra": "E", "texto": "A figura D representa corretamente a trajetória do barco; e o tempo $t$ para atravessar o rio é igual a $t = L/u$.", "blocos": [{"tipo": "texto", "valor": "A figura D representa corretamente a trajetória do barco; e o tempo $t$ para atravessar o rio é igual a $t = L/u$."}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'B' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 42 from alvo, q;

-- Questão 43 (MARINHA) · Nível 4
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 43)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 4, 'MARINHA', 'As coordenadas $x$ e $y$ de uma partícula que se move no plano em função do tempo $t$ são dadas por $x = 2t^2 + 3t$ e $y = \dfrac{t^3}{3} - 8$. Sabendo-se que $x$ e $y$ estão em metros e $t$ em segundos, assinale a opção que apresenta, aproximadamente, o módulo da velocidade (em m/s) e da aceleração (em m/s$^2$), em $t = 3$ s, respectivamente.',
         '[{"tipo": "texto", "valor": "As coordenadas $x$ e $y$ de uma partícula que se move no plano em função do tempo $t$ são dadas por $x = 2t^2 + 3t$ e $y = \\dfrac{t^3}{3} - 8$. Sabendo-se que $x$ e $y$ estão em metros e $t$ em segundos, assinale a opção que apresenta, aproximadamente, o módulo da velocidade (em m/s) e da aceleração (em m/s$^2$), em $t = 3$ s, respectivamente."}]'::jsonb,
         '[{"tipo": "texto", "valor": "As coordenadas $x$ e $y$ de uma partícula que se move no plano em função do tempo $t$ são dadas por $x = 2t^2 + 3t$ e $y = \\dfrac{t^3}{3} - 8$. Sabendo-se que $x$ e $y$ estão em metros e $t$ em segundos, assinale a opção que apresenta, aproximadamente, o módulo da velocidade (em m/s) e da aceleração (em m/s$^2$), em $t = 3$ s, respectivamente."}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "24 e 10", "blocos": [{"tipo": "texto", "valor": "24 e 10"}]}, {"letra": "B", "texto": "15 e 19", "blocos": [{"tipo": "texto", "valor": "15 e 19"}]}, {"letra": "C", "texto": "$\\sqrt{24}$ e $\\sqrt{10}$", "blocos": [{"tipo": "texto", "valor": "$\\sqrt{24}$ e $\\sqrt{10}$"}]}, {"letra": "D", "texto": "14,4 e 3,5", "blocos": [{"tipo": "texto", "valor": "14,4 e 3,5"}]}, {"letra": "E", "texto": "$\\sqrt{306}$ e $\\sqrt{52}$", "blocos": [{"tipo": "texto", "valor": "$\\sqrt{306}$ e $\\sqrt{52}$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'E' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 43 from alvo, q;

-- Questão 44 (FCMSC-SP) · Nível 4
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 44)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 4, 'FCMSC-SP', 'Uma pedra se engasta no pneu de um automóvel que está com velocidade uniforme de 90 km/h. Supondo que o pneu não patina nem escorrega, e que o sentido de movimento do automóvel é positivo, os valores algébricos mínimo e máximo da velocidade da pedra em relação ao solo, em km/h, são:',
         '[{"tipo": "texto", "valor": "Uma pedra se engasta no pneu de um automóvel que está com velocidade uniforme de 90 km/h. Supondo que o pneu não patina nem escorrega, e que o sentido de movimento do automóvel é positivo, os valores algébricos mínimo e máximo da velocidade da pedra em relação ao solo, em km/h, são:"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Uma pedra se engasta no pneu de um automóvel que está com velocidade uniforme de 90 km/h. Supondo que o pneu não patina nem escorrega, e que o sentido de movimento do automóvel é positivo, os valores algébricos mínimo e máximo da velocidade da pedra em relação ao solo, em km/h, são:"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "$-180$ e $180$", "blocos": [{"tipo": "texto", "valor": "$-180$ e $180$"}]}, {"letra": "B", "texto": "$-90$ e $90$", "blocos": [{"tipo": "texto", "valor": "$-90$ e $90$"}]}, {"letra": "C", "texto": "$-90$ e $180$", "blocos": [{"tipo": "texto", "valor": "$-90$ e $180$"}]}, {"letra": "D", "texto": "$0$ e $90$", "blocos": [{"tipo": "texto", "valor": "$0$ e $90$"}]}, {"letra": "E", "texto": "$0$ e $180$", "blocos": [{"tipo": "texto", "valor": "$0$ e $180$"}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'E' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 44 from alvo, q;

-- Questão 45 (UNIVALE) · Nível 4
with alvo as (
  select l.id as lista_id, l.turma_id,
         (select a.id from public.assuntos_hierarquia a where a.turma_id = l.turma_id and a.nome = 'Vetores e Cinemática Vetorial' limit 1) as assunto_id
  from public.listas l join public.turmas t on t.id = l.turma_id
  where t.slug = 'fisica-escolas-militares' and l.titulo = 'Vetores e Cinemática Vetorial'
    and not exists (select 1 from public.lista_questoes lq where lq.lista_id = l.id and lq.ordem = 45)
),
q as (
  insert into public.questoes (turma_id, materia, assunto, assunto_id, dificuldade, nivel, banca, enunciado,
                               blocos_enunciado, blocos_enunciado_superior, blocos_enunciado_inferior, alternativas)
  select alvo.turma_id, 'Física', 'Vetores e Cinemática Vetorial', alvo.assunto_id, 'dificil', 4, 'UNIVALE', 'Um ultraleve mantém a velocidade de 120 km/h em relação ao ar, estando o nariz apontando para Leste. Sopra vento Sul com velocidade de 90 km/h. Nessas condições, podemos afirmar que a velocidade do ultraleve em relação à Terra é:',
         '[{"tipo": "texto", "valor": "Um ultraleve mantém a velocidade de 120 km/h em relação ao ar, estando o nariz apontando para Leste. Sopra vento Sul com velocidade de 90 km/h. Nessas condições, podemos afirmar que a velocidade do ultraleve em relação à Terra é:"}]'::jsonb,
         '[{"tipo": "texto", "valor": "Um ultraleve mantém a velocidade de 120 km/h em relação ao ar, estando o nariz apontando para Leste. Sopra vento Sul com velocidade de 90 km/h. Nessas condições, podemos afirmar que a velocidade do ultraleve em relação à Terra é:"}]'::jsonb,
         '[]'::jsonb,
         '[{"letra": "A", "texto": "150 km/h, na direção Sudeste.", "blocos": [{"tipo": "texto", "valor": "150 km/h, na direção Sudeste."}]}, {"letra": "B", "texto": "30 km/h, na direção Leste.", "blocos": [{"tipo": "texto", "valor": "30 km/h, na direção Leste."}]}, {"letra": "C", "texto": "210 km/h, na direção Sudoeste.", "blocos": [{"tipo": "texto", "valor": "210 km/h, na direção Sudoeste."}]}, {"letra": "D", "texto": "50 km/h, na direção Nordeste.", "blocos": [{"tipo": "texto", "valor": "50 km/h, na direção Nordeste."}]}, {"letra": "E", "texto": "210 km/h, na direção Sudeste.", "blocos": [{"tipo": "texto", "valor": "210 km/h, na direção Sudeste."}]}]'::jsonb
  from alvo
  returning id
),
g as (
  insert into public.questoes_gabarito (questao_id, resposta_correta) select id, 'A' from q
)
insert into public.lista_questoes (lista_id, questao_id, ordem)
select alvo.lista_id, q.id, 45 from alvo, q;

notify pgrst, 'reload schema';
