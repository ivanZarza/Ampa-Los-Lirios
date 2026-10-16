# Base de datos

El proyecto usa Supabase como backend: Postgres para datos, Auth para autenticacion y Storage para archivos.

---

## Tablas

### `admins`

Correos autorizados para acceder al panel de administracion.

| Columna | Tipo | Notas |
|---------|------|-------|
| `email` | `text` | **PK**. Correo del admin |

**RLS:** lectura bloqueada para `anon` y `authenticated`. Solo accesible con `service_role`.

Para dar de alta un admin:
```sql
INSERT INTO public.admins (email) VALUES ('correo@ejemplo.com');
```

---

### `eventos`

Fiestas y actividades del AMPA.

| Columna | Tipo | Notas |
|---------|------|-------|
| `id` | `uuid` | PK, autogenerado |
| `titulo` | `text` | Obligatorio |
| `descripcion` | `text` | Opcional |
| `fecha_inicio` | `timestamptz` | Obligatorio |
| `fecha_fin` | `timestamptz` | Opcional |
| `lugar` | `text` | Opcional |
| `publicado` | `boolean` | Default `true` |
| `creado_en` | `timestamptz` | Default `now()` |

**RLS:**
- Lectura publica: solo eventos con `publicado = true`.
- Escritura (insert, update, delete): solo usuarios autenticados cuyo email este en `admins`.

---

### `albumes`

Albumes de fotos.

| Columna | Tipo | Notas |
|---------|------|-------|
| `id` | `uuid` | PK, autogenerado |
| `titulo` | `text` | Obligatorio |
| `fecha` | `date` | Opcional |
| `evento_id` | `uuid` | FK a `eventos`, `on delete set null` |
| `publicado` | `boolean` | Default `true` |

**RLS:** lectura publica solo si `publicado = true`. Escritura solo admins.

---

### `fotos`

Fotos dentro de un album.

| Columna | Tipo | Notas |
|---------|------|-------|
| `id` | `uuid` | PK, autogenerado |
| `album_id` | `uuid` | FK a `albumes`, `on delete cascade` |
| `ruta_storage` | `text` | Nombre del archivo en el bucket `fotos` |
| `pie` | `text` | Pie de foto opcional |
| `orden` | `int` | Orden dentro del album |

**RLS:** lectura publica solo si el album esta publicado. Escritura solo admins.

---

### `colaboradores`

Comercios y empresas colaboradoras.

| Columna | Tipo | Notas |
|---------|------|-------|
| `id` | `uuid` | PK, autogenerado |
| `nombre` | `text` | Obligatorio |
| `logo_ruta` | `text` | Nombre del archivo en bucket `logos` |
| `descripcion_corta` | `text` | Opcional |
| `ventaja_socios` | `text` | Ventaja para familias socias |
| `web_url` | `text` | Obligatorio, debe empezar por `https://` |
| `destacado` | `boolean` | Default `false`. Si true, aparece en portada |
| `activo` | `boolean` | Default `true`. Si false, no se muestra |
| `orden` | `int` | Orden en la lista |

**RLS:** lectura publica solo si `activo = true`. Escritura solo admins.

---

### `cromos`

Personajes para la busqueda del tesoro.

| Columna | Tipo | Notas |
|---------|------|-------|
| `slug` | `text` | **PK**. Identificador del secreto (ej: `logo7`, `konami`) |
| `nombre` | `text` | Nombre del personaje |
| `descripcion` | `text` | Descripcion corta |
| `imagen_ruta` | `text` | Nombre del archivo en bucket `cromos` |
| `color` | `text` | Color hex para confetis (ej: `#f59e0b`) |

**RLS:** lectura publica (sin restriccion). Solo update para admins (no insert ni delete: siempre son 10 filas fijas).

Se pre-siembra con 10 filas en la migracion `002_cromos.sql`.

---

## Storage buckets

Todos los buckets son **publicos para lectura** (las URLs son accesibles directamente).

| Bucket | Contenido | Escritura |
|--------|-----------|-----------|
| `fotos` | Fotos de la galeria (WebP) | Solo admins autenticados |
| `logos` | Logos de colaboradores | Solo admins autenticados |
| `cromos` | Imagenes de personajes | Solo admins autenticados |

Las URLs publicas siguen el patron:
```
{PUBLIC_SUPABASE_URL}/storage/v1/object/public/{bucket}/{archivo}
```

---

## Migraciones

Las migraciones estan en `supabase/migrations/` y se ejecutan manualmente en el SQL Editor de Supabase:

1. **`001_initial_schema.sql`**: crea todas las tablas, RLS policies y buckets iniciales (eventos, albumes, fotos, colaboradores, admins).
2. **`002_cromos.sql`**: crea la tabla `cromos`, bucket `cromos` y pre-siembra los 10 cromos.

### Como ejecutar

1. Abre tu proyecto en [supabase.com](https://supabase.com).
2. Ve a **SQL Editor**.
3. Pega el contenido de cada archivo `.sql` en orden.
4. Ejecuta.
5. Al final de `001_initial_schema.sql`, anade los correos de los admins:
   ```sql
   INSERT INTO public.admins (email) VALUES ('tu@correo.com');
   ```

---

## Row Level Security (RLS)

Todas las tablas tienen RLS habilitado. El patron general:

- **Lectura publica** (anon + authenticated): solo filas con `publicado = true` / `activo = true`.
- **Escritura admin**: solo usuarios autenticados cuyo `auth.jwt() ->> 'email'` este en la tabla `admins`.
- **`admins`** no tiene lectura publica: se consulta solo con `service_role` desde el servidor.

Esto significa que incluso si alguien obtuviese la clave `anon`, solo podria leer datos ya publicados.
