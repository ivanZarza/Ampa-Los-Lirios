# Paginas y componentes

Referencia de cada pagina y componente del proyecto.

---

## Paginas publicas

### `/` — Inicio (`index.astro`)

Pagina principal con:
- **Hero**: fondo con gradiente animado, blobs decorativos flotantes, boton CTA.
- **Stats**: tarjeta con contadores (eventos, albumes, colaboradores) — datos reales de Supabase.
- **Proximo evento**: tarjeta destacada del evento mas cercano.
- **Que hacemos**: 3 tarjetas (fiestas, colaboradores, representacion).
- **CTA**: bloque verde para hacerse socio.
- **Marquee de colaboradores**: logos animados en desplazamiento continuo.

Datos: consulta eventos publicados, colaboradores activos y conteos.

### `/fiestas` — Fiestas y eventos (`fiestas.astro`)

- Cabecera con gradiente verde-malva.
- **Proximos eventos**: listado de eventos futuros ordenados por fecha.
- **Eventos pasados**: los ultimos 20 eventos pasados, con opacidad reducida.
- Usa el componente `EventCard`.

Datos: dos consultas a `eventos` (futuros y pasados), filtradas por `publicado = true`.

### `/galeria` — Galeria de fotos (`galeria.astro`)

- Cabecera con gradiente malva-verde.
- Albumes ordenados por fecha descendente.
- Cada album muestra titulo, fecha y cuadricula de fotos (`PhotoGrid`).
- **Lightbox**: al pulsar una foto se abre a pantalla completa con fondo oscuro.
- Cerrar con X, clic fuera o tecla Escape.

Datos: consulta `albumes` con relacion `fotos`, filtrado por `publicado = true`.

### `/colaboradores` — Comercios colaboradores (`colaboradores.astro`)

- Cabecera con gradiente.
- Cuadricula de 3 columnas con tarjetas de colaboradores (`PartnerCard`).
- **CTA malva**: invitacion a comercios a colaborar.
- Si no hay colaboradores, muestra mensaje placeholder.

Datos: consulta `colaboradores` con `activo = true`.

### `/contacto` — Contacto (`contacto.astro`)

**Prerenderizada** (`export const prerender = true`).

Tres tarjetas:
1. Correo electronico (`ampaloslirios@gmail.com`) con enlace mailto.
2. Como hacerse socio, con enlace a `/colaboradores`.
3. Horario de atencion.

Sin datos dinamicos.

### `/privacidad` — Aviso legal (`privacidad.astro`)

**Prerenderizada.**

Textos legales sobre RGPD, cookies, imagenes de menores, derechos, etc. Es un borrador que debe revisarse con asesoramiento legal.

---

## Paginas admin

Todas protegidas con `requireAdmin()`. Usan el layout `Admin.astro`.

### `/admin` — Dashboard (`admin/index.astro`)

Cuatro tarjetas-enlace: Fiestas, Galeria, Colaboradores, Busqueda del tesoro.

### `/admin/login` — Login (`admin/login.astro`)

Formulario independiente (sin layout Admin). Campo de email + boton. Mensajes de error/exito via query params.

### `/admin/fiestas` — CRUD de eventos (`admin/fiestas.astro`)

- Lista de eventos (todos, incluyendo borradores).
- Formulario de creacion/edicion con campos: titulo, descripcion, fechas, lugar, publicado.
- Borrado con confirmacion.
- Procesamiento POST en el frontmatter.

### `/admin/galeria` — CRUD de albumes y fotos (`admin/galeria.astro`)

- Lista de albumes con contador de fotos.
- Crear album: titulo, fecha, publicado.
- Vista detallada de un album: editar datos, subir fotos, ver/borrar fotos.
- **Subida de fotos con JavaScript**: procesamiento en cliente (resize a 1600px, conversion WebP), subida directa al bucket `fotos` via API REST de Supabase, insert en tabla `fotos`, barra de progreso.

### `/admin/colaboradores` — CRUD de colaboradores (`admin/colaboradores.astro`)

- Lista con logo, nombre, estado (activo/oculto/destacado).
- Formulario: nombre, logo (subida), descripcion, ventaja, URL, orden, activo, destacado.
- Ocultar (soft delete con `activo = false`) y reactivar.

### `/admin/cromos` — Gestion de cromos (`admin/cromos.astro`)

- Cuadricula de 10 cromos con imagen actual, nombre, rareza e info del secreto.
- Formulario de edicion: nombre, descripcion, imagen (subida al bucket `cromos`), color.
- Info al admin sobre como funciona cada secreto.
- Los 10 slots son fijos (no se pueden crear ni borrar, solo editar).

---

## Componentes

### `Header.astro`

Cabecera fija (`position: fixed`) con:
- Logo (emoji 🌿 + texto "AMPA Los Lirios").
- **Desktop**: navegacion horizontal con items pill (fondo verde para la pagina activa).
- **Mobile**: boton hamburger que se transforma en X con CSS transitions. Menu desplegable con `max-height` animado.
- Efecto scroll: al bajar, la cabecera gana `backdrop-blur` y sombra.

Links: Inicio, Fiestas, Galeria, Colaboradores, Contacto.

### `Footer.astro`

Pie de pagina oscuro (`bg-gray-900`) con:
- Onda SVG decorativa en la parte superior.
- 3 columnas: logo+descripcion, enlaces, contacto.
- Copyright dinamico (ano actual) y enlace a Privacidad.

### `EventCard.astro`

Tarjeta de evento con:
- Badge de fecha (dia + mes abreviado) con fondo verde.
- Titulo, fecha completa, hora, lugar (con icono de pin).
- Descripcion (truncada a 3 lineas).
- Prop `destacado`: anillo verde y sombra extra.

Props: `titulo`, `descripcion`, `fecha_inicio`, `fecha_fin`, `lugar`, `destacado`.

### `PartnerCard.astro`

Tarjeta de colaborador con:
- Logo (imagen o emoji placeholder).
- Nombre, descripcion.
- Badge de ventaja para socios (gradiente malva-verde).
- Boton "Visitar web" con enlace externo.

Props: `nombre`, `logo_url`, `descripcion_corta`, `ventaja_socios`, `web_url`.

### `PhotoGrid.astro`

Cuadricula de fotos responsive (2/3/4 columnas):
- Cada foto es un boton `.lightbox-trigger` con `data-src` y `data-alt`.
- Hover: zoom de la imagen, overlay oscuro con icono de lupa, pie de foto.
- Animacion stagger al aparecer.

Props: `fotos` (array), `bucketUrl`.

### `EasterEggs.astro`

Sistema completo de busqueda del tesoro. Ver [documentacion detallada](./07-busqueda-tesoro.md).
