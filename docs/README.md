# Documentacion — Web AMPA Los Lirios

Web de la Asociacion de Madres y Padres de Alumnos del colegio Los Lirios. Permite a la junta directiva gestionar fiestas, fotos, comercios colaboradores y una busqueda del tesoro para los ninos, todo desde el movil y sin conocimientos tecnicos.

---

## Indice de secciones

| # | Seccion | Descripcion |
|---|---------|-------------|
| 1 | [Guia para la junta](./01-guia-junta.md) | Manual de uso del panel de administracion (no tecnico) |
| 2 | [Arquitectura tecnica](./02-arquitectura.md) | Stack, estructura de carpetas, flujo de datos y renderizado |
| 3 | [Base de datos](./03-base-datos.md) | Tablas de Supabase, RLS, storage buckets y migraciones |
| 4 | [Autenticacion](./04-autenticacion.md) | Login por magic link, sesiones, cookies y proteccion de rutas |
| 5 | [Paginas y componentes](./05-paginas-componentes.md) | Referencia de cada pagina publica, admin y componente reutilizable |
| 6 | [Estilos y animaciones](./06-estilos-animaciones.md) | Paleta de colores, tipografia, clases CSS propias y animaciones |
| 7 | [Busqueda del tesoro](./07-busqueda-tesoro.md) | Sistema de cromos ocultos (Easter Eggs) y su gestion desde el admin |
| 8 | [Despliegue](./08-despliegue.md) | Configuracion de Cloudflare Pages, variables de entorno y CI/CD |

---

## Resumen rapido del stack

- **Framework:** Astro 5 con SSR (`output: 'server'`)
- **Estilos:** Tailwind CSS 3 con paleta personalizada (verde/malva)
- **Datos:** Supabase (Postgres + Auth + Storage)
- **Deploy:** Cloudflare Pages con adaptador `@astrojs/cloudflare`
- **Lenguaje:** TypeScript (modo estricto)

## Estructura de carpetas

```
Ampa-Los-Lirios/
├── docs/                     # Esta documentacion
├── public/
│   └── favicon.svg           # Icono de la web
├── src/
│   ├── components/           # Componentes Astro reutilizables
│   │   ├── EasterEggs.astro  # Sistema de busqueda del tesoro
│   │   ├── EventCard.astro   # Tarjeta de evento
│   │   ├── Footer.astro      # Pie de pagina
│   │   ├── Header.astro      # Cabecera fija con nav
│   │   ├── PartnerCard.astro # Tarjeta de colaborador
│   │   └── PhotoGrid.astro   # Cuadricula de fotos con lightbox
│   ├── layouts/
│   │   ├── Admin.astro       # Layout del panel de admin
│   │   └── Base.astro        # Layout principal publico
│   ├── lib/
│   │   ├── auth.ts           # Funciones de autenticacion
│   │   ├── images.ts         # Procesamiento de imagenes (cliente)
│   │   └── supabase.ts       # Clientes de Supabase
│   ├── pages/
│   │   ├── admin/            # Panel de administracion
│   │   │   ├── index.astro   # Dashboard
│   │   │   ├── login.astro   # Pagina de login
│   │   │   ├── fiestas.astro # CRUD de eventos
│   │   │   ├── galeria.astro # CRUD de albumes y fotos
│   │   │   ├── colaboradores.astro # CRUD de colaboradores
│   │   │   └── cromos.astro  # Gestion de cromos
│   │   ├── api/auth/         # Endpoints de autenticacion
│   │   │   ├── login.ts      # POST: enviar magic link
│   │   │   ├── callback.ts   # GET: intercambiar codigo por sesion
│   │   │   └── logout.ts     # POST: cerrar sesion
│   │   ├── index.astro       # Pagina de inicio
│   │   ├── fiestas.astro     # Listado de eventos
│   │   ├── galeria.astro     # Galeria de fotos
│   │   ├── colaboradores.astro # Comercios colaboradores
│   │   ├── contacto.astro    # Informacion de contacto
│   │   └── privacidad.astro  # Aviso legal y privacidad
│   └── styles/
│       └── global.css        # Estilos globales y animaciones
├── supabase/migrations/
│   ├── 001_initial_schema.sql # Esquema inicial
│   └── 002_cromos.sql         # Tabla de cromos
├── astro.config.mjs
├── tailwind.config.mjs
├── tsconfig.json
├── package.json
└── .env.example
```
