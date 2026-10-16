/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        verde: {
          50: '#f0f7f0',
          100: '#dceddc',
          200: '#bcdcbc',
          300: '#8ec48e',
          400: '#5fa85f',
          500: '#4a8f4a',
          600: '#3a7a3a',
          700: '#2d612d',
          800: '#264f26',
          900: '#1d3f1d',
        },
        malva: {
          50: '#f8f4fa',
          100: '#f0e8f4',
          200: '#e0cfea',
          300: '#c9a9d6',
          400: '#b085be',
          500: '#9b72b0',
          600: '#7d5692',
          700: '#664578',
          800: '#553b63',
          900: '#473253',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
