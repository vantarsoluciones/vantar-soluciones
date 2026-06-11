# Spec: Rework completo de vantarsoluciones.com.ar — "Despacho editorial"

**Fecha:** 2026-06-11
**Estado:** Aprobado por Franco (diseño validado por secciones en sesión de brainstorming)

## Objetivo

Rediseñar por completo la página de VantAr Soluciones. El sitio actual (navy + cyan, grids de cards, glow blobs) se percibe genérico y "hecho con IA". El nuevo diseño debe leer **caro, profesional y elegante** — el cliente es un abogado/estudio jurídico que paga USD 1.000/mes — sin perder el costado tecnológico. Única pieza protegida: la animación de conversación de WhatsApp (se conserva y se mejora).

## Decisiones de negocio (validadas con el usuario)

| Tema | Decisión |
|---|---|
| Oferta | Asistente Virtual = estrella. Publicidad (Google/Meta) = motor de captación, muy fuerte. Diseño web + marca personal del abogado = tercer servicio. |
| Precio | No se muestra. Todo CTA deriva a conversación por WhatsApp ("Solicitar demostración"). |
| Prueba social | Métricas reales extrapoladas de la campaña actual (4 casos cerrados con turno en 2 días → expresar por semana/mes) + retorno en plata/porcentaje. Un (1) testimonio inventado provisorio permitido, marcado en código con comentario `<!-- PROVISORIO: reemplazar con testimonio real -->`. Sin grid de 3 testimonios falsos. |
| Estructura | One-page completa (toda la historia del PDF en un scroll). |
| Animación WA | Un solo caso (accidente laboral, se mantiene el guion — incluye audio + imagen de forma natural), ejecución pulida al máximo. |

## Identidad visual (validada con mockups en visual companion)

**Concepto: "Despacho editorial"** — publicación jurídica de lujo. Tipografía serif protagonista, asimetría editorial, filetes finos de bronce como separadores (no cards), métricas gigantes, cero glow blobs / iconitos en cajas / cyan. El teléfono con el chat es el único objeto "vivo" de la página. Sin números romanos (el usuario los rechazó); el foliado de listas usa `a. b. c.` en itálica serif.

### Design tokens

```css
:root {
  --bg:            #080F1E;   /* fondo base */
  --bg-alt:        #060B17;   /* secciones intercaladas */
  --navy-elevated: #0D1830;   /* gradientes, superficies */
  --bronze:        #9A7C4A;   /* acento principal (elegido sobre champagne y latón) */
  --bronze-light:  #B59A5C;   /* hover, métricas destacadas */
  --cream:         #EFEAE0;   /* títulos, texto principal */
  --cream-60:      rgba(239,234,224,0.6);  /* texto secundario */
}
```

- **Tipografías:** Fraunces (variable 400–700 + itálicas; títulos, métricas, acentos en itálica) + Inter (300/400/500; cuerpo, labels, UI). Reemplazan a Outfit + Inter.
- **Labels de sección:** Inter 10–11px, versalitas, `letter-spacing: 0.28em`, bronce, con filete que se desvanece a la derecha (`::after` con gradiente).
- **Botones:** rectangulares, `border-radius: 2px`. Primario: fondo bronce, texto navy. Secundario: outline bronce.
- **Profundidad:** gradientes navy + filetes. Sin sombras de color ni glows.

### Logo rediseñado

- V con circuitos se mantiene (reconocible; también es avatar del chat) pero refinada: V en crema `#EFEAE0`, trazo más esbelto; circuitos en bronce con **3 nodos** (hoy 7).
- Wordmark "VantAr" en Fraunces semibold; "Ar" en bronce.
- Mismo SVG inline en: Navbar, Footer, avatar del chat WA. Favicon (`public/favicon.svg`) se regenera con colores nuevos.

## Estructura de la página (11 secciones, en orden)

