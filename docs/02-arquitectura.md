# Arquitectura tecnica

---

## Stack tecnologico

| Capa | Tecnologia | Version | Funcion |
|------|-----------|---------|---------|
| Framework | [Astro](https://astro.build/) | 5.x | Generacion de paginas, SSR, routing |
| Estilos | [Tailwind CSS](https://tailwindcss.com/) | 3.4 | Utilidades CSS, paleta personalizada |
| Lenguaje | TypeScript | 5.9 | Tipado estatico |
| Base de datos | [Supabase](https://supabase.com/) | Postgres 15 | Datos, auth, storage |
| Deploy | [Cloudflare Pages](https://pages.cloudflare.com/) | - | Hosting con edge SSR |
| Adaptador | `@astrojs/cloudflare` | 12.x | Ejecutar Astro en workers de Cloudflare |

---

## Modo de renderizado

El proyecto usa **renderizado hibrido**:

```js
// astro.config.mjs
export default defineConfig({
  output: 'server',  // SSR por defecto
  adapter: cloudflare(),
});
```

- **SSR (Server-Side Rendering):** la mayoria de paginas se renderizan en el servidor en cada peticion. Esto permite mostrar datos actualizados de Supabase (eventos, fotos, colaboradores).
- **Prerender (estatico):** las paginas que no dependen de datos dinamicos se generan en build time:
  - `contacto.astro` → `export const prerender = true`
  - `privacidad.astro` → `export const prerender = true`

---

## Flujo de datos

```
Navegador  ←→  Cloudflare Pages (Worker)  ←→  Supabase
                       │
                 Astro SSR
                 (renderiza HTML)
                       │
              Componentes .astro
              (fetch en frontmatter)
```

1. El usuario solicita una pagina (ej: `/fiestas`).
2. Cloudflare ejecuta el worker de Astro.
3. El frontmatter del `.astro` hace `await supabase.from('eventos').select(...)`.
4. Astro genera el HTML completo y lo devuelve al navegador.
5. En el cliente, scripts ligeros manejan interactividad (hamburger menu, lightbox, Easter eggs).

---

## Clientes de Supabase

Definidos en `src/lib/supabase.ts`:

```typescript
// Cliente publico (clave anon) — para lecturas publicas y auth
export const supabase = createClient(url, anonKey);

// Cliente de servicio — para operaciones admin (bypass RLS)
export function getServiceClient() {
  return createClient(url, serviceRoleKey);
}
```

- **`supabase`** (anon): usado en paginas publicas para leer datos (eventos publicados, albumes, colaboradores activos). Las RLS policies de Supabase limitan lo que puede ver.
- **`getServiceClient()`**: usado solo en paginas `/admin/*` despues de validar que el usuario es admin. Tiene acceso total a todas las tablas.

---

## Layouts

### `Base.astro` — Layout publico

Envuelve todas las paginas visibles al usuario:

- `<head>`: meta tags, Google Fonts (Inter), favicon, ViewTransitions
- `<Header />`: cabecera fija con navegacion
- `<slot />`: contenido de cada pagina
- `<Footer />`: pie con enlaces y contacto
- `<EasterEggs />`: sistema de busqueda del tesoro
- Script de scroll-reveal: observa `.reveal`, `.reveal-left`, `.reveal-right`, `.reveal-scale`, `.stagger-children`
- Script de lazy images: gestiona la transicion de opacidad al cargar imagenes

### `Admin.astro` — Layout del panel

Envuelve las paginas `/admin/*`:

- `noindex, nofollow`: no aparece en buscadores
- Barra superior verde con enlace "Ver web" y "Salir"
- Sin animaciones de scroll-reveal
- Sin Easter eggs ni footer publico

---

## View Transitions

Astro incluye la API de View Transitions para navegacion suave entre paginas:

```astro
<ViewTransitions />
```

- Transiciones animadas al cambiar de pagina (sin recarga completa).
- Los scripts usan `document.addEventListener('astro:after-swap', ...)` para reinicializarse tras cada navegacion.
- El logo tiene `transition:name="logo"` para animar su posicion entre paginas.

---

## Scripts de cliente

Todo el JavaScript es vanilla (sin React, Vue ni otros frameworks):

| Script | Donde | Que hace |
|--------|-------|----------|
| Scroll reveal | `Base.astro` | IntersectionObserver para animar elementos al hacer scroll |
| Lazy images | `Base.astro` | Clase `.loaded` al completar carga de imagenes |
| Header | `Header.astro` | Backdrop blur al hacer scroll, hamburger animado |
| Lightbox | `galeria.astro` | Visor de fotos a pantalla completa |
| Easter eggs | `EasterEggs.astro` | Secretos ocultos y album de cromos |
| Upload fotos | `admin/galeria.astro` | Subida con procesamiento y barra de progreso |
