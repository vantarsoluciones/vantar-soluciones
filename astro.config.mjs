import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://vantarsoluciones.com.ar',
  integrations: [
    sitemap({
      // Lo que pide noindex no se lista: /abogados/gracias es la página de
      // conversión de Google Ads, no un destino orgánico.
      filter: (page) => !page.includes('/abogados/gracias'),
    }),
  ],
  output: 'static',
  // 'file' genera abogados.html, abogados/como-funciona.html, etc.
  // Cloudflare Pages los sirve como URL limpia SIN redirect (la campaña de
  // Ads exige las rutas en 200 directo, sin 308 de barra final).
  build: { format: 'file' },
});
