import React from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import {
  ArrowRight, LogIn, Stethoscope, Rocket, FileText, Target, PlayCircle, Radio,
  TrendingUp, AlertCircle, Star, Compass, Layers,
} from 'lucide-react';

import RodapeLegal from '../components/RodapeLegal';
import Marca from '../components/Marca';
import { useAuth } from '../hooks/useAuth';
import { CLIENTE, TRILHAS } from '../config/cliente';

const NICHE_STORAGE_KEY = 'selectedNiche';

const ICONE_TRILHA = { 'medicina-enem': Stethoscope, 'ita-ime': Rocket };

const RECURSOS_PLATAFORMA = [
  { icon: FileText, titulo: 'Banco de questões', texto: 'Questões comentadas por assunto, com fórmulas, figuras e resolução em vídeo.' },
  { icon: Target, titulo: 'Simulados', texto: 'Simulado oficial cronometrado, por assunto ou montado por você, com correção na hora.' },
  { icon: PlayCircle, titulo: 'Aulas por módulo', texto: 'Videoaulas organizadas por módulo, com o seu progresso salvo aula a aula.' },
  { icon: Radio, titulo: 'Lives', texto: 'Aulas e plantões ao vivo com os professores, com chat para tirar dúvidas.' },
  { icon: TrendingUp, titulo: 'Desempenho e ranking', texto: 'Taxa de acerto por assunto, sequência de estudos e posição na sua turma.' },
  { icon: AlertCircle, titulo: 'Caderno de erros', texto: 'As questões que você errou voltam para revisão até você acertar.' },
];

const PILARES = [
  { icon: Layers, titulo: '101 Policlasses', texto: 'Nivelamento para quem está começando, sem deixar lacunas para trás.' },
  { icon: Star, titulo: 'Star Curriculum', texto: 'Conteúdos avançados para quem disputa as vagas mais concorridas do país.' },
  { icon: Compass, titulo: 'Poliways Careers', texto: 'Orientação de carreira e um plano de vida construído com cada aluno.' },
];

const surgir = {
  hidden: { opacity: 0, y: 24 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } },
};

