# Manual de marca — VantAr (rediseño de logo)

**Fecha:** 2026-06-11
**Estado:** Diseño aprobado por Franco (isotipo + wordmark validados en sesión de brainstorming visual).
**Manual visual:** `public/img/logo/manual-marca.png`

## Objetivo

Rediseñar el logo de VantAr. El logo anterior (V crema con 3 nodos de circuito bronce) se percibía simple y "tech de moda"; fallaba la prueba de silueta, la de una sola tinta y la reducción a 16 px. El nuevo logo debe transmitir **solidez institucional, confianza y atemporalidad**, con máxima contención (Rand / Vignelli), sin perder el ADN de la "V".

## Diagnóstico del logo anterior (puntos de falla)

- **Ruido visual:** los 3 nodos + líneas de circuito eran decorativos, no estructurales.
- **Silueta:** en sombra sólida los nodos desaparecen → quedaba una V genérica (lo distintivo se perdía).
- **Una sola tinta:** dependía de dos colores; en una tinta los circuitos leían como ruido.
- **16 px:** trazos finos y nodos se empastaban / desaparecían.
- **Pesos:** V maciza vs. circuitos finos → incoherencia dentro del isotipo.
- **Atemporalidad:** "nodos de circuito" es tendencia tech, no envejece bien.

## El isotipo

Una **V sólida geométrica** (sin nodo): dos brazos que descienden a un vértice plantado. La masa sólida comunica respaldo; los tops cortados rectos y el vértice afilado, precisión. Lo distintivo vive en la forma, no en el adorno.

### Construcción (grilla)

| Parámetro | Valor |
|---|---|
| Caja (ancho : alto) | 64 : 56 u ≈ 8:7 |
| Apertura de la V | 60° |
| Espesor de brazo (superior) | 18 u |
| Profundidad de muesca | 25 u |
| Eje | simetría exacta en x |
| Nodos de ancla | 6 (contorno mínimo) |

**Path SVG (viewBox `16 20 64 56`):**

```
M16 20 L48 76 L80 20 L62 20 L48 51 L34 20 Z
```

### Área de respeto y tamaño mínimo

- **Área de respeto:** ≥ X alrededor del logo, donde X = espesor de brazo. Ningún elemento la invade.
- **Tamaño mínimo del isotipo:** 16 px (favicon).

## Wordmark

**"VantAr"** en **Outfit 600**, con **"Ar" en bronce** (`#9A7C4A`); el resto en crema. Letter-spacing `-0.015em`. Outfit se usa **solo para el wordmark del logo** (el sitio mantiene Fraunces para títulos + Inter para cuerpo).

## Color

| Token | Hex | Uso |
|---|---|---|
| Navy base | `#080F1E` | fondo principal |
| Navy alterno | `#060B17` | secciones intercaladas |
| Navy elevado | `#0D1830` | superficies |
| Bronce | `#9A7C4A` | acento, "Ar" |
| Bronce claro | `#B59A5C` | hover, métricas |
| Crema | `#EFEAE0` | isotipo, texto |
| Tinta | `#000000` | versión 1 color |
| Blanco | `#FFFFFF` | negativo |

Dos colores institucionales + neutros. **Sin degradados, biseles ni sombras.**

## Composiciones

- **Horizontal:** isotipo + wordmark (uso principal: navbar, footer).
- **Apilada:** isotipo arriba, wordmark abajo (usos cuadrados).
- **Solo isotipo:** favicon, avatar del chat de WhatsApp, redes.

## Versiones / reversibilidad

- Sobre navy (crema) · sobre claro (navy) · una tinta (negro sobre blanco) · negativo (blanco).

## Usos incorrectos

No deformar/estirar · no recolorear fuera de paleta · no rotar · no usar sobre fondos ruidosos · sin sombras ni biseles · no usar solo en contorno.

## Archivos generados (`public/img/logo/`)

- `isotipo-navy.png` / `isotipo-transparente.png` / `isotipo-negro.png` / `isotipo-blanco.png` (1024²)
- `lockup-navy.png` / `lockup-light.png`
- `favicon.svg`
- `manual-marca.png` (este manual en imagen)

## Pendiente (implementación en el sitio)

Aplicar el nuevo logo en código (tarea separada, vía plan de implementación):

- `src/components/Logo.astro` — reemplazar el path de la V y los 3 nodos por el path sólido nuevo; cambiar el wordmark a Outfit 600 (importar Outfit en `global.css`).
- `public/favicon.svg` — regenerar con el isotipo nuevo.
- Avatar del agente en `FlowDiagram.astro` (chat WA) — usar el isotipo nuevo.
- Verificar tamaños en `Navbar.astro` y `Footer.astro`.
