import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://vantarsoluciones.com.ar',
  integrations: [sitemap()],
  output: 'static',
  build: { format: 'directory' },
});
