# Despliegue

Guia para poner la web en produccion con Cloudflare Pages y Supabase.

---

## Requisitos previos

1. Una cuenta en [Cloudflare](https://dash.cloudflare.com/) (gratis).
2. Un proyecto en [Supabase](https://supabase.com/) (gratis hasta cierto uso).
3. El repositorio subido a GitHub.

---

## 1. Configurar Supabase

### Crear el proyecto

1. Ve a [supabase.com](https://supabase.com) y crea un nuevo proyecto.
2. Elige una region cercana (ej: `West EU` para Espana).
3. Guarda la contrasena de la base de datos.

### Ejecutar las migraciones

1. Ve a **SQL Editor** en el panel de Supabase.
2. Pega el contenido de `supabase/migrations/001_initial_schema.sql` y ejecuta.
3. Pega el contenido de `supabase/migrations/002_cromos.sql` y ejecuta.
4. Pega el contenido de `supabase/migrations/003_cromos_tematica.sql` y ejecuta.
5. Anade el primer administrador:
   ```sql
   INSERT INTO public.admins (email) VALUES ('tu@correo.com');
   ```

### Obtener las claves

En **Settings → API** encontraras:

| Dato | Donde usarlo |
|------|-------------|
| **Project URL** | `PUBLIC_SUPABASE_URL` |
| **anon public key** | `PUBLIC_SUPABASE_ANON_KEY` |
| **service_role key** | `SUPABASE_SERVICE_ROLE_KEY` |

> **Importante**: la clave `service_role` da acceso total a la base de datos. No la expongas en el cliente ni la subas a Git.

### Configurar Auth

1. En **Authentication → URL Configuration**:
   - **Site URL**: `https://tu-dominio.es`
   - **Redirect URLs**: `https://tu-dominio.es/api/auth/callback`
2. En **Authentication → Email Templates** (opcional): personaliza el email del magic link.

---

## 2. Configurar Cloudflare Pages

### Conectar el repositorio

1. Ve a [Cloudflare Dashboard](https://dash.cloudflare.com/) → **Workers & Pages** → **Create**.
2. Selecciona **Pages** → **Connect to Git**.
3. Autoriza el acceso a tu repositorio de GitHub.
4. Selecciona el repositorio `ampa-los-lirios`.

### Configuracion del build

| Campo | Valor |
|-------|-------|
| Framework preset | Astro |
| Build command | `npm run build` |
| Build output directory | `dist` |
| Root directory | `/` |

### Variables de entorno

En **Settings → Environment Variables**, anade:

| Variable | Valor | Notas |
|----------|-------|-------|
| `PUBLIC_SUPABASE_URL` | `https://xxxxx.supabase.co` | URL de tu proyecto Supabase |
| `PUBLIC_SUPABASE_ANON_KEY` | `eyJ...` | Clave publica anon |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJ...` | Clave de servicio (marcar como **encrypted**) |
| `PUBLIC_SITE_URL` | `https://tu-dominio.es` | URL final de la web |
| `NODE_VERSION` | `20` | Version de Node.js |

> Las variables con prefijo `PUBLIC_` son accesibles en el cliente. Las demas solo estan disponibles en el servidor (SSR).

### Desplegar

1. Pulsa **Save and Deploy**.
2. Cloudflare hara el build y desplegara la web.
3. Obtendras una URL temporal tipo `ampa-los-lirios.pages.dev`.

---

## 3. Dominio personalizado

### Opcion A: dominio en Cloudflare

1. En **Pages → Custom domains** → **Set up a custom domain**.
2. Escribe tu dominio (ej: `ampaloslirios.es`).
3. Si el dominio esta en Cloudflare, los DNS se configuran automaticamente.

### Opcion B: dominio externo

1. Anade un registro `CNAME` en tu proveedor de DNS:
   ```
   CNAME  @  ampa-los-lirios.pages.dev
   ```
2. Cloudflare verificara el dominio y emitira un certificado SSL automaticamente.

### Actualizar URLs

Una vez tengas el dominio, actualiza:
- `PUBLIC_SITE_URL` en las variables de entorno de Cloudflare.
- **Site URL** y **Redirect URLs** en Supabase Auth.

---

## 4. Despliegue automatico (CI/CD)

Cloudflare Pages despliega automaticamente con cada push a la rama principal de GitHub:

```
git push → GitHub → Cloudflare Pages → Build → Deploy
```

- **Rama de produccion**: `main` (o la que configures).
- **Preview**: cada pull request genera un despliegue de preview con URL unica.
- **Tiempo de build**: ~1-2 minutos.

No necesitas configurar nada adicional: la integracion con GitHub lo hace todo.

---

## 5. Comandos locales

### Desarrollo

```bash
npm install         # Instalar dependencias
npm run dev         # Servidor de desarrollo (http://localhost:4321)
```

### Build de produccion

```bash
npm run build       # Genera la web en /dist
npm run preview     # Vista previa local del build
```

### Verificacion de tipos

```bash
npx astro check     # Comprobacion de tipos TypeScript
```

---

## Variables de entorno

Archivo de referencia: `.env.example`

```
PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...
PUBLIC_SITE_URL=https://ampaloslirios.es
GALERIA_PRIVADA=false
```

Para desarrollo local, copia `.env.example` a `.env` y rellena los valores.

| Variable | Descripcion |
|----------|-------------|
| `PUBLIC_SUPABASE_URL` | URL del proyecto Supabase |
| `PUBLIC_SUPABASE_ANON_KEY` | Clave publica para lecturas |
| `SUPABASE_SERVICE_ROLE_KEY` | Clave con acceso total (solo servidor) |
| `PUBLIC_SITE_URL` | URL de la web (para SEO y enlaces) |
| `GALERIA_PRIVADA` | Si es `true`, la galeria requiere login |

---

## Estructura del deploy

```
Cloudflare Pages (Worker)
├── SSR: paginas dinamicas renderizadas en el edge
│   ├── / (inicio)
│   ├── /fiestas
│   ├── /galeria
│   ├── /colaboradores
│   ├── /admin/*
│   └── /api/auth/*
└── Estatico: paginas pre-renderizadas
    ├── /contacto
    └── /privacidad

Supabase
├── Postgres: datos (eventos, albumes, fotos, etc.)
├── Auth: magic links para login de admins
└── Storage: fotos, logos, cromos (buckets publicos)
```

---

## Solucion de problemas

### Error "Missing environment variables"

Comprueba que todas las variables de entorno estan configuradas en Cloudflare Pages. Recuerda que los cambios en las variables requieren un nuevo despliegue.

### El magic link no funciona

1. Verifica que **Redirect URLs** en Supabase incluye tu dominio con `/api/auth/callback`.
2. Comprueba que **Site URL** coincide con tu dominio.
3. Revisa la bandeja de spam.

### Las fotos no se ven

1. Comprueba que el bucket `fotos` es publico en Supabase Storage.
2. Verifica que `PUBLIC_SUPABASE_URL` es correcta.

### Error 500 en paginas admin

Normalmente indica que `SUPABASE_SERVICE_ROLE_KEY` no esta configurada o es incorrecta. Esta variable solo esta disponible en el servidor (sin prefijo `PUBLIC_`).