1. **Navbar** — fija; transparente sobre hero → fondo navy + filete bronce inferior al scrollear. Logo + anclas (El problema / La solución / Servicios / Resultados / FAQ) + CTA outline "Solicitar demostración" (link wa.me).
2. **Hero** — asimétrico: eyebrow versalitas bronce → headline serif grande (concepto "Tu estudio, atendiendo mientras dormís." con acento en itálica bronce) a la izquierda; párrafo corto + CTA primario a la derecha/abajo. Banda de 3 métricas separadas por filetes verticales: `24/7` · `< 1 min` · `0 consultas sin responder`. Fondo: gradiente navy que respira lento + grano sutil. Sin grid cyan.
3. **El problema** — label "El problema", título "Lo que conocés de memoria." a la izquierda; lista foliada `a.–e.` a la derecha con los 5 dolores del PDF (consulta a las 2 AM, horas perdidas en consultas que no van a ningún lado, ida y vuelta de agenda + ausentes, llegar a la reunión sin contexto, leads que desaparecen). Cierre centrado en itálica: *"Cada una de esas situaciones es un cliente — y honorarios — que se escapan."*
4. **La demo** — label "La solución, en vivo", título "No te lo contamos. *Miralo atender.*" Copy + 3 bullets con filete (entrevista con criterio / transcribe audios y lee imágenes / agenda en Google Calendar) a la izquierda; iPhone con chat animado a la derecha. Sección con mínima decoración: el teléfono es protagonista.
5. **Qué hace** — las 9 funcionalidades del PDF en lista editorial de 2 columnas con numeración fina (01–09, Inter, no romanos): atención 24/7/365, entrevista legal inteligente, texto+audio+imágenes, agenda sola (Google Calendar), recordatorios, recupera conversaciones frías, informe del caso priorizado (Alta/Media/Baja) por mail y WA, memoria de cada cliente, asistente del propio abogado.
6. **Servicios** — "Un sistema completo de captación.": 3 columnas separadas por filetes verticales — *El asistente* (Asistente Virtual Inteligente, la estrella) / *El motor* (Publicidad en Google y Meta que trae casos) / *La presencia* (Diseño web y marca personal del abogado). Kicker en itálica bronce sobre cada título.
7. **Resultados** — métricas gigantes Fraunces en bronce con count-up: `+12` casos con turno agendado por semana de campaña · `×4` retorno sobre la inversión desde el primer mes; + 1 testimonio provisorio en itálica ("Con un solo caso cerrado, el sistema ya se pagó el mes."). Cifras derivadas de: 4 casos cerrados en 48hs de campaña real (extrapolación conservadora); marcar con comentario en código para actualizar con datos reales.
8. **Proceso** — "En marcha en pocos días.": timeline horizontal fino con 5 pasos del PDF (Relevamiento → Configuración a medida → Pruebas → Salida en vivo → Acompañamiento). Línea que se dibuja al scrollear, encendiendo cada paso. Cierre: *"Sin instalaciones complicadas de tu lado. Nos encargamos de todo."*
9. **FAQ** — 7 preguntas del PDF en acordeón minimalista (filetes horizontales, sin cajas; apertura animada con `grid-template-rows`): ¿reemplaza a mi secretaria?, ¿y si prefiere hablar con una persona?, ¿es confidencial?, ¿necesito saber de tecnología?, ¿se adapta a mi forma de trabajar?, ¿en qué horario atiende?, ¿qué pasa con una consulta compleja?
10. **CTA final** — "¿Tu estudio está perdiendo *consultas esta noche?*" + subtítulo "Solicitá una demostración y vení a verlo funcionando." + botón WhatsApp primario.
11. **Footer** — sobrio: logo, anclas, mail `vantarsoluciones@gmail.com`, copyright, tagline "Inteligencia artificial para estudios jurídicos".

**Tono del copy:** español argentino, voseo, directo y orientado a resultados (regla existente del proyecto). Fuente de contenido: PDF "Vantar_Asistente_Legal.pdf".

## Animaciones de página

Filosofía: movimiento escaso, lento, con propósito. Nada rebota ni brilla.

1. **Reveals al scroll** — fade + translateY ≈20px, 0.7s ease-out, vía un único `IntersectionObserver` en `Layout.astro` que activa clases `.reveal` (con variantes de delay para stagger título → filete → contenido).
2. **Filetes que se dibujan** — `scaleX` 0→1, `transform-origin: left`, al entrar al viewport. Firma visual de la página.
3. **Count-up de métricas** — números de Resultados y hero cuentan desde 0 (~1.2s ease-out, una sola vez), vanilla JS.
4. **Hero** — stagger por línea del headline al cargar; gradiente de fondo que respira (≥30s, casi imperceptible).
5. **Timeline del proceso** — línea horizontal se dibuja progresivamente con el scroll, encendiendo pasos.
6. **Micro-interacciones** — botones (0.25s), acordeón FAQ animado, navbar con transición al scroll.
7. **`prefers-reduced-motion: reduce`** — desactiva todo (se mantiene el bloque existente).

## Mejoras de la animación de WhatsApp

