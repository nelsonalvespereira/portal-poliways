import React, { useState } from 'react';
import { Navigate, useNavigate } from 'react-router-dom';
import { Clock, RefreshCw, LogOut } from 'lucide-react';
import { useAuth } from '../hooks/useAuth';
import Marca from '../components/Marca';
import { CLIENTE } from '../config/cliente';

// Conta criada, mas a coordenação ainda não liberou o acesso (matrícula feita na secretaria).
// A liberação é o botão "Liberar acesso" em Gestão de Alunos (campo acesso_livre do perfil).
export default function AguardandoLiberacao() {
  const navigate = useNavigate();
  const { user, profile, temAcesso, loading, recarregarPerfil, signOut } = useAuth();
  const [conferindo, setConferindo] = useState(false);

  if (loading) return null;
  if (!user) return <Navigate to="/login" replace />;
  if (temAcesso) return <Navigate to={profile?.is_admin ? '/admin' : '/dashboard'} replace />;

  const primeiroNome = (profile?.nome || '').split(' ')[0];

  const conferir = async () => {
    setConferindo(true);
    await recarregarPerfil?.();
    setConferindo(false);
  };

  const sair = async () => {
    await signOut();
    navigate('/login');
  };

  return (
    <div className="min-h-[100dvh] bg-brand-black text-white font-sans flex flex-col">
      <header className="px-6 py-5 border-b border-white/10">
        <Marca tema="escuro" />
      </header>
      <main className="flex-1 flex items-center justify-center p-6">
        <div className="max-w-md w-full text-center">
          <div className="w-16 h-16 rounded-2xl bg-brand-yellow/15 text-brand-yellow flex items-center justify-center mx-auto mb-6">
            <Clock className="w-8 h-8" />
          </div>
          <h1 className="text-2xl md:text-3xl font-black mb-3">
            {primeiroNome ? `Tudo certo, ${primeiroNome}!` : 'Conta criada!'}
          </h1>
          <p className="text-white/70 leading-relaxed mb-2">
            Seu cadastro foi recebido. A coordenação do {CLIENTE.nome} confere a sua matrícula e libera o acesso à plataforma.
          </p>
          <p className="text-white/50 text-sm mb-8">
            Já fez a matrícula? Toque em “Já fui liberado” para conferir de novo.
          </p>
          <div className="flex flex-col sm:flex-row gap-3 justify-center">
            <button
              onClick={conferir}
              disabled={conferindo}
              className="inline-flex items-center justify-center gap-2 px-5 py-3 bg-brand-orange hover:bg-brand-orangeHover rounded-xl font-bold text-sm disabled:opacity-60"
            >
              <RefreshCw className={`w-4 h-4 ${conferindo ? 'animate-spin' : ''}`} /> Já fui liberado
            </button>
            <button
              onClick={sair}
              className="inline-flex items-center justify-center gap-2 px-5 py-3 border border-white/15 hover:bg-white/5 rounded-xl font-bold text-sm"
            >
              <LogOut className="w-4 h-4" /> Sair
            </button>
          </div>
        </div>
      </main>
      <div className="h-1.5 bg-brand-yellow" />
    </div>
  );
}
