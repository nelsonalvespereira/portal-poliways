/** @type {import('tailwindcss').Config} */
import colors from 'tailwindcss/colors';

// Paleta POLIWAYS: vermelho do brasão, amarelo de destaque e preto.
// A escala "orange" foi trocada por uma escala de vermelhos para que todo o código
// herdado (bg-orange-50, text-orange-800...) passe a seguir a marca sem reescrever as telas.
const vermelho = {
  50: '#FEF2F2',
  100: '#FEE2E2',
  200: '#FECACA',
  300: '#FCA5A5',
  400: '#F87171',
  500: '#E1333E',
  600: '#C00000',
  700: '#A30000',
  800: '#8A0000',
  900: '#6B0000',
  950: '#450000',
};

export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        orange: vermelho,
        // Cinzas neutros (sem o tom azulado do slate) combinam melhor com o vermelho da marca.
        slate: colors.neutral,
        brand: {
          // Vermelho do brasão: texto branco sobre ele tem contraste 6,6:1 (WCAG AA).
          orange: '#C00000',
          orangeHover: '#9A0000',
          // Amarelo POLIWAYS: destaque sobre fundo ESCURO.
          orangeLight: '#FFC800',
          yellow: '#FFC800',
          black: '#1A1A1A',
          grayLight: '#F3F4F6',
          grayBorder: '#D1D5DB',
          grayText: '#4B5563',
        }
      }
    },
  },
  plugins: [],
}