Guion del accidente laboral **se mantiene** (14 mensajes: incluye audio con transcripción + foto de informe médico que el agente lee y resume). Cambia la ejecución:

1. **Tildes progresivas** en mensajes del cliente: ✓ gris (enviado) → ✓✓ gris (entregado) → ✓✓ azul (leído), con delays naturales.
2. **Timing humano variable**: el agente "lee" antes de escribir (delay proporcional al mensaje recibido); jitter aleatorio en el tipeo del cliente; pausas más largas antes de mensajes complejos.
3. **Audio que se reproduce**: botón play, barras del waveform que se pintan progresivamente + contador 0:00→0:14; la transcripción aparece después, como procesada por el agente.
4. **Imagen que "sube"**: informe médico aparece borroso con spinner/porcentaje de subida, luego se revela nítido.
5. **Header dinámico**: "escribiendo…" (existente) + "grabando audio…" cuando el cliente prepara la nota de voz.
6. **Scroll suave** del chat (easing), no salto seco.
7. **Pausa fuera de viewport**: arranca al entrar el teléfono en pantalla, se pausa al salir (IntersectionObserver). El loop siempre se ve desde el principio.
8. **Cierre con peso**: pausa ~4s con la conversación completa + fade elegante para reiniciar.
9. **Detalles**: chip de fecha "hoy" al inicio, horas coherentes entre status bar y mensajes, avatar del agente con el logo nuevo en bronce.

El marco del iPhone (botones laterales, status bar, Dynamic Island, teclado virtual con teclas activas) se conserva tal cual; solo se re-brandea el interior (avatar/nombre).

## Arquitectura de código

- **Stack sin cambios:** Astro 5.x estático, estilos inline + `@media` queries, vanilla JS en `<script>` tags, CSS keyframes. Deploy a Cloudflare Pages (`--branch main`).
- **Componentes:**
  - Se reescriben: `Navbar`, `Hero`, `FlowDiagram` (la demo del teléfono), `Results`, `FinalCTA`, `Footer`, `Layout`, `global.css`.
  - Se renombra y reescribe: `Offering.astro` → `Services.astro`.
  - Se eliminan (contenido absorbido): `Benefits.astro` (→ Features) y `HowItWorks.astro` (→ Process).
  - Se crean: `Problem.astro`, `Features.astro` (9 funcionalidades), `Process.astro` (timeline), `FAQ.astro`.
  - Orden final en `index.astro`: Navbar → Hero → Problem → FlowDiagram → Features → Services → Results → Process → FAQ → FinalCTA → Footer.
- **`global.css`:** tokens en `:root`, import de Fraunces + Inter (Google Fonts), keyframes nuevos (reveal, draw-line, count, breathe, tildes, waveform-play, upload), clases compartidas `.reveal` / `.reveal-line` / `.label-sec` / botones.
- **`Layout.astro`:** script único de IntersectionObserver para reveals; meta title/description/OG actualizados al nuevo posicionamiento ("Asistente Virtual Inteligente para estudios jurídicos…").
- **Favicon:** regenerar `public/favicon.svg` con el logo nuevo.

## Qué NO cambia

- Stack, build, flujo de deploy y credenciales (CLAUDE.md).
- Número de WhatsApp `5498944628576` (provisorio, igual que hoy) y estructura de links `wa.me` con texto prellenado.
- Guion del chat (accidente laboral).
- `robots.txt`, dominio, DNS, sitemap enviado a Search Console.
- Anclas de navegación pueden renombrarse, pero los IDs de sección deben seguir funcionando para links externos si los hubiera (verificar: hoy solo `#como-funciona`, `#beneficios`, `#resultados`, `#contacto` — se mapean a los nuevos IDs).

## Criterios de éxito

1. La página no se parece a un template SaaS: sin grids de cards con iconitos, sin glow blobs, sin cyan.
2. Lee "cara": tipografía serif protagonista, bronce con moderación, espacios generosos.
3. El chat de WhatsApp es indistinguible de uno real a primera vista (tildes, timing, audio, imagen).
4. Todas las animaciones corren a 60fps en mobile (solo `transform`/`opacity`) y respetan `prefers-reduced-motion`.
5. Responsive completo ≤900px (teléfono centrado, columnas apiladas, timeline vertical).
6. `npm run build` sin errores; deploy a Cloudflare Pages funcional.
7. Lighthouse: sin regresión grave de performance pese a las fuentes nuevas (Fraunces variable + `font-display: swap`).