export default function LandingPage() {
  const navigate = useNavigate();
  const { user, profile } = useAuth();
  const [trilhaEscolhida, setTrilhaEscolhida] = React.useState(null);

  const destinoLogado = profile?.is_admin ? '/admin' : '/dashboard';

  const escolherTrilha = (id) => {
    setTrilhaEscolhida(id);
    try { localStorage.setItem(NICHE_STORAGE_KEY, id); } catch { /* navegador sem armazenamento */ }
    setTimeout(() => {
      if (user) navigate(destinoLogado, { state: { niche: id } });
      else navigate(`/login?niche=${id}`, { state: { niche: id } });
    }, 200);
  };

  const irParaTrilhas = () => {
    document.getElementById('trilhas')?.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <div className="min-h-screen bg-white font-sans overflow-x-hidden selection:bg-brand-orange selection:text-white">

      {/* CABEÇALHO */}
      <header className="fixed top-0 inset-x-0 h-16 md:h-20 bg-brand-black/85 backdrop-blur-md border-b border-white/10 z-50 px-4 sm:px-10 flex items-center justify-between">
        <button onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })} aria-label="Voltar ao topo">
          <Marca tema="escuro" />
        </button>
        <div className="flex items-center gap-2 sm:gap-3">
          <Link
            to={user ? destinoLogado : '/login'}
            className="flex items-center gap-2 px-3 sm:px-4 py-2 text-white/75 hover:text-white font-semibold text-sm transition-colors"
          >
            <LogIn className="w-4 h-4" />
            <span className="hidden sm:inline">{user ? 'Minha área' : 'Entrar'}</span>
          </Link>
          <button
            onClick={irParaTrilhas}
            className="flex items-center gap-2 px-4 sm:px-5 py-2.5 bg-brand-orange hover:bg-brand-orangeHover text-white rounded-xl font-bold text-sm whitespace-nowrap transition-colors"
          >
            <span className="sm:hidden">Começar</span>
            <span className="hidden sm:inline">Escolher trilha</span> <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      </header>

      {/* CAPA: mesmo visual da identidade institucional (faixa vermelha, linha amarela, base preta) */}
      <section className="relative pt-16 md:pt-20">
        <div className="bg-gradient-to-r from-[#9D3A3B] to-[#E1333E] text-white">
          <div className="max-w-6xl mx-auto px-4 sm:px-10 py-16 md:py-24 grid md:grid-cols-[1fr_auto] gap-12 items-center">
            <motion.div initial="hidden" animate="visible" variants={surgir}>
              <p className="text-white/80 font-semibold text-sm tracking-widest uppercase mb-5">
                {CLIENTE.cidade} · Medicina · ITA · IME
              </p>
              <h1 className="text-4xl sm:text-5xl md:text-6xl font-black leading-[1.05] tracking-tight mb-6">
                Sua vaga nas carreiras de alta demanda começa com um diagnóstico.
              </h1>
              <p className="text-white/85 text-lg md:text-xl leading-relaxed max-w-2xl mb-9">
                Diagnóstico, planejamento de estudos e treino técnico, com acompanhamento individual
                do seu desempenho dentro e fora da sala de aula.
              </p>
              <div className="flex flex-col sm:flex-row gap-3">
                <button
                  onClick={irParaTrilhas}
                  className="inline-flex items-center justify-center gap-2 px-6 py-3.5 bg-white text-brand-orange hover:bg-white/90 rounded-xl font-black transition-colors"
                >
                  Conhecer as trilhas <ArrowRight className="w-5 h-5" />
                </button>
                <Link
                  to={user ? destinoLogado : '/login'}
                  className="inline-flex items-center justify-center gap-2 px-6 py-3.5 border border-white/40 hover:bg-white/10 rounded-xl font-bold transition-colors"
                >
                  Já sou aluno
                </Link>
              </div>
            </motion.div>
            <motion.img
              initial={{ opacity: 0, scale: 0.92 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.7, delay: 0.15 }}
              src={CLIENTE.logo}
              alt={CLIENTE.nomeCompleto}
              className="hidden md:block h-72 w-auto drop-shadow-2xl"
            />
          </div>
        </div>
        <div className="h-1.5 bg-brand-yellow" />
        <div className="bg-brand-black text-white">
          <div className="max-w-6xl mx-auto px-4 sm:px-10 py-5 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1">
            <span className="font-black tracking-wide">{CLIENTE.nomeCompleto.toUpperCase()}</span>
            <span className="text-sm text-white/60 italic">
              Mais de 15 anos formando jovens para o ensino superior · {CLIENTE.professor}
            </span>
          </div>
        </div>
      </section>

      {/* TRILHAS */}
      <section id="trilhas" className="bg-neutral-50 px-4 sm:px-10 py-20 md:py-28 scroll-mt-16">
        <div className="max-w-6xl mx-auto">
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={surgir} className="max-w-2xl mb-12">
            <p className="text-brand-orange font-black text-sm tracking-widest uppercase mb-3">Duas trilhas</p>
            <h2 className="text-3xl md:text-5xl font-black text-slate-900 tracking-tight mb-4">Qual é o seu objetivo?</h2>
            <p className="text-slate-600 text-lg">
              Escolha a sua trilha. As questões, as aulas e os simulados da plataforma seguem o que a sua prova cobra.
            </p>
          </motion.div>

          <div className="grid md:grid-cols-2 gap-5">
            {TRILHAS.map((t) => {
              const Icone = ICONE_TRILHA[t.id] ?? Target;
              const escolhida = trilhaEscolhida === t.id;
              return (
                <motion.button
                  key={t.id}
                  initial="hidden"
                  whileInView="visible"
                  viewport={{ once: true }}
                  variants={surgir}
                  onClick={() => escolherTrilha(t.id)}
                  disabled={!!trilhaEscolhida}
                  aria-pressed={escolhida}
                  className={`group text-left bg-white rounded-3xl border p-8 md:p-10 flex flex-col transition-all hover:-translate-y-1 hover:shadow-xl hover:shadow-neutral-200 disabled:cursor-wait
                    ${escolhida ? 'border-brand-orange ring-2 ring-brand-orange' : 'border-neutral-200 hover:border-brand-orange'}`}
                >
                  <div className="w-14 h-14 rounded-2xl bg-orange-50 text-brand-orange flex items-center justify-center mb-8 group-hover:bg-brand-orange group-hover:text-white transition-colors">
                    <Icone className="w-7 h-7" />
                  </div>
                  <h3 className="text-3xl font-black text-slate-900 mb-2">{t.titulo}</h3>
                  <p className="text-sm font-bold text-brand-orange mb-4">{t.materias}</p>
                  <p className="text-slate-600 leading-relaxed mb-8">{t.descricao}</p>
                  <span className="mt-auto inline-flex items-center gap-2 font-black text-slate-900 group-hover:text-brand-orange transition-colors">
                    {escolhida ? 'Abrindo…' : 'Entrar nesta trilha'} <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                  </span>
                </motion.button>
              );
            })}
          </div>
        </div>
      </section>

      {/* PLATAFORMA */}
      <section className="px-4 sm:px-10 py-20 md:py-28">
        <div className="max-w-6xl mx-auto">
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={surgir} className="max-w-2xl mb-12">
            <p className="text-brand-orange font-black text-sm tracking-widest uppercase mb-3">A plataforma</p>
            <h2 className="text-3xl md:text-5xl font-black text-slate-900 tracking-tight mb-4">A sala de aula continua no seu celular.</h2>
            <p className="text-slate-600 text-lg">
              Entre uma aula e outra, você resolve questões, faz simulados e revisa o que errou. A coordenação acompanha cada aluno.
            </p>
          </motion.div>
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-x-8 gap-y-10">
            {RECURSOS_PLATAFORMA.map(({ icon: Icone, titulo, texto }) => (
              <motion.div key={titulo} initial="hidden" whileInView="visible" viewport={{ once: true }} variants={surgir} className="flex gap-4">
                <div className="w-11 h-11 rounded-xl bg-brand-black text-brand-yellow flex items-center justify-center shrink-0">
                  <Icone className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-black text-slate-900 mb-1">{titulo}</h3>
                  <p className="text-slate-600 text-sm leading-relaxed">{texto}</p>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* MÉTODO */}
      <section className="bg-brand-black text-white px-4 sm:px-10 py-20 md:py-28">
        <div className="max-w-6xl mx-auto">
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={surgir} className="max-w-2xl mb-12">
            <p className="text-brand-yellow font-black text-sm tracking-widest uppercase mb-3">O método</p>
            <h2 className="text-3xl md:text-5xl font-black tracking-tight mb-4">Os três pilares do {CLIENTE.nome}</h2>
            <p className="text-white/70 text-lg">
              Tudo começa no diagnóstico técnico: simulados, avaliação vocacional e comportamental mostram de onde você parte.
            </p>
          </motion.div>
          <div className="grid md:grid-cols-3 gap-5">
            {PILARES.map(({ icon: Icone, titulo, texto }) => (
              <motion.div
                key={titulo}
                initial="hidden"
                whileInView="visible"
                viewport={{ once: true }}
                variants={surgir}
                className="rounded-3xl border border-white/10 bg-white/[0.03] p-8"
              >
                <Icone className="w-7 h-7 text-brand-yellow mb-6" />
                <h3 className="text-xl font-black mb-2">{titulo}</h3>
                <p className="text-white/70 leading-relaxed">{texto}</p>
              </motion.div>
            ))}
          </div>

          <motion.figure
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={surgir}
            className="mt-16 border-l-4 border-brand-orange pl-6 md:pl-8 max-w-3xl"
          >
            <p className="text-xl md:text-2xl font-bold leading-snug text-white/90">
              O {CLIENTE.nome} trabalha o conhecer e o fazer de forma integrada, com a metodologia visual VIDERE,
              para quem quer disputar as principais vagas do país: Medicina, ITA, IME, AFA, Escola Naval.
            </p>
            <figcaption className="mt-4 text-sm">
              <span className="font-black uppercase tracking-wider">{CLIENTE.professor}</span>
              <span className="text-white/50"> · Fundador do {CLIENTE.nomeCompleto}</span>
            </figcaption>
          </motion.figure>
        </div>
      </section>

      {/* CHAMADA FINAL */}
      <section className="px-4 sm:px-10 py-20">
        <div className="max-w-6xl mx-auto rounded-3xl bg-gradient-to-r from-[#9D3A3B] to-[#E1333E] text-white p-10 md:p-14 flex flex-col md:flex-row md:items-center md:justify-between gap-8">
          <div>
            <h2 className="text-3xl md:text-4xl font-black tracking-tight mb-2">Pronto para começar?</h2>
            <p className="text-white/85 text-lg">Escolha a sua trilha e crie a sua conta. A coordenação libera o acesso após a matrícula.</p>
          </div>
          <button
            onClick={irParaTrilhas}
            className="inline-flex items-center justify-center gap-2 px-6 py-3.5 bg-white text-brand-orange hover:bg-white/90 rounded-xl font-black shrink-0 transition-colors"
          >
            Escolher trilha <ArrowRight className="w-5 h-5" />
          </button>
        </div>
      </section>

      <RodapeLegal />
    </div>
  );
}
