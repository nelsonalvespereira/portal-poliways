import React, { useState } from 'react';
import { Link, useNavigate, useSearchParams } from 'react-router-dom';
import RodapeLegal from '../components/RodapeLegal';
import Marca from '../components/Marca';
import { CLIENTE, RECURSOS, TRILHAS } from '../config/cliente';
import { Mail, Lock, User, ArrowRight, Loader2 } from 'lucide-react';
import { useAuth } from '../hooks/useAuth';
import { supabase } from '../lib/supabaseClient';
import AceiteTermos, { MSG_ACEITE } from '../components/AceiteTermos';
import { TERMOS_VERSAO } from '../config/responsavel';

export default function Login() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const { signIn, signUp } = useAuth();

  const [nome, setNome] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  const [isRegistering, setIsRegistering] = useState(false);
  const [aceitouTermos, setAceitouTermos] = useState(false);
  // Trilha escolhida na landing (ou a primeira, se o aluno veio direto para o login).
  const [trilha, setTrilha] = useState(() => {
    const salva = searchParams.get('niche') || localStorage.getItem('selectedNiche');
    return TRILHAS.some((t) => t.id === salva) ? salva : TRILHAS[0].id;
  });

  const handleAuth = async (e) => {
    e.preventDefault();
    setLoading(true);
    setErrorMsg('');

    // Turma escolhida lá na Landing Page
    const niche = trilha;

    try {
      if (isRegistering) {
        const nomeLimpo = nome.trim().replace(/\s+/g, ' ');
        if (nomeLimpo.length < 2) {
          setErrorMsg('Informe seu nome.');
          setLoading(false);
          return;
        }
        if (!aceitouTermos) {
          setErrorMsg(MSG_ACEITE);
          setLoading(false);
          return;
        }

        const { error } = await signUp({
          email,
          password,
          nome: nomeLimpo,
          turmaSlug: niche,
          termosVersao: TERMOS_VERSAO,
        });

        if (error) throw error;
        
        // Redireciona para o pagamento após criar a conta com sucesso
        navigate(RECURSOS.pagamentoOnline ? '/pagamento' : '/aguardando-liberacao');
      } else {
        const { error } = await signIn({ email, password });
        if (error) throw error;

        // 1. Pega o usuário que acabou de logar na sessão
        const { data: { user } } = await supabase.auth.getUser();
        
        if (user) {
          const { data: profile } = await supabase
            .from('profiles')
            .select('is_admin')
            .eq('id', user.id)
            .single();

          if (profile?.is_admin) {
            navigate('/admin');
          } else {
            navigate('/dashboard');
          }
        } else {
          // Fallback de segurança
          navigate('/dashboard');
        }
      }
    } catch (error) {
      console.error(error);
      if (error.message.includes('Invalid login credentials')) {
        setErrorMsg('E-mail ou senha incorretos.');
      } else if (error.message.includes('User already registered')) {
        setErrorMsg('Este e-mail já está cadastrado.');
      } else if (error.message.includes('Password should be at least')) {
        setErrorMsg('A senha deve ter pelo menos 6 caracteres.');
      } else {
        setErrorMsg('Ocorreu um erro: ' + error.message);
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex font-sans">

      {/* LADO ESQUERDO: Formulário */}
      <div className="w-full lg:w-1/2 flex flex-col justify-center px-8 sm:px-16 md:px-24 xl:px-32 bg-white relative z-10">

        <div className="pt-8 pb-10 lg:pb-0 lg:pt-0 lg:absolute lg:top-12 lg:left-24 xl:left-32 max-w-md w-full mx-auto lg:mx-0">
          <Link to="/" className="flex items-center gap-2">
            <Marca tema="claro" />
          </Link>
        </div>

        <div className="max-w-md w-full mx-auto lg:mt-0">
          <h2 className="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight mb-2">
            {isRegistering ? 'Crie sua conta' : 'Bem-vindo de volta!'}
          </h2>
          <p className="text-slate-500 mb-8 text-lg">
            {isRegistering
              ? 'Faça seu cadastro para iniciar sua jornada.'
              : 'Acesse sua conta para continuar sua jornada rumo à aprovação.'}
          </p>

          {errorMsg && (
            <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-600 rounded-xl text-sm font-medium">
              {errorMsg}
            </div>
          )}

          <form onSubmit={handleAuth} className="space-y-6">

            {isRegistering && (
              <div>
                <label htmlFor="nome" className="block text-sm font-semibold text-slate-700 mb-1.5">
                  Seu nome
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                    <User className="h-5 w-5 text-slate-400" />
                  </div>
                  <input
                    id="nome"
                    type="text"
                    required
                    maxLength={80}
                    autoComplete="name"
                    value={nome}
                    onChange={(e) => setNome(e.target.value)}
                    className="block w-full pl-11 pr-4 py-3.5 bg-slate-50 border border-slate-200 rounded-xl text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-orange/20 focus:border-brand-orange transition-all font-medium"
                    placeholder="Como você quer ser chamado(a)"
                  />
                </div>
                <p className="mt-1.5 text-xs text-slate-500 font-medium">
                  Seu primeiro nome aparece no ranking para os outros alunos.
                </p>
              </div>
            )}

            {isRegistering && (
              <fieldset>
                <legend className="block text-sm font-semibold text-slate-700 mb-1.5">Sua trilha</legend>
                <div className="grid grid-cols-2 gap-2">
                  {TRILHAS.map((t) => (
                    <label
                      key={t.id}
                      className={`cursor-pointer rounded-xl border px-4 py-3 text-sm font-bold transition-colors ${
                        trilha === t.id
                          ? 'border-brand-orange bg-orange-50 text-brand-orange'
                          : 'border-slate-200 bg-slate-50 text-slate-600 hover:border-slate-300'
                      }`}
                    >
                      <input
                        type="radio"
                        name="trilha"
                        value={t.id}
                        checked={trilha === t.id}
                        onChange={() => setTrilha(t.id)}
                        className="sr-only"
                      />
                      {t.titulo}
                    </label>
                  ))}
                </div>
              </fieldset>
            )}

            <div>
              <label htmlFor="email" className="block text-sm font-semibold text-slate-700 mb-1.5">
                E-mail
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <Mail className="h-5 w-5 text-slate-400" />
                </div>
                <input
                  id="email"
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="block w-full pl-11 pr-4 py-3.5 bg-slate-50 border border-slate-200 rounded-xl text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-orange/20 focus:border-brand-orange transition-all font-medium"
                  placeholder="seu@email.com"
                />
              </div>
            </div>

            <div>
              <label htmlFor="password" className="block text-sm font-semibold text-slate-700 mb-1.5">
                Senha
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <Lock className="h-5 w-5 text-slate-400" />
                </div>
                <input
                  id="password"
                  type="password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="block w-full pl-11 pr-4 py-3.5 bg-slate-50 border border-slate-200 rounded-xl text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-orange/20 focus:border-brand-orange transition-all font-medium"
                  placeholder="••••••••"
                />
              </div>
            </div>

            {!isRegistering && (
              <div className="flex items-center justify-between">
                <div className="flex items-center">
                  <input
                    id="remember-me"
                    type="checkbox"
                    className="h-4 w-4 text-brand-orange focus:ring-brand-orange border-slate-300 rounded cursor-pointer transition-colors"
                  />
                  <label htmlFor="remember-me" className="ml-2 block text-sm text-slate-600 cursor-pointer font-medium">
                    Lembrar de mim
                  </label>
                </div>

                <Link to="/esqueci-senha" className="text-sm font-bold text-brand-orange hover:text-orange-800 transition-colors">
                  Esqueceu a senha?
                </Link>
              </div>
            )}

            {isRegistering && <AceiteTermos marcado={aceitouTermos} onChange={setAceitouTermos} />}

            <button
              type="submit"
              disabled={loading}
              className="w-full flex items-center justify-center gap-2 py-4 px-4 bg-brand-orange hover:bg-orange-800 text-white text-base font-bold rounded-xl shadow-lg shadow-orange-200 hover:shadow-orange-300 transition-all active:scale-95 group disabled:opacity-70 disabled:cursor-not-allowed"
            >
              {loading ? (
                <Loader2 className="w-5 h-5 animate-spin" />
              ) : (
                <>
                  {isRegistering ? 'Criar Conta' : 'Entrar na Plataforma'}
                  <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                </>
              )}
            </button>

          </form>

          <p className="mt-8 text-center text-sm text-slate-600 font-medium">
            {isRegistering ? 'Já tem uma conta? ' : 'Ainda não é aluno? '}
            <button
              type="button"
              onClick={() => setIsRegistering(!isRegistering)}
              className="font-bold text-brand-orange hover:text-orange-800 transition-colors"
            >
              {isRegistering ? 'Faça login aqui' : 'Crie sua conta'}
            </button>
          </p>
          <RodapeLegal className="mt-6 !px-0" />
        </div>
      </div>

      {/* LADO DIREITO: painel da marca (mesmo visual da capa institucional do POLIWAYS) */}
      <div className="hidden lg:flex lg:w-1/2 relative flex-col overflow-hidden bg-brand-black">
        <div className="flex-1 relative flex items-center justify-center px-16 bg-gradient-to-r from-[#9D3A3B] to-[#E1333E]">
          <div className="max-w-md">
            <img src={CLIENTE.logo} alt={CLIENTE.nomeCompleto} className="h-40 w-auto mb-10 drop-shadow-xl" />
            <p className="text-white text-3xl font-black leading-tight mb-4">
              Diagnóstico, planejamento e treino técnico para as carreiras de alta demanda.
            </p>
            <p className="text-white/80 text-base leading-relaxed">
              Trilhas Medicina/ENEM e ITA/IME, com acompanhamento individual do seu desempenho.
            </p>
          </div>
        </div>
        <div className="h-1.5 bg-brand-yellow" />
        <div className="px-16 py-6 flex items-center justify-between text-white">
          <span className="font-black tracking-wide">{CLIENTE.nomeCompleto.toUpperCase()}</span>
          <span className="text-xs text-white/60 italic">{CLIENTE.cidade}</span>
        </div>
      </div>

    </div>
  );
}