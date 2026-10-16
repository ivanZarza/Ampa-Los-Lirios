# Estilos y animaciones

Guia de la paleta de colores, tipografia, clases CSS personalizadas y animaciones del proyecto.

---

## Paleta de colores

Los colores se definen en `tailwind.config.mjs` como escalas personalizadas:

### Verde (color principal)

| Token | Hex | Uso habitual |
|-------|-----|-------------|
| `verde-50` | `#f0f7f0` | Fondos claros, hover suave |
| `verde-100` | `#dceddc` | Bordes claros |
| `verde-200` | `#bcdcbc` | Sombras de boton, bordes |
| `verde-300` | `#8ec48e` | — |
| `verde-400` | `#5fa85f` | Focus rings |
| `verde-500` | `#4a8f4a` | **Botones primarios**, badges, CTA |
| `verde-600` | `#3a7a3a` | Hover de botones |
| `verde-700` | `#2d612d` | Textos sobre fondo claro |
| `verde-800` | `#264f26` | — |
| `verde-900` | `#1d3f1d` | — |

### Malva (color secundario)

| Token | Hex | Uso habitual |
|-------|-----|-------------|
| `malva-50` | `#f8f4fa` | Fondos claros |
| `malva-100` | `#f0e8f4` | — |
| `malva-200` | `#e0cfea` | — |
| `malva-300` | `#c9a9d6` | — |
| `malva-400` | `#b085be` | — |
| `malva-500` | `#9b72b0` | **Botones secundarios**, badges |
| `malva-600` | `#7d5692` | Hover |
| `malva-700` | `#664578` | — |
| `malva-800` | `#553b63` | — |
| `malva-900` | `#473253` | — |

### Otros colores

Se usan los grises de Tailwind por defecto (`gray-50` a `gray-900`) para textos, fondos y bordes neutros.

---

## Tipografia

- **Fuente**: [Inter](https://fonts.google.com/specimen/Inter), pesos 400–800.
- Cargada desde Google Fonts en `Base.astro`:
  ```html
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  ```
- Fallback: `system-ui, -apple-system, sans-serif`.
- Configurada en `tailwind.config.mjs` como `fontFamily.sans`.

### Jerarquia de textos

| Elemento | Clases Tailwind | Resultado |
|----------|-----------------|-----------|
| Titulo de seccion | `section-title` | 3xl (md:4xl), bold, gray-900 |
| Subtitulo | `section-subtitle` | lg, gray-500, mb-10 |
| Titulo de tarjeta | `text-xl font-bold` | — |
| Cuerpo | Default body | base, gray-800 |
| Etiquetas/badges | `text-xs font-bold` | — |

---

## Clases CSS personalizadas

Definidas en `src/styles/global.css` dentro de `@layer components`:

### Botones

| Clase | Descripcion |
|-------|-------------|
| `btn-primary` | Verde, blanco, bordes redondeados, sombra verde en hover, micro-elevacion |
| `btn-secondary` | Malva, mismo estilo que primary pero en morado |
| `btn-outline` | Borde verde, fondo transparente, hover verde-50 |
| `btn-danger` | Rojo, mas pequeno, para acciones destructivas |

Todos los botones incluyen `transition-all duration-300`, `hover:-translate-y-0.5` y focus rings accesibles.

### Tarjetas

| Clase | Descripcion |
|-------|-------------|
| `card` | Fondo blanco, bordes redondeados (2xl), sombra md, borde gris claro |
| `card-hover` | Anade hover: sombra xl, elevacion -1px, borde mas visible |

### Formularios

| Clase | Descripcion |
|-------|-------------|
| `input-field` | Input de ancho completo, bordes redondeados, focus ring verde |
| `label-field` | Etiqueta en negrita, gris-700, margen inferior |

---

## Animaciones

### Scroll reveal

Sistema basado en `IntersectionObserver` (configurado en `Base.astro`). Anade la clase `visible` cuando el elemento entra en el viewport (threshold 0.1).

| Clase | Efecto |
|-------|--------|
| `reveal` | Aparece desde abajo (translateY 30px) |
| `reveal-left` | Aparece desde la izquierda (translateX -40px) |
| `reveal-right` | Aparece desde la derecha (translateX 40px) |
| `reveal-scale` | Aparece con zoom (scale 0.9 → 1) |
| `stagger-children` | Los hijos aparecen con retardo escalonado (100ms entre cada uno, hasta 9 hijos) |

Todas usan `cubic-bezier(0.16, 1, 0.3, 1)` para un movimiento suave con rebote.

### Marquee (logos de colaboradores)

```css
@keyframes marquee {
  0% { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}
```

- Clase: `marquee-track`
- Duracion: 30 segundos, lineal, infinito.
- Se pausa al pasar el raton (`hover: animation-play-state: paused`).
- El contenido se duplica en el HTML para crear un bucle continuo.

### Gradiente animado (hero)

```css
@keyframes gradient-shift {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}
```

- Clase: `animated-gradient`
- Usa `background-size: 200% 200%` para que el gradiente se desplace.
- Duracion: 8 segundos.

### Elementos flotantes (blobs del hero)

```css
@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  33% { transform: translateY(-10px) rotate(2deg); }
  66% { transform: translateY(5px) rotate(-1deg); }
}
```

- Clases: `float-animation` (normal) y `float-animation-delayed` (empieza 2s despues).
- Los blobs usan `blob-shape` para bordes organicos irregulares.

### Pulse badge (proximo evento)

Anillo pulsante que se expande y desvanece, creando efecto de "en vivo".

### Lightbox

- Overlay fijo con `backdrop-filter: blur(8px)` y fondo negro al 90%.
- Transicion de opacidad y escala al abrir/cerrar.
- Imagen con `max-width: 90vw` y `max-height: 85vh`.

### Carga suave de imagenes

```css
img[loading="lazy"] {
  opacity: 0;
  transition: opacity 0.5s ease;
}
img[loading="lazy"].loaded {
  opacity: 1;
}
```

Un script en `Base.astro` observa las imagenes lazy y les anade la clase `loaded` al completar la carga.

---

## Responsive

El diseno es mobile-first con breakpoints de Tailwind:

| Breakpoint | Ancho | Uso |
|------------|-------|-----|
| Default | < 640px | Movil: 1 columna, menu hamburger |
| `sm` | >= 640px | — |
| `md` | >= 768px | Tablet: 2 columnas en grids |
| `lg` | >= 1024px | Desktop: 3+ columnas, nav horizontal |

### Patrones responsive habituales

- **Grid de fotos**: `grid-cols-2 sm:grid-cols-3 lg:grid-cols-4`
- **Grid de colaboradores**: `grid-cols-1 md:grid-cols-2 lg:grid-cols-3`
- **Titulo de seccion**: `text-3xl md:text-4xl`
- **Contenedor**: `max-w-7xl mx-auto px-4`
