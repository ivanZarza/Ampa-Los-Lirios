import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import cloudflare from '@astrojs/cloudflare';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  output: 'server',
  adapter: cloudflare(),
  integrations: [
    tailwind(),
    sitemap({
      filter: (page) => !page.includes('/admin') && !page.includes('/api/'),
    }),
  ],
  site: import.meta.env.PUBLIC_SITE_URL || 'https://ampaloslirios.es',
  trailingSlash: 'never',
  i18n: {
    defaultLocale: 'es',
    locales: ['es'],
  },
});
