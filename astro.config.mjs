import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import cloudflare from '@astrojs/cloudflare';

export default defineConfig({
  output: 'server',
  adapter: cloudflare(),
  integrations: [tailwind()],
  site: import.meta.env.PUBLIC_SITE_URL || 'https://ampaloslirios.es',
  i18n: {
    defaultLocale: 'es',
    locales: ['es'],
  },
});
