import React from 'react';
import { Star } from 'lucide-react';
import { nivelInfo } from '../lib/niveis';

// "Nível II ★★" — como nas listas impressas do POLIWAYS.
export default function SeloNivel({ nivel, className = '' }) {
  const info = nivelInfo(nivel);
  if (!info) return null;
  return (
    <span
      className={`inline-flex items-center gap-1 text-xs font-black text-brand-orange bg-orange-50 px-2.5 py-1 rounded-md ${className}`}
      title={`Nível ${info.romano}`}
    >
      Nível {info.romano}
      <span className="inline-flex" aria-hidden="true">
        {Array.from({ length: info.estrelas }).map((_, i) => (
          <Star key={i} className="w-3 h-3" fill="currentColor" strokeWidth={0} />
        ))}
      </span>
    </span>
  );
}
