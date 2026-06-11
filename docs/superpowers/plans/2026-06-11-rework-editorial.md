# Rework Editorial VantAr — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.
> **REGLA DEL PROYECTO (CLAUDE.md):** invocar `/frontend-design` antes de construir cualquier componente visual. Cada subagente que implemente una task visual debe invocarlo primero.

**Goal:** Reescribir la landing de vantarsoluciones.com.ar con la estética "despacho editorial" (navy #080F1E + bronce #9A7C4A + crema #EFEAE0, Fraunces + Inter) según el spec `docs/superpowers/specs/2026-06-11-rework-editorial-design.md`.

**Architecture:** Astro 5 estático. Componentes `.astro` con estilos inline + `@media` en `global.css`. Un solo IntersectionObserver en `Layout.astro` orquesta reveals (clases `.reveal`/`.reveal-line`). El chat de WhatsApp vive en `FlowDiagram.astro` con su propio motor JS. No hay framework de tests: la verificación es `npm run build` + inspección visual en `npm run dev` (http://localhost:4321).

**Tech Stack:** Astro 5.x, CSS vanilla (tokens en `:root`), vanilla JS, Google Fonts (Fraunces + Inter), deploy Cloudflare Pages.

**Estructura de archivos:**

| Archivo | Acción | Responsabilidad |
|---|---|---|
| `src/styles/global.css` | Reescribir | Tokens, fuentes, keyframes, clases compartidas (reveals, botones, labels), responsive base |
| `src/layouts/Layout.astro` | Reescribir | SEO meta nuevo + script IntersectionObserver global |
| `src/components/Logo.astro` | Crear | SVG del logo rediseñado (reutilizable, prop `size`) |
| `public/favicon.svg` | Reescribir | Favicon con logo nuevo |
| `src/components/Navbar.astro` | Reescribir | Nav fija, anclas nuevas, CTA outline |
| `src/components/Hero.astro` | Reescribir | Hero asimétrico + banda de métricas |
| `src/components/Problem.astro` | Crear | "Lo que conocés de memoria" — lista foliada a.–e. |
| `src/components/FlowDiagram.astro` | Reescribir | Demo: copy + iPhone con chat WA mejorado |
| `src/components/Features.astro` | Crear | 9 funcionalidades, lista editorial 2 columnas |
| `src/components/Services.astro` | Crear (reemplaza Offering) | 3 servicios con filetes verticales |
| `src/components/Results.astro` | Reescribir | Métricas gigantes count-up + testimonio provisorio |
| `src/components/Process.astro` | Crear (reemplaza HowItWorks) | Timeline 5 pasos |
| `src/components/FAQ.astro` | Crear | Acordeón 7 preguntas |
| `src/components/FinalCTA.astro` | Reescribir | CTA final WhatsApp |
| `src/components/Footer.astro` | Reescribir | Footer sobrio |
| `src/pages/index.astro` | Reescribir | Orden nuevo de secciones |
| `src/components/Benefits.astro` | Eliminar | Absorbido por Features |
| `src/components/HowItWorks.astro` | Eliminar | Absorbido por Process |
| `src/components/Offering.astro` | Eliminar | Reemplazado por Services |

**Constantes compartidas:** número WA `5498944628576`. Links: `https://wa.me/5498944628576?text=<texto-urlencoded>`.

---

### Task 1: Fundación — global.css + Layout.astro

**Files:**
- Modify: `src/styles/global.css` (reescritura completa)
- Modify: `src/layouts/Layout.astro` (reescritura completa)

- [ ] **Step 1: Reescribir `src/styles/global.css`** con este contenido completo:

```css
@import url('https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,400;0,9..144,500;0,9..144,600;0,9..144,700;1,9..144,400;1,9..144,500;1,9..144,600&family=Inter:wght@300;400;500;600&display=swap');

:root {
  --bg:            #080F1E;
  --bg-alt:        #060B17;
  --navy-elevated: #0D1830;
  --bronze:        #9A7C4A;
  --bronze-light:  #B59A5C;
  --cream:         #EFEAE0;
  --cream-60:      rgba(239, 234, 224, 0.6);
  --cream-40:      rgba(239, 234, 224, 0.4);
  --line:          rgba(154, 124, 74, 0.22);
  --line-strong:   rgba(154, 124, 74, 0.45);
  --font-display:  'Fraunces', Georgia, 'Times New Roman', serif;
  --font-body:     'Inter', system-ui, sans-serif;
}

*, *::before, *::after { box-sizing: border-box; }

html { scroll-behavior: smooth; }

body {
  font-family: var(--font-body);
  background-color: var(--bg);
  color: var(--cream);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  margin: 0;
  padding: 0;
}

::selection { background: rgba(154, 124, 74, 0.35); color: var(--cream); }

/* ── Layout compartido ── */
.container { max-width: 1140px; margin: 0 auto; }
.section   { padding: 110px 32px; }
.section-alt { background: var(--bg-alt); }

/* ── Label de sección (versalitas + filete que se desvanece) ── */
.label-sec {
  font-family: var(--font-body);
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.28em;
  text-transform: uppercase;
  color: var(--bronze);
  display: flex;
  align-items: center;
  gap: 16px;
}
.label-sec::after {
  content: '';
  height: 1px;
  flex: 1;
  background: linear-gradient(90deg, var(--line-strong), transparent);
}

/* ── Tipografía display ── */
.h-display {
  font-family: var(--font-display);
  font-weight: 500;
  color: var(--cream);
  letter-spacing: -0.01em;
  line-height: 1.12;
  margin: 0;
}
.h-display em { font-style: italic; color: var(--bronze-light); font-weight: 600; }

/* ── Botones (rectangulares, radius 2px) ── */
.btn-bronze {
  display: inline-flex; align-items: center; gap: 10px;
  font-family: var(--font-body); font-weight: 600; font-size: 15px;
  color: var(--bg); background: var(--bronze);
  padding: 16px 30px; border-radius: 2px; text-decoration: none;
  letter-spacing: 0.02em;
  transition: background 0.25s ease, transform 0.25s ease;
}
.btn-bronze:hover { background: var(--bronze-light); transform: translateY(-1px); }

.btn-outline {
  display: inline-flex; align-items: center; gap: 8px;
  font-family: var(--font-body); font-weight: 500; font-size: 14px;
  color: var(--bronze-light); background: transparent;
  border: 1px solid var(--line-strong);
  padding: 11px 22px; border-radius: 2px; text-decoration: none;
  white-space: nowrap;
  transition: border-color 0.25s ease, background 0.25s ease, color 0.25s ease;
}
.btn-outline:hover { border-color: var(--bronze-light); background: rgba(154,124,74,0.08); color: var(--cream); }

/* ── Reveals (activados por IntersectionObserver en Layout) ── */
.reveal {
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.7s ease-out, transform 0.7s ease-out;
}
.reveal.in { opacity: 1; transform: translateY(0); }

.reveal-line {
  transform: scaleX(0);
  transform-origin: left center;
  transition: transform 0.9s cubic-bezier(0.22, 1, 0.36, 1);
}
.reveal-line.in { transform: scaleX(1); }

/* delays para stagger dentro de una sección */
.d1 { transition-delay: 0.12s; }
.d2 { transition-delay: 0.24s; }
.d3 { transition-delay: 0.36s; }
.d4 { transition-delay: 0.48s; }

/* ── Keyframes ── */
@keyframes hero-line-in {
  from { opacity: 0; transform: translateY(26px); }
  to   { opacity: 1; transform: translateY(0); }
}

@keyframes bg-breathe {
  0%, 100% { background-position: 0% 50%; }
  50%      { background-position: 100% 50%; }
}

@keyframes typing-dot {
  0%, 80%, 100% { transform: scale(0.8); opacity: 0.4; }
  40%           { transform: scale(1.1); opacity: 1; }
}

@keyframes cursor-blink {
  0%, 49%   { opacity: 1; }
  50%, 100% { opacity: 0; }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@keyframes msg-in {
  from { opacity: 0; transform: translateY(10px) scale(0.97); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}

@keyframes chat-fade {
  from { opacity: 1; }
  to   { opacity: 0; }
}

/* ── Nav ── */
.nav-links { display: flex; gap: 26px; align-items: center; }
.nav-anchor {
  font-family: var(--font-body); font-size: 13.5px; font-weight: 400;
  color: var(--cream-60); text-decoration: none; letter-spacing: 0.02em;
  transition: color 0.2s ease;
}
.nav-anchor:hover { color: var(--cream); }

/* ── FAQ acordeón ── */
.faq-item { border-bottom: 1px solid var(--line); }
.faq-q {
  width: 100%; background: none; border: none; cursor: pointer;
  display: flex; justify-content: space-between; align-items: center; gap: 24px;
  padding: 26px 0; text-align: left;
  font-family: var(--font-display); font-weight: 500; font-size: 1.15rem;
  color: var(--cream);
}
.faq-q .faq-icon {
  flex-shrink: 0; color: var(--bronze); font-family: var(--font-body);
  font-size: 20px; font-weight: 300; line-height: 1;
  transition: transform 0.35s ease;
}
.faq-item.open .faq-icon { transform: rotate(45deg); }
.faq-a {
  display: grid; grid-template-rows: 0fr;
  transition: grid-template-rows 0.4s cubic-bezier(0.22, 1, 0.36, 1);
}
.faq-item.open .faq-a { grid-template-rows: 1fr; }
.faq-a > div { overflow: hidden; }
.faq-a p {
  font-family: var(--font-body); font-size: 0.95rem; font-weight: 300;
  color: var(--cream-60); line-height: 1.75; margin: 0; padding: 0 40px 26px 0;
}

/* ── Teclado WA (teclas activas) ── */
.kb-key { transition: background 0.08s ease; }
.kb-key.active, .kb-space.active { background: #A8B2BB !important; }

/* ── Grids responsive ── */
.grid-2col { display: grid; grid-template-columns: 1fr 1.3fr; gap: 56px; }
.grid-demo { display: grid; grid-template-columns: minmax(300px, 1fr) minmax(328px, 360px); gap: 64px; align-items: center; }
.grid-3col { display: grid; grid-template-columns: 1.2fr 1fr 1fr; }
.grid-features { display: grid; grid-template-columns: 1fr 1fr; gap: 0 64px; }

@media (max-width: 900px) {
  .section { padding: 80px 22px; }
  .grid-2col, .grid-demo, .grid-3col, .grid-features { grid-template-columns: 1fr; }
  .grid-2col { gap: 32px; }
  .grid-demo { gap: 48px; }
  .nav-links { display: none; }
}

@media (prefers-reduced-motion: reduce) {
  html { scroll-behavior: auto; }
  .reveal, .reveal-line { opacity: 1 !important; transform: none !important; transition: none !important; }
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

- [ ] **Step 2: Reescribir `src/layouts/Layout.astro`** con este contenido completo:

```astro
---
import '../styles/global.css';
interface Props {
  title?: string;
  description?: string;
}
const {
  title = 'VantAr — Asistente Virtual Inteligente para estudios jurídicos',
  description = 'Tu estudio, disponible 24/7 en WhatsApp. Un asistente con IA que atiende, entrevista, califica y agenda clientes solo — más publicidad que llena tu agenda de casos.',
} = Astro.props;
---
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>{title}</title>
    <meta name="description" content={description} />
    <meta property="og:title" content={title} />
    <meta property="og:description" content="Atiende. Entrevista. Califica. Agenda. Te avisa. Mientras dormís, tu estudio sigue captando clientes." />
    <meta property="og:type" content="website" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <link rel="shortcut icon" href="/favicon.svg" />
  </head>
  <body>
    <slot />
    <script>
      const io = new IntersectionObserver(
        (entries) => {
          for (const e of entries) {
            if (e.isIntersecting) {
              e.target.classList.add('in');
              io.unobserve(e.target);
            }
          }
        },
        { threshold: 0.15, rootMargin: '0px 0px -40px 0px' }
      );
      document.querySelectorAll('.reveal, .reveal-line').forEach((el) => io.observe(el));
    </script>
  </body>
</html>
```

- [ ] **Step 3: Verificar build**

Run: `npm run build`
Expected: build OK (los componentes viejos siguen compilando porque las clases viejas que usaban — `.btn-teal`, `.benefits-grid`, etc. — ya no existen pero CSS faltante no rompe el build; solo se ve sin estilos hasta reescribirlos).

- [ ] **Step 4: Commit**

```bash
git add src/styles/global.css src/layouts/Layout.astro
git commit -m "feat: fundacion editorial - tokens bronce, Fraunces, reveals, layout"
```

### Task 2: Logo rediseñado + favicon + Navbar

**Files:**
- Create: `src/components/Logo.astro`
- Modify: `public/favicon.svg` (reescritura)
- Modify: `src/components/Navbar.astro` (reescritura)

- [ ] **Step 1: Crear `src/components/Logo.astro`** — V crema esbelta + 3 nodos de circuito en bronce + wordmark Fraunces:

```astro
---
interface Props {
  size?: number;
  withWordmark?: boolean;
}
const { size = 30, withWordmark = true } = Astro.props;
---
<span style="display:inline-flex;align-items:center;gap:10px;">
  <svg viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg" style={`width:${size}px;height:${size}px;flex-shrink:0;`}>
    <path d="M12 14 L40 64 L68 14 L58.5 14 L40 47.5 L21.5 14 Z" fill="#EFEAE0"/>
    <line x1="17" y1="23" x2="26" y2="23" stroke="#9A7C4A" stroke-width="1.8" stroke-linecap="round"/>
    <circle cx="26" cy="23" r="2.4" fill="#9A7C4A"/>
    <line x1="63" y1="23" x2="54" y2="23" stroke="#9A7C4A" stroke-width="1.8" stroke-linecap="round"/>
    <circle cx="54" cy="23" r="2.4" fill="#9A7C4A"/>
    <line x1="40" y1="53" x2="40" y2="60" stroke="#9A7C4A" stroke-width="1.8" stroke-linecap="round"/>
    <circle cx="40" cy="60" r="2.4" fill="#9A7C4A"/>
  </svg>
  {withWordmark && (
    <span style="font-family:var(--font-display);font-weight:600;font-size:1.25rem;color:var(--cream);letter-spacing:-0.01em;">
      Vant<span style="color:var(--bronze);">Ar</span>
    </span>
  )}
</span>
```

- [ ] **Step 2: Reescribir `public/favicon.svg`** (mismo isotipo, fondo navy para que se vea en pestañas claras):

```svg
<svg viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect width="80" height="80" rx="16" fill="#080F1E"/>
  <path d="M16 18 L40 61 L64 18 L55.5 18 L40 46.5 L24.5 18 Z" fill="#EFEAE0"/>
  <line x1="21" y1="26" x2="29" y2="26" stroke="#9A7C4A" stroke-width="2" stroke-linecap="round"/>
  <circle cx="29" cy="26" r="2.5" fill="#9A7C4A"/>
  <line x1="59" y1="26" x2="51" y2="26" stroke="#9A7C4A" stroke-width="2" stroke-linecap="round"/>
  <circle cx="51" cy="26" r="2.5" fill="#9A7C4A"/>
  <line x1="40" y1="52" x2="40" y2="58" stroke="#9A7C4A" stroke-width="2" stroke-linecap="round"/>
  <circle cx="40" cy="58" r="2.5" fill="#9A7C4A"/>
</svg>
```

- [ ] **Step 3: Reescribir `src/components/Navbar.astro`**:

```astro
---
import Logo from './Logo.astro';
const WA_LINK = 'https://wa.me/5498944628576?text=Hola%2C%20quiero%20una%20demostraci%C3%B3n%20del%20asistente%20de%20VantAr';
const NAV_LINKS = [
  { href: '#el-problema', label: 'El problema' },
  { href: '#la-solucion', label: 'La solución' },
  { href: '#servicios',   label: 'Servicios' },
  { href: '#resultados',  label: 'Resultados' },
  { href: '#faq',         label: 'FAQ' },
];
---
<nav id="vs-navbar" style="position:fixed;top:0;left:0;right:0;z-index:50;padding:0 32px;height:74px;display:flex;align-items:center;justify-content:space-between;transition:background 0.35s ease,box-shadow 0.35s ease;background:transparent;">
  <a href="#" style="text-decoration:none;" aria-label="VantAr — inicio">
    <Logo size={30} />
  </a>
  <div style="display:flex;align-items:center;gap:32px;">
    <div class="nav-links">
      {NAV_LINKS.map(l => (
        <a href={l.href} class="nav-anchor">{l.label}</a>
      ))}
    </div>
    <a href={WA_LINK} target="_blank" rel="noopener noreferrer" class="btn-outline">
      Solicitar demostración
    </a>
  </div>
</nav>

<script>
  const nav = document.getElementById('vs-navbar');
  window.addEventListener('scroll', () => {
    if (!nav) return;
    if (window.scrollY > 32) {
      nav.style.background = 'rgba(8,15,30,0.92)';
      nav.style.backdropFilter = 'blur(14px)';
      (nav.style as any).webkitBackdropFilter = 'blur(14px)';
      nav.style.boxShadow = '0 1px 0 rgba(154,124,74,0.25)';
    } else {
      nav.style.background = 'transparent';
      nav.style.backdropFilter = '';
      (nav.style as any).webkitBackdropFilter = '';
      nav.style.boxShadow = '';
    }
  }, { passive: true });
</script>
```

- [ ] **Step 4: Verificar en dev**

Run: `npm run dev` → abrir http://localhost:4321
Expected: navbar con logo nuevo (V crema, nodos bronce, wordmark serif), CTA outline bronce. Al scrollear, fondo navy + filete bronce inferior.

- [ ] **Step 5: Commit**

```bash
git add src/components/Logo.astro public/favicon.svg src/components/Navbar.astro
git commit -m "feat: logo redisenado en bronce + navbar editorial"
```

---

### Task 3: Hero

**Files:**
- Modify: `src/components/Hero.astro` (reescritura completa)

- [ ] **Step 1: Reescribir `src/components/Hero.astro`**:

```astro
---
const WA_LINK = 'https://wa.me/5498944628576?text=Hola%2C%20quiero%20una%20demostraci%C3%B3n%20del%20asistente%20de%20VantAr';
const METRICS = [
  { value: '24/7',    label: 'Atención continua' },
  { value: '< 1 min', label: 'Primera respuesta' },
  { value: '0',       label: 'Consultas sin responder' },
];
---
<section style="min-height:100vh;display:flex;align-items:center;padding:140px 32px 90px;position:relative;overflow:hidden;background:linear-gradient(150deg,#060B17 0%,#0D1830 55%,#080F1E 100%);background-size:200% 200%;animation:bg-breathe 34s ease infinite;">

  <!-- filete vertical decorativo -->
  <div style="position:absolute;top:0;right:max(32px,calc((100% - 1140px)/2));width:1px;height:100%;background:linear-gradient(180deg,transparent,var(--line) 25%,var(--line) 75%,transparent);pointer-events:none;" class="hero-rule"></div>

  <div class="container" style="width:100%;position:relative;">
    <div style="margin-bottom:26px;animation:hero-line-in 0.7s ease-out 0.05s both;">
      <span style="font-family:var(--font-body);font-size:11px;font-weight:600;letter-spacing:0.3em;text-transform:uppercase;color:var(--bronze);">
        Inteligencia artificial para estudios jurídicos
      </span>
    </div>

    <h1 class="h-display" style="font-size:clamp(2.7rem,6vw,4.6rem);max-width:720px;">
      <span style="display:block;animation:hero-line-in 0.7s ease-out 0.18s both;">Tu estudio, atendiendo</span>
      <span style="display:block;animation:hero-line-in 0.7s ease-out 0.32s both;"><em>mientras dormís.</em></span>
    </h1>

    <div style="display:flex;gap:48px;margin-top:36px;align-items:flex-end;flex-wrap:wrap;animation:hero-line-in 0.7s ease-out 0.5s both;">
      <p style="font-family:var(--font-body);font-size:clamp(0.95rem,1.6vw,1.1rem);font-weight:300;color:var(--cream-60);line-height:1.85;max-width:430px;margin:0;">
        Un asistente con IA integrado al WhatsApp de tu estudio: atiende, entrevista,
        califica y agenda — las 24 horas, los 365 días. Vos solo aparecés cuando
        el cliente ya está listo.
      </p>
      <a href="#la-solucion" class="btn-bronze">
        Ver la demostración
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12l7 7 7-7" stroke-linecap="round" stroke-linejoin="round"/></svg>
      </a>
    </div>

    <!-- banda de métricas -->
    <div style="display:flex;margin-top:70px;border-top:1px solid var(--line);max-width:620px;animation:hero-line-in 0.7s ease-out 0.66s both;" class="hero-metrics">
      {METRICS.map((m, i) => (
        <>
          {i > 0 && <div style="width:1px;background:var(--line);margin:0 36px;" class="metric-divider"></div>}
          <div style="padding-top:22px;">
            <div style="font-family:var(--font-display);font-size:1.9rem;font-weight:600;color:var(--bronze-light);line-height:1;">{m.value}</div>
            <div style="font-family:var(--font-body);font-size:10px;color:var(--cream-40);letter-spacing:0.1em;text-transform:uppercase;margin-top:8px;">{m.label}</div>
          </div>
        </>
      ))}
    </div>
  </div>
</section>

<style>
  @media (max-width: 900px) {
    .hero-rule { display: none; }
    .hero-metrics { flex-wrap: wrap; gap: 20px 0; }
    .metric-divider { margin: 0 20px !important; }
  }
</style>
```

- [ ] **Step 2: Verificar en dev**

Run: `npm run dev` → http://localhost:4321
Expected: headline serif en dos líneas con stagger al cargar, "mientras dormís." en itálica bronce, métricas con filetes, fondo navy que respira lento. Sin cyan, sin glow blobs.

- [ ] **Step 3: Commit**

```bash
git add src/components/Hero.astro
git commit -m "feat: hero editorial asimetrico con banda de metricas"
```

### Task 4: Problem

**Files:**
- Create: `src/components/Problem.astro`

- [ ] **Step 1: Crear `src/components/Problem.astro`**:

```astro
---
const PAINS = [
  'Las consultas no esperan: llegan un domingo a la noche, un feriado, a las 2 de la madrugada. Si no contestás en minutos, el cliente le escribe al estudio de al lado.',
  'Perdés horas en consultas que no van a ningún lado, mientras los casos urgentes esperan.',
  'La agenda es un ida y vuelta eterno de horarios — turnos pisados y ausentes que no avisan.',
  'Llegás a la primera reunión sin contexto, y arrancás de cero preguntando lo básico.',
  'Gente que escribe, cuenta su problema… y desaparece. Un lead que costó conseguir, perdido por silencio.',
];
const LETTERS = ['a', 'b', 'c', 'd', 'e'];
---
<section id="el-problema" class="section section-alt" style="border-top:1px solid var(--line);">
  <div class="container">
    <div class="label-sec reveal">El problema</div>

    <div class="grid-2col" style="margin-top:36px;">
      <h2 class="h-display reveal d1" style="font-size:clamp(1.9rem,3.4vw,2.8rem);">
        Lo que conocés<br />de memoria.
      </h2>

      <div>
        {PAINS.map((pain, i) => (
          <div class={`reveal d${Math.min(i + 1, 4)}`} style={`display:flex;gap:20px;align-items:baseline;padding:18px 0;${i < PAINS.length - 1 ? 'border-bottom:1px solid rgba(239,234,224,0.07);' : ''}`}>
            <span style="font-family:var(--font-display);font-style:italic;font-size:1rem;color:var(--bronze);flex-shrink:0;width:18px;">{LETTERS[i]}.</span>
            <p style="font-family:var(--font-body);font-size:0.95rem;font-weight:300;color:var(--cream-60);line-height:1.75;margin:0;">{pain}</p>
          </div>
        ))}
      </div>
    </div>

    <p class="reveal" style="font-family:var(--font-display);font-style:italic;font-size:clamp(1.05rem,2vw,1.3rem);color:var(--bronze-light);text-align:center;margin:64px auto 0;max-width:640px;">
      Cada una de esas situaciones es un cliente — y honorarios — que se escapan.
    </p>
  </div>
</section>
```

- [ ] **Step 2: Verificar en dev** (agregar temporalmente `<Problem />` a `index.astro` después de `<Hero />` si todavía no está el index final; el wiring definitivo es Task 12)

Expected: título a la izquierda, lista foliada `a.–e.` con reveals escalonados, cierre en itálica centrado.

- [ ] **Step 3: Commit**

```bash
git add src/components/Problem.astro src/pages/index.astro
git commit -m "feat: seccion El problema con lista foliada"
```

---

### Task 5: FlowDiagram — demo del teléfono con chat WA mejorado

**Files:**
- Modify: `src/components/FlowDiagram.astro` (reescritura completa)

Esta es la task más grande. El componente tiene 3 partes: (A) columna izquierda de copy, (B) el iPhone (se conserva el marco actual: botones laterales, status bar, Dynamic Island, input bar, teclado virtual — copiar tal cual del componente actual), (C) el motor JS nuevo.

**Cambios estructurales dentro del teléfono respecto del actual:**
1. El avatar del header WA y el nombre pasan a: logo nuevo (V crema con nodos bronce, fondo `#0D1830`) y "VantAr — Asistente".
2. Se agrega un chip de fecha al inicio de los mensajes: `<div style="align-self:center;background:#FFF;border-radius:8px;padding:4px 10px;font-size:11px;color:#54656F;box-shadow:0 1px 1px rgba(0,0,0,0.08);font-family:-apple-system,sans-serif;">Hoy</div>`.
3. Cada mensaje del cliente lleva las tildes en un `<span class="ticks" data-ticks>` para que el JS las haga progresar (estados: `sent` ✓ gris, `delivered` ✓✓ gris, `read` ✓✓ azul `#53BDEB`).
4. El mensaje de audio (data-msg="4") arranca con waveform gris; el JS lo "reproduce" (barras a verde progresivamente + contador). La transcripción vive en un `<div data-transcript style="display:none;">` que el JS muestra después.
5. El mensaje de imagen (data-msg="6") tiene un overlay de subida: `<div data-upload-overlay>` con blur + spinner + porcentaje, que el JS desvanece.
6. El contenedor de mensajes scrollea con `behavior:'smooth'`.

- [ ] **Step 1: Reescribir la sección y columna izquierda** (estructura exterior del componente):

```astro
---
const FEATURES_DEMO = [
  'Entrevista con criterio, como una secretaria con experiencia',
  'Transcribe audios y lee documentos e imágenes',
  'Agenda el turno directo en tu Google Calendar',
];
---
<section id="la-solucion" class="section" style="position:relative;">
  <div class="container">
    <div class="label-sec reveal">La solución, en vivo</div>

    <div class="grid-demo" style="margin-top:48px;">
      <!-- Columna copy -->
      <div>
        <h2 class="h-display reveal d1" style="font-size:clamp(1.9rem,3.4vw,2.8rem);">
          No te lo contamos.<br /><em>Miralo atender.</em>
        </h2>
        <p class="reveal d2" style="font-family:var(--font-body);font-size:0.98rem;font-weight:300;color:var(--cream-60);line-height:1.85;margin:24px 0 0;max-width:400px;">
          Esto es una conversación del asistente, igual a las que va a tener con
          tus clientes: entiende el caso, pide lo que falta y cierra el turno —
          sin que vos toques el teléfono.
        </p>
        <div style="margin-top:34px;display:flex;flex-direction:column;gap:16px;">
          {FEATURES_DEMO.map((f, i) => (
            <div class={`reveal d${i + 2}`} style="display:flex;gap:16px;align-items:center;">
              <div class="reveal-line" style="width:26px;height:1px;background:var(--bronze);flex-shrink:0;"></div>
              <span style="font-family:var(--font-body);font-size:0.9rem;color:var(--cream-60);">{f}</span>
            </div>
          ))}
        </div>
      </div>

      <!-- Columna teléfono: marco iPhone actual SIN CAMBIOS estructurales,
           salvo los 6 puntos listados arriba. Mantener: botones laterales,
           body del phone, status bar, Dynamic Island, WA header (re-brandeado),
           mensajes data-msg 0-13 con el guion EXACTO actual, typing indicator,
           input bar, teclado virtual completo, USB-C. -->
      <div style="display:flex;justify-content:center;align-items:flex-start;" class="reveal d2" id="phone-wrap">
        <!-- ...marco iPhone (copiar del FlowDiagram actual, líneas 70-369, aplicando los cambios 1-6)... -->
      </div>
    </div>
  </div>
</section>
```

**Guion del chat (sin cambios, 14 mensajes):** los textos exactos de `CHAT` en el componente actual (accidente laboral: saludo → cuándo → cómo (audio) → informe (imagen) → lectura del informe → ART → empleador → disponibilidad → confirmación de turno).

- [ ] **Step 2: Implementar el motor JS nuevo** (reemplaza el `<script>` actual completo):

```js
(function () {
  const CHAT = [
    { from: 'client', type: 'text',  text: 'Hola, sufrí un accidente laboral y necesito asesoramiento' },
    { from: 'agent',  type: 'text',  text: '¡Hola! Con gusto te ayudamos. ¿Cuándo ocurrió el accidente?' },
    { from: 'client', type: 'text',  text: 'Fue el lunes a la mañana' },
    { from: 'agent',  type: 'text',  text: '¿Podés contarnos brevemente cómo fue?' },
    { from: 'client', type: 'audio' },
    { from: 'agent',  type: 'text',  text: 'Entendido. ¿Podés enviarnos el informe médico de la guardia?' },
    { from: 'client', type: 'image' },
    { from: 'agent',  type: 'text',  text: 'Recibí el informe. Veo que el diagnóstico es esguince grado II de muñeca derecha, atendido el lunes a las 10:23 hs por el Dr. Ramírez. Anotado. ¿Tu empresa tiene ART?' },
    { from: 'client', type: 'text',  text: 'Sí, creo que es Galeno' },
    { from: 'agent',  type: 'text',  text: '¿Tu empleador estaba al tanto cuando ocurrió?' },
    { from: 'client', type: 'text',  text: 'Sí, le avisé a mi jefe ese mismo día' },
    { from: 'agent',  type: 'text',  text: 'Perfecto. ¿Tenés disponibilidad esta semana para una consulta?' },
    { from: 'client', type: 'text',  text: 'El jueves a la mañana me viene bien' },
    { from: 'agent',  type: 'text',  text: 'Te confirmo turno para el jueves a las 10:00 hs. Te va a atender la Dra. Peralta. ¡Hasta el jueves!' },
  ];

  let i = 0;
  let running = false;
  let timers = [];

  const $ = (sel) => document.querySelector(sel);
  const msgs     = $('#chat-messages');
  const typing   = $('#typing-indicator');
  const inputEl  = $('#input-display');
  const cursor   = $('#cursor-blink');
  const sendIcon = $('#send-icon');
  const camIcon  = $('#camera-icon');
  const waStatus = $('#wa-status');
  const phone    = $('#phone-wrap');

  const wait = (ms) => new Promise((res) => { const t = setTimeout(res, ms); timers.push(t); });
  const jitter = (ms, spread = 0.35) => ms * (1 - spread + Math.random() * spread * 2);

  function scrollBottom() {
    if (msgs) msgs.scrollTo({ top: msgs.scrollHeight, behavior: 'smooth' });
  }

  function setStatus(text) {
    if (!waStatus) return;
    waStatus.textContent = text;
    waStatus.style.color = text === 'en línea' ? 'rgba(255,255,255,0.7)' : '#A8E6D0';
  }

  function showMsg(idx) {
    const el = document.querySelector(`[data-msg="${idx}"]`);
    if (el) {
      el.style.display = 'flex';
      el.style.animation = 'msg-in 0.3s ease-out both';
      scrollBottom();
    }
    return el;
  }

  // tildes: sent (✓ gris) → delivered (✓✓ gris) → read (✓✓ azul)
  async function progressTicks(el) {
    const ticks = el && el.querySelector('[data-ticks]');
    if (!ticks) return;
    ticks.dataset.state = 'sent';
    await wait(jitter(500));
    ticks.dataset.state = 'delivered';
    await wait(jitter(700));
    ticks.dataset.state = 'read';
  }

  function setInput(text) {
    if (!inputEl) return;
    if (text) {
      inputEl.textContent = text;
      inputEl.style.color = '#111';
      if (sendIcon) sendIcon.style.display = 'flex';
      if (camIcon) camIcon.style.display = 'none';
    } else {
      inputEl.textContent = 'Mensaje';
      inputEl.style.color = '#9EA5AE';
      if (sendIcon) sendIcon.style.display = 'none';
      if (camIcon) camIcon.style.display = 'block';
    }
  }

  function setActiveKey(key) {
    document.querySelectorAll('.kb-key').forEach((k) => k.classList.remove('active'));
    if (key) {
      const el = document.querySelector(`[data-key="${key.toUpperCase()}"]`);
      if (el) el.classList.add('active');
    }
  }

  async function clientTypes(text) {
    if (cursor) cursor.style.display = 'inline-block';
    await wait(jitter(900)); // el cliente "piensa"
    for (let c = 1; c <= text.length; c++) {
      const ch = text[c - 1];
      setInput(text.slice(0, c));
      setActiveKey(ch);
      // velocidad humana: 45-110ms con pausas ocasionales
      await wait(45 + Math.random() * 65 + (Math.random() < 0.06 ? 220 : 0));
      setActiveKey('');
    }
    await wait(jitter(450));
    setInput('');
    if (cursor) cursor.style.display = 'none';
  }

  async function playAudio(el) {
    const bars = el ? Array.from(el.querySelectorAll('[data-wavebar]')) : [];
    const counter = el && el.querySelector('[data-audio-time]');
    const total = 14; // segundos del audio (0:14)
    const perBar = (total * 1000) / Math.max(bars.length, 1);
    for (let b = 0; b < bars.length; b++) {
      bars[b].style.background = '#128C7E';
      if (counter) {
        const secs = Math.floor(((b + 1) / bars.length) * total);
        counter.textContent = `0:${String(secs).padStart(2, '0')}`;
      }
      await wait(perBar / 14); // acelerado x14 para no aburrir (~1s total)
    }
  }

  async function step() {
    if (i >= CHAT.length) {
      await wait(4000); // pausa con la conversación completa
      if (msgs) {
        msgs.style.animation = 'chat-fade 0.6s ease both';
        await wait(650);
        document.querySelectorAll('[data-msg]').forEach((el) => { el.style.display = 'none'; });
        const overlay = document.querySelector('[data-upload-overlay]');
        if (overlay) overlay.style.opacity = '1';
        document.querySelectorAll('[data-wavebar]').forEach((b) => { b.style.background = '#A0A8A0'; });
        const at = document.querySelector('[data-audio-time]');
        if (at) at.textContent = '0:14';
        const tr = document.querySelector('[data-transcript]');
        if (tr) tr.style.display = 'none';
        msgs.style.animation = '';
      }
      i = 0;
      return step();
    }

    const m = CHAT[i];

    if (m.from === 'agent') {
      // el agente "lee" lo recibido y escribe
      await wait(jitter(800));
      setStatus('escribiendo…');
      if (typing) { typing.style.display = 'flex'; scrollBottom(); }
      await wait(Math.min((m.text?.length ?? 20) * 28 + 700, 3400));
      if (typing) typing.style.display = 'none';
      setStatus('en línea');
      showMsg(i);
    } else if (m.type === 'audio') {
      setStatus('grabando audio…');
      await wait(jitter(2600));
      setStatus('en línea');
      const el = showMsg(i);
      progressTicks(el);
      await wait(600);
      await playAudio(el);
      const tr = el && el.querySelector('[data-transcript]');
      if (tr) { tr.style.display = 'block'; scrollBottom(); } // transcripción "procesada"
    } else if (m.type === 'image') {
      await wait(jitter(1600));
      const el = showMsg(i);
      progressTicks(el);
      const overlay = el && el.querySelector('[data-upload-overlay]');
      const pct = el && el.querySelector('[data-upload-pct]');
      if (overlay && pct) {
        for (let p = 0; p <= 100; p += 4 + Math.floor(Math.random() * 9)) {
          pct.textContent = `${Math.min(p, 100)}%`;
          await wait(70);
        }
        overlay.style.transition = 'opacity 0.4s ease';
        overlay.style.opacity = '0';
      }
    } else {
      await clientTypes(m.text);
      const el = showMsg(i);
      progressTicks(el);
    }

    i++;
    await wait(jitter(500));
    return step();
  }

  function stopAll() {
    timers.forEach(clearTimeout);
    timers = [];
    running = false;
  }

  // arranca al entrar en viewport, se pausa al salir
  const io = new IntersectionObserver((entries) => {
    for (const e of entries) {
      if (e.isIntersecting && !running) {
        running = true;
        step();
      } else if (!e.isIntersecting && running) {
        stopAll();
      }
    }
  }, { threshold: 0.35 });
  if (phone) io.observe(phone);
})();
```

**Nota de implementación de tildes:** cada mensaje del cliente reemplaza el SVG fijo actual por:

```html
<span data-ticks data-state="none" style="display:inline-flex;align-items:center;">
  <svg width="16" height="11" viewBox="0 0 16 11" fill="none">
    <path class="tick-1" d="M1 6L4 9L10 1" stroke="#9AA5AC" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
    <path class="tick-2" d="M6 6L9 9L15 1" stroke="#9AA5AC" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" style="opacity:0;"/>
  </svg>
</span>
```

con este CSS en el `<style>` del componente (o global.css):

```css
[data-ticks][data-state="none"] svg { opacity: 0; }
[data-ticks][data-state="sent"] .tick-2 { opacity: 0 !important; }
[data-ticks][data-state="delivered"] .tick-2 { opacity: 1 !important; }
[data-ticks][data-state="read"] .tick-1,
[data-ticks][data-state="read"] .tick-2 { stroke: #53BDEB; opacity: 1 !important; }
[data-ticks] .tick-1, [data-ticks] .tick-2 { transition: opacity 0.2s ease, stroke 0.3s ease; }
```

**Waveform del audio:** las barras actuales pasan a `<div data-wavebar style="width:2px;height:Npx;background:#A0A8A0;border-radius:2px;">` (todas grises al inicio; el JS las pinta de verde al "reproducir"). El span de tiempo actual pasa a `<span data-audio-time>0:14</span>`.

**Overlay de subida de la imagen:** dentro del contenedor del mini-documento médico, como primer hijo posicionado:

```html
<div data-upload-overlay style="position:absolute;inset:0;z-index:2;background:rgba(240,238,232,0.55);backdrop-filter:blur(6px);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;opacity:1;">
  <div style="width:34px;height:34px;border-radius:50%;border:3px solid rgba(0,0,0,0.15);border-top-color:#128C7E;animation:spin 0.8s linear infinite;"></div>
  <span data-upload-pct style="font-family:-apple-system,sans-serif;font-size:11px;font-weight:600;color:#333;">0%</span>
</div>
```

- [ ] **Step 3: Verificar en dev**

Expected: el chat arranca solo al scrollear hasta el teléfono y siempre desde el principio; tildes progresan gris→gris→azul; "grabando audio…" antes del audio; el audio se reproduce (barras verdes + contador) y después aparece la transcripción; la imagen sube con spinner y porcentaje antes de revelarse; al final pausa de 4s y fade de reinicio. Verificar también que al salir del viewport y volver, reinicia limpio.

- [ ] **Step 4: Verificar build**

Run: `npm run build`
Expected: OK sin errores de TypeScript en el script.

- [ ] **Step 5: Commit**

```bash
git add src/components/FlowDiagram.astro src/styles/global.css
git commit -m "feat: demo WA realista - tildes, audio, subida de imagen, viewport pause"
```

### Task 6: Features (9 funcionalidades)

**Files:**
- Create: `src/components/Features.astro`

- [ ] **Step 1: Crear `src/components/Features.astro`**:

```astro
---
const FEATURES = [
  { n: '01', title: 'Atención inmediata, 24/7/365',        desc: 'Responde al instante, a cualquier hora. Tu cliente nunca queda en visto.' },
  { n: '02', title: 'Entrevista legal inteligente',        desc: 'Conversa con naturalidad, deja que la persona cuente su situación y hace solo las preguntas necesarias para perfilar el caso. No es un formulario.' },
  { n: '03', title: 'Entiende texto, audios e imágenes',   desc: 'Transcribe mensajes de voz y recibe fotos — un documento, una notificación, una lesión — y las suma al caso. Nada se pierde.' },
  { n: '04', title: 'Agenda los turnos solo',              desc: 'Consulta tu disponibilidad real, ofrece horarios concretos y reserva directo en tu Google Calendar.' },
  { n: '05', title: 'Recordatorios automáticos',           desc: 'Le recuerda al cliente su turno por WhatsApp. Menos ausentes, menos agenda desperdiciada.' },
  { n: '06', title: 'Recupera conversaciones frías',       desc: 'Si alguien consultó y se quedó callado, lo vuelve a contactar con naturalidad. Leads que antes morían, ahora vuelven.' },
  { n: '07', title: 'Te entrega el caso listo y priorizado', desc: 'Informe automático con resumen, datos clave y urgencia (Alta / Media / Baja), a tu mail y WhatsApp. Llegás a la reunión ya briefeado.' },
  { n: '08', title: 'Memoria de cada cliente',             desc: 'Reconoce a quienes ya consultaron y mantiene el historial. Atención personalizada, sin repetir todo cada vez.' },
  { n: '09', title: 'Tu propio asistente como abogado',    desc: 'Vos también podés consultarle tu agenda, tus turnos y tus casos por WhatsApp. Tu estudio en el bolsillo.' },
];
---
<section class="section section-alt" style="border-top:1px solid var(--line);">
  <div class="container">
    <div class="label-sec reveal">Qué hace</div>
    <h2 class="h-display reveal d1" style="font-size:clamp(1.9rem,3.4vw,2.8rem);margin-top:36px;max-width:520px;">
      Un proceso completo<br />de captación. <em>No un chatbot.</em>
    </h2>

    <div class="grid-features" style="margin-top:56px;">
      {FEATURES.map((f, i) => (
        <div class={`reveal d${(i % 2) + 1}`} style="display:flex;gap:24px;align-items:baseline;padding:26px 0;border-bottom:1px solid rgba(239,234,224,0.07);">
          <span style="font-family:var(--font-body);font-size:11px;font-weight:500;color:var(--bronze);letter-spacing:0.1em;flex-shrink:0;">{f.n}</span>
          <div>
            <h3 style="font-family:var(--font-display);font-weight:600;font-size:1.08rem;color:var(--cream);margin:0 0 8px;">{f.title}</h3>
            <p style="font-family:var(--font-body);font-size:0.88rem;font-weight:300;color:var(--cream-60);line-height:1.7;margin:0;">{f.desc}</p>
          </div>
        </div>
      ))}
    </div>
  </div>
</section>
```

- [ ] **Step 2: Verificar en dev** — lista editorial de 2 columnas con numeración fina, sin cards ni iconos.

- [ ] **Step 3: Commit**

```bash
git add src/components/Features.astro src/pages/index.astro
git commit -m "feat: seccion Que hace - 9 funcionalidades en lista editorial"
```

---

### Task 7: Services (reemplaza Offering) + eliminar componentes absorbidos

**Files:**
- Create: `src/components/Services.astro`
- Delete: `src/components/Offering.astro`, `src/components/Benefits.astro`, `src/components/HowItWorks.astro`

- [ ] **Step 1: Crear `src/components/Services.astro`**:

```astro
---
const SERVICES = [
  {
    kicker: 'El asistente',
    title: 'Asistente Virtual Inteligente',
    desc: 'Atiende, entrevista, califica, agenda y te entrega cada caso resumido y priorizado. La estrella del sistema: tu estudio disponible 24/7 en WhatsApp.',
  },
  {
    kicker: 'El motor',
    title: 'Publicidad que trae casos',
    desc: 'Campañas en Google y Meta que ponen tu estudio frente a personas que ya están buscando un abogado. Cada consulta pasa por el asistente antes de llegar a vos.',
  },
  {
    kicker: 'La presencia',
    title: 'Web y marca personal',
    desc: 'Tu sitio y tu imagen profesional, a la altura de los honorarios que cobrás. La primera impresión también cierra casos.',
  },
];
---
<section id="servicios" class="section">
  <div class="container">
    <div class="label-sec reveal">Servicios</div>
    <h2 class="h-display reveal d1" style="font-size:clamp(1.9rem,3.4vw,2.8rem);margin-top:36px;max-width:480px;">
      Un sistema completo<br />de captación.
    </h2>

    <div class="grid-3col" style="margin-top:52px;border-top:1px solid var(--line-strong);">
      {SERVICES.map((s, i) => (
        <div class={`reveal d${i + 1} service-col`} style={`padding:32px ${i === 2 ? '0' : '36px'} 8px ${i === 0 ? '0' : '36px'};${i < 2 ? 'border-right:1px solid var(--line);' : ''}`}>
          <div style="font-family:var(--font-display);font-style:italic;font-size:0.95rem;color:var(--bronze);margin-bottom:12px;">{s.kicker}</div>
          <h3 style="font-family:var(--font-display);font-weight:600;font-size:1.35rem;color:var(--cream);margin:0;line-height:1.3;">{s.title}</h3>
          <p style="font-family:var(--font-body);font-size:0.9rem;font-weight:300;color:var(--cream-60);line-height:1.75;margin:14px 0 0;">{s.desc}</p>
        </div>
      ))}
    </div>
  </div>
</section>

<style>
  @media (max-width: 900px) {
    .service-col {
      padding: 28px 0 !important;
      border-right: none !important;
      border-bottom: 1px solid var(--line);
    }
    .service-col:last-child { border-bottom: none; }
  }
</style>
```

- [ ] **Step 2: Eliminar componentes absorbidos** (y quitar sus imports de `index.astro` para que el build no rompa):

```bash
git rm src/components/Offering.astro src/components/Benefits.astro src/components/HowItWorks.astro
```

- [ ] **Step 3: Verificar build** — `npm run build` → OK.

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: seccion Servicios con filetes verticales; elimina Offering/Benefits/HowItWorks"
```

---

### Task 8: Results (métricas count-up + testimonio provisorio)

**Files:**
- Modify: `src/components/Results.astro` (reescritura completa)

- [ ] **Step 1: Reescribir `src/components/Results.astro`**:

```astro
---
// Métricas extrapoladas de la campaña real (4 casos cerrados con turno en 48hs).
// Actualizar cuando haya datos consolidados de más semanas.
const METRICS = [
  { value: 12, prefix: '+', suffix: '',  label: 'casos con turno agendado por semana de campaña' },
  { value: 4,  prefix: '×', suffix: '',  label: 'retorno sobre la inversión desde el primer mes' },
];
---
<section id="resultados" class="section section-alt" style="border-top:1px solid var(--line);">
  <div class="container">
    <div class="label-sec reveal">Resultados</div>

    <div style="display:flex;gap:56px;margin-top:56px;align-items:center;flex-wrap:wrap;" class="results-row">
      {METRICS.map((m, i) => (
        <>
          {i > 0 && <div style="width:1px;height:88px;background:var(--line);" class="results-divider"></div>}
          <div class={`reveal d${i + 1}`} style="flex:1;min-width:200px;">
            <div style="font-family:var(--font-display);font-size:clamp(3.2rem,6vw,4.6rem);font-weight:600;color:var(--bronze-light);line-height:1;">
              {m.prefix}<span data-count={m.value}>0</span>{m.suffix}
            </div>
            <div style="font-family:var(--font-body);font-size:11px;color:var(--cream-40);letter-spacing:0.1em;text-transform:uppercase;margin-top:14px;max-width:240px;line-height:1.6;">{m.label}</div>
          </div>
        </>
      ))}

      <div style="width:1px;height:88px;background:var(--line);" class="results-divider"></div>

      <!-- PROVISORIO: reemplazar con testimonio real cuando haya datos/permiso del cliente -->
      <blockquote class="reveal d3" style="flex:1.4;min-width:260px;margin:0;">
        <p style="font-family:var(--font-display);font-style:italic;font-size:clamp(1.05rem,1.8vw,1.25rem);color:rgba(239,234,224,0.85);line-height:1.7;margin:0;">
          "Con un solo caso cerrado, el sistema ya se pagó el mes.
          Todo lo demás es ganancia."
        </p>
      </blockquote>
    </div>
  </div>
</section>

<script>
  // count-up de métricas: una sola vez, al entrar al viewport
  const els = document.querySelectorAll('[data-count]');
  const io = new IntersectionObserver((entries) => {
    for (const e of entries) {
      if (!e.isIntersecting) continue;
      io.unobserve(e.target);
      const el = e.target as HTMLElement;
      const target = parseInt(el.dataset.count || '0', 10);
      const dur = 1200;
      const t0 = performance.now();
      const tick = (now: number) => {
        const p = Math.min((now - t0) / dur, 1);
        const eased = 1 - Math.pow(1 - p, 3); // ease-out cubic
        el.textContent = String(Math.round(eased * target));
        if (p < 1) requestAnimationFrame(tick);
      };
      requestAnimationFrame(tick);
    }
  }, { threshold: 0.5 });
  els.forEach((el) => io.observe(el));
</script>

<style>
  @media (max-width: 900px) {
    .results-divider { display: none; }
    .results-row { gap: 40px !important; }
  }
</style>
```

- [ ] **Step 2: Verificar en dev** — números cuentan de 0 a 12 / 0 a 4 al scrollear hasta la sección, una sola vez. Testimonio en itálica serif.

- [ ] **Step 3: Commit**

```bash
git add src/components/Results.astro src/pages/index.astro
git commit -m "feat: resultados con metricas count-up y testimonio provisorio"
```

### Task 9: Process (timeline 5 pasos)

**Files:**
- Create: `src/components/Process.astro`

- [ ] **Step 1: Crear `src/components/Process.astro`**:

```astro
---
const STEPS = [
  { n: '1', title: 'Relevamiento',           desc: 'Entendemos cómo trabaja tu estudio y qué necesitás.' },
  { n: '2', title: 'Configuración a medida', desc: 'Adaptamos preguntas, tono y reglas a tu práctica.' },
  { n: '3', title: 'Pruebas',                desc: 'Lo dejamos fino antes de que hable con un cliente real.' },
  { n: '4', title: 'Salida en vivo',         desc: 'Tu asistente empieza a atender.' },
  { n: '5', title: 'Acompañamiento',         desc: 'Ajustes y soporte continuo.' },
];
---
<section class="section">
  <div class="container">
    <div class="label-sec reveal">Proceso</div>
    <h2 class="h-display reveal d1" style="font-size:clamp(1.9rem,3.4vw,2.8rem);margin-top:36px;max-width:520px;">
      En marcha <em>en pocos días.</em>
    </h2>

    <div style="position:relative;margin-top:64px;" class="process-track">
      <!-- línea base + línea que se dibuja -->
      <div style="position:absolute;top:5px;left:0;right:0;height:1px;background:rgba(239,234,224,0.08);" class="process-line-bg"></div>
      <div class="reveal-line process-line" style="position:absolute;top:5px;left:0;right:0;height:1px;background:var(--bronze);transition-duration:1.6s;"></div>

      <div style="display:grid;grid-template-columns:repeat(5,1fr);gap:24px;" class="process-grid">
        {STEPS.map((s, i) => (
          <div class={`reveal d${Math.min(i + 1, 4)}`}>
            <div style="width:11px;height:11px;border-radius:50%;background:var(--bg);border:1.5px solid var(--bronze);position:relative;z-index:1;"></div>
            <div style="font-family:var(--font-display);font-style:italic;font-size:0.95rem;color:var(--bronze);margin-top:20px;">{s.n}.</div>
            <h3 style="font-family:var(--font-display);font-weight:600;font-size:1.05rem;color:var(--cream);margin:8px 0 0;">{s.title}</h3>
            <p style="font-family:var(--font-body);font-size:0.85rem;font-weight:300;color:var(--cream-60);line-height:1.65;margin:10px 0 0;">{s.desc}</p>
          </div>
        ))}
      </div>
    </div>

    <p class="reveal" style="font-family:var(--font-display);font-style:italic;font-size:1.05rem;color:var(--cream-60);text-align:center;margin:56px 0 0;">
      Sin instalaciones complicadas de tu lado. Nos encargamos de todo.
    </p>
  </div>
</section>

<style>
  @media (max-width: 900px) {
    .process-grid { grid-template-columns: 1fr !important; gap: 36px !important; }
    .process-line-bg, .process-line {
      top: 0 !important; left: 5px !important; right: auto !important;
      width: 1px !important; height: 100% !important;
    }
    .process-line { transform-origin: top center !important; }
  }
</style>
```

**Nota:** en mobile la línea es vertical; `.reveal-line` usa `scaleX` — para mobile la regla CSS de arriba la rota implícitamente al ser width:1px/height:100%, pero `scaleX(0)` colapsaría el ancho. Agregar al `<style>` del componente:

```css
@media (max-width: 900px) {
  .process-line { transform: scaleY(0); transition-property: transform; }
  .process-line.in { transform: scaleY(1); }
}
```

- [ ] **Step 2: Verificar en dev** — línea horizontal se dibuja al llegar a la sección; en mobile (DevTools, 390px) la línea es vertical y los pasos se apilan.

- [ ] **Step 3: Commit**

```bash
git add src/components/Process.astro src/pages/index.astro
git commit -m "feat: timeline de proceso con linea que se dibuja"
```

---

### Task 10: FAQ (acordeón)

**Files:**
- Create: `src/components/FAQ.astro`

- [ ] **Step 1: Crear `src/components/FAQ.astro`** (el CSS del acordeón ya está en global.css desde Task 1):

```astro
---
const FAQS = [
  { q: '¿Reemplaza a mi secretaria?', a: 'No. La libera de lo repetitivo —contestar lo mismo cien veces, coordinar turnos— para que dedique su tiempo a lo que realmente aporta valor. Es un refuerzo, no un reemplazo.' },
  { q: '¿Y si el cliente prefiere hablar con una persona?', a: 'El asistente lo entiende, no insiste y te deriva el contacto. La atención humana siempre queda disponible.' },
  { q: '¿Es confidencial y seguro?', a: 'Sí. La información queda protegida y registrada, y el asistente nunca da asesoramiento legal ni divulga datos sensibles.' },
  { q: '¿Necesito saber de tecnología?', a: 'Para nada. Nosotros lo configuramos, lo mantenemos y lo mejoramos. Vos solo recibís los clientes.' },
  { q: '¿Se adapta a mi forma de trabajar?', a: 'Totalmente. Tono, preguntas, horarios, tipos de caso y mensajes: todo se ajusta a tu estudio.' },
  { q: '¿En qué horario atiende?', a: 'Las 24 horas, todos los días del año. Incluso cuando vos no podés.' },
  { q: '¿Qué pasa con una consulta rara o muy compleja?', a: 'La encamina y la deriva a la reunión con vos. Nunca improvisa respuestas legales.' },
];
---
<section id="faq" class="section section-alt" style="border-top:1px solid var(--line);">
  <div class="container" style="max-width:820px;">
    <div class="label-sec reveal">Preguntas frecuentes</div>
    <h2 class="h-display reveal d1" style="font-size:clamp(1.9rem,3.4vw,2.8rem);margin:36px 0 40px;">
      Lo que todos preguntan<br /><em>antes de empezar.</em>
    </h2>

    <div style="border-top:1px solid var(--line);">
      {FAQS.map((f, i) => (
        <div class={`faq-item reveal d${Math.min((i % 3) + 1, 3)}`}>
          <button class="faq-q" aria-expanded="false">
            {f.q}
            <span class="faq-icon" aria-hidden="true">+</span>
          </button>
          <div class="faq-a">
            <div><p>{f.a}</p></div>
          </div>
        </div>
      ))}
    </div>
  </div>
</section>

<script>
  document.querySelectorAll('.faq-item').forEach((item) => {
    const btn = item.querySelector('.faq-q');
    if (!btn) return;
    btn.addEventListener('click', () => {
      const isOpen = item.classList.contains('open');
      document.querySelectorAll('.faq-item.open').forEach((o) => {
        o.classList.remove('open');
        o.querySelector('.faq-q')?.setAttribute('aria-expanded', 'false');
      });
      if (!isOpen) {
        item.classList.add('open');
        btn.setAttribute('aria-expanded', 'true');
      }
    });
  });
</script>
```

- [ ] **Step 2: Verificar en dev** — acordeón abre/cierra con animación suave; solo un ítem abierto a la vez; íconos `+` rotan a `×`.

- [ ] **Step 3: Commit**

```bash
git add src/components/FAQ.astro src/pages/index.astro
git commit -m "feat: FAQ acordeon minimalista con filetes"
```

---

### Task 11: FinalCTA + Footer

**Files:**
- Modify: `src/components/FinalCTA.astro` (reescritura)
- Modify: `src/components/Footer.astro` (reescritura)

- [ ] **Step 1: Reescribir `src/components/FinalCTA.astro`**:

```astro
---
const WA_LINK = 'https://wa.me/5498944628576?text=Hola%2C%20quiero%20una%20demostraci%C3%B3n%20del%20asistente%20de%20VantAr';
---
<section id="contacto" class="section" style="padding-top:130px;padding-bottom:130px;position:relative;overflow:hidden;background:linear-gradient(170deg,var(--bg) 0%,var(--navy-elevated) 120%);border-top:1px solid var(--line-strong);">
  <div class="container" style="max-width:760px;text-align:center;position:relative;">
    <div class="reveal-line" style="width:56px;height:1px;background:var(--bronze);margin:0 auto 36px;"></div>

    <h2 class="h-display reveal" style="font-size:clamp(2.1rem,4.5vw,3.4rem);">
      ¿Tu estudio está perdiendo<br /><em>consultas esta noche?</em>
    </h2>

    <p class="reveal d1" style="font-family:var(--font-body);font-size:1.05rem;font-weight:300;color:var(--cream-60);line-height:1.75;margin:24px 0 44px;">
      Solicitá una demostración y vení a verlo funcionando.
    </p>

    <a href={WA_LINK} target="_blank" rel="noopener noreferrer" class="btn-bronze reveal d2" style="font-size:16px;padding:19px 38px;">
      <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20"><path d="M20.463 3.488C18.217 1.24 15.231 0 12.05 0 5.495 0 .16 5.335.157 11.892c-.001 2.096.547 4.142 1.588 5.946L.057 24l6.304-1.654c1.737.947 3.693 1.446 5.683 1.447h.005c6.554 0 11.89-5.335 11.893-11.893.002-3.18-1.235-6.165-3.479-8.412zm-8.413 18.303h-.004c-1.774-.001-3.513-.477-5.031-1.378l-.36-.214-3.742.981.998-3.648-.235-.374a9.786 9.786 0 01-1.511-5.261c.003-5.45 4.437-9.884 9.889-9.884 2.64.001 5.122 1.03 6.988 2.898 1.866 1.869 2.893 4.352 2.892 6.993-.003 5.45-4.437 9.887-9.884 9.887zm5.42-7.403c-.297-.149-1.758-.867-2.031-.967-.272-.099-.47-.148-.67.15-.198.298-.767.967-.94 1.164-.173.199-.347.223-.644.074-.297-.148-1.255-.462-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.019-.458.13-.606.134-.133.297-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.372-.025-.521-.075-.148-.669-1.611-.916-2.206-.242-.579-.487-.501-.669-.51l-.57-.01c-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.199 2.095 3.2 5.076 4.488.709.306 1.263.489 1.694.626.712.226 1.36.194 1.872.118.571-.085 1.758-.719 2.006-1.413.248-.695.248-1.29.173-1.414-.074-.124-.272-.198-.57-.347z"/></svg>
      Escribinos por WhatsApp
    </a>
  </div>
</section>
```

- [ ] **Step 2: Reescribir `src/components/Footer.astro`**:

```astro
---
import Logo from './Logo.astro';
const WA_LINK = 'https://wa.me/5498944628576?text=Hola%2C%20quiero%20saber%20m%C3%A1s%20sobre%20VantAr';
const year = new Date().getFullYear();
const LINKS = [
  { href: '#el-problema', label: 'El problema' },
  { href: '#la-solucion', label: 'La solución' },
  { href: '#servicios',   label: 'Servicios' },
  { href: '#resultados',  label: 'Resultados' },
  { href: '#faq',         label: 'FAQ' },
];
---
<footer style="background:var(--bg-alt);padding:64px 32px 40px;border-top:1px solid var(--line);">
  <div class="container">
    <div style="display:flex;flex-wrap:wrap;gap:48px;justify-content:space-between;align-items:flex-start;margin-bottom:52px;">
      <div style="max-width:300px;">
        <a href="#" style="text-decoration:none;display:inline-block;margin-bottom:18px;">
          <Logo size={28} />
        </a>
        <p style="font-family:var(--font-body);font-size:0.85rem;font-weight:300;color:var(--cream-40);line-height:1.75;margin:0;">
          Automatización e inteligencia artificial para estudios jurídicos y abogados.
        </p>
      </div>

      <nav style="display:flex;flex-direction:column;gap:14px;">
        {LINKS.map(l => (
          <a href={l.href} class="nav-anchor" style="font-size:13px;">{l.label}</a>
        ))}
      </nav>

      <div style="display:flex;flex-direction:column;gap:14px;align-items:flex-start;">
        <a href="mailto:vantarsoluciones@gmail.com" class="nav-anchor" style="font-size:13px;">vantarsoluciones@gmail.com</a>
        <a href={WA_LINK} target="_blank" rel="noopener noreferrer" class="btn-outline">Escribinos</a>
      </div>
    </div>

    <div style="border-top:1px solid rgba(239,234,224,0.07);padding-top:28px;display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:8px;">
      <span style="font-family:var(--font-body);font-size:12px;color:rgba(239,234,224,0.3);">© {year} VantAr Soluciones. Todos los derechos reservados.</span>
      <span style="font-family:var(--font-display);font-style:italic;font-size:12px;color:rgba(154,124,74,0.6);">Inteligencia artificial para estudios jurídicos</span>
    </div>
  </div>
</footer>
```

- [ ] **Step 3: Verificar en dev** y **Commit**

```bash
git add src/components/FinalCTA.astro src/components/Footer.astro
git commit -m "feat: CTA final y footer editorial"
```

---

### Task 12: Wiring final — index.astro + verificación integral

**Files:**
- Modify: `src/pages/index.astro` (reescritura)

- [ ] **Step 1: Reescribir `src/pages/index.astro`**:

```astro
---
import Layout from '../layouts/Layout.astro';
import Navbar from '../components/Navbar.astro';
import Hero from '../components/Hero.astro';
import Problem from '../components/Problem.astro';
import FlowDiagram from '../components/FlowDiagram.astro';
import Features from '../components/Features.astro';
import Services from '../components/Services.astro';
import Results from '../components/Results.astro';
import Process from '../components/Process.astro';
import FAQ from '../components/FAQ.astro';
import FinalCTA from '../components/FinalCTA.astro';
import Footer from '../components/Footer.astro';
---
<Layout>
  <Navbar />
  <Hero />
  <Problem />
  <FlowDiagram />
  <Features />
  <Services />
  <Results />
  <Process />
  <FAQ />
  <FinalCTA />
  <Footer />
</Layout>
```

- [ ] **Step 2: Verificación integral en dev** — checklist:
  - Scroll completo: reveals escalonados en cada sección, filetes que se dibujan, count-up en Resultados, timeline que se enciende.
  - Chat WA: arranca al entrar en viewport, tildes progresivas, audio reproduciéndose, imagen subiendo, fade de reinicio.
  - Anclas del navbar: `#el-problema`, `#la-solucion`, `#servicios`, `#resultados`, `#faq`, `#contacto` — todas scrollean a la sección correcta.
  - Responsive 390px (DevTools): columnas apiladas, teléfono centrado, timeline vertical, nav-links ocultos, CTA del navbar visible.
  - `prefers-reduced-motion` (DevTools → Rendering → emulate): contenido visible sin animaciones, sin secciones en opacity:0.
  - Cero restos cyan: buscar `#00B4CC|#0FCFE8|teal` en `src/` → solo puede aparecer dentro del teléfono si algún elemento de WhatsApp lo requiere (no debería).

Run: `grep -rn "00B4CC\|0097AD\|0FCFE8\|4DD9ED\|Outfit" src/`
Expected: sin resultados.

- [ ] **Step 3: Build final**

Run: `npm run build`
Expected: OK, dist/ generado.

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: rework editorial completo - wiring final de secciones"
```

---

### Task 13: Verificación visual final + screenshots

- [ ] **Step 1: Servir el build** — `npm run preview` (sirve dist/ en http://localhost:4321).

- [ ] **Step 2: Capturar screenshots con Playwright MCP** (desktop 1440px y mobile 390px, full-page) y revisarlos contra los criterios de éxito del spec:
  1. No parece template SaaS (sin cards con iconitos, sin glow, sin cyan).
  2. Lee "caro": serif protagonista, bronce moderado, aire generoso.
  3. Chat WA verosímil.
  4. Animaciones solo `transform`/`opacity`.
  5. Responsive completo.

- [ ] **Step 3: Ajustes finos** que surjan de la revisión visual (espaciados, tamaños, contrastes) — commitear como `fix: ajustes visuales post-revision`.

- [ ] **Step 4: Mostrar al usuario** en http://localhost:4321 para aprobación final. **No deployar a Cloudflare Pages sin OK explícito del usuario.**

---

## Notas para el ejecutor

- **Skill obligatoria:** invocar `/frontend-design` antes de cada task visual (regla de CLAUDE.md).
- **Convención del proyecto:** estilos inline + `@media` en `<style>` del componente o global.css. No introducir Tailwind ni CSS modules.
- **El guion del chat NO se toca** — solo la ejecución visual/temporal.
- **Commits frecuentes** — uno por task como mínimo, mensajes en español sin tildes (convención de los commits existentes).
- **No deployar** — el deploy a Cloudflare Pages lo decide el usuario después de aprobar.

