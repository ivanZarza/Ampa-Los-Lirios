# Web del AMPA Los Lirios

Web para el AMPA del colegio Los Lirios. Permite a la junta gestionar fiestas, fotos y tiendas colaboradoras desde el móvil sin necesidad de conocimientos técnicos.

## Guía rápida para la junta

### Acceder al panel de administración

1. Ve a `tusitio.es/admin/login`
2. Escribe tu correo electrónico (debe estar autorizado).
3. Recibirás un enlace en tu correo. Púlsalo para entrar.
4. ¡Ya estás dentro! No hay contraseña, solo el enlace.

### Crear un evento o fiesta

1. En el panel, pulsa **Fiestas y eventos**.
2. Pulsa **+ Nuevo evento**.
3. Rellena el título, la fecha, la hora y el lugar.
4. Marca la casilla **Publicado** si quieres que se vea en la web.
5. Pulsa **Crear evento**. ¡Listo!

### Subir fotos a la galería

1. En el panel, pulsa **Galería de fotos**.
2. Si necesitas un álbum nuevo, pulsa **+ Nuevo álbum** y ponle nombre.
3. Pulsa **Gestionar** en el álbum al que quieras subir fotos.
4. Pulsa en la zona de subida o arrastra las fotos.
5. Puedes seleccionar varias fotos a la vez.
6. Las fotos se redimensionan automáticamente para que la web cargue rápido.
7. Espera a que la barra de progreso llegue al 100%.

### Añadir un comercio colaborador

1. En el panel, pulsa **Colaboradores**.
2. Pulsa **+ Nuevo colaborador**.
3. Rellena el nombre, sube el logo, escribe la descripción y la ventaja para socios.
4. La dirección web debe empezar por `https://`.
5. Marca **Destacado** si quieres que aparezca también en la página de inicio.
6. Pulsa **Añadir colaborador**.

### Ocultar o reactivar un colaborador

- Para ocultar una tienda sin borrarla, pulsa **Ocultar**.
- Para volver a mostrarla, pulsa **Reactivar**.

## Información técnica

### Stack

- **Frontend:** [Astro](https://astro.build/) + TypeScript + Tailwind CSS
- **Datos:** [Supabase](https://supabase.com/) (Postgres, Auth, Storage)
- **Despliegue:** [Cloudflare Pages](https://pages.cloudflare.com/)

### Variables de entorno

Copia `.env.example` a `.env` y rellena los valores:

| Variable | Descripción |
|---|---|
| `PUBLIC_SUPABASE_URL` | URL de tu proyecto Supabase |
| `PUBLIC_SUPABASE_ANON_KEY` | Clave pública (anon) de Supabase |
| `SUPABASE_SERVICE_ROLE_KEY` | Clave de servicio (solo servidor, nunca en cliente) |
| `PUBLIC_SITE_URL` | URL de la web (ej: `https://ampaloslirios.es`) |
| `GALERIA_PRIVADA` | `false` para galería pública |

### Base de datos

1. Crea un proyecto en [Supabase](https://supabase.com/).
2. Ve al **SQL Editor** y ejecuta el contenido de `supabase/migrations/001_initial_schema.sql`.
3. Añade los correos de los administradores al final del script o con:
   ```sql
   insert into public.admins (email) values ('correo@ejemplo.com');
   ```

### Desarrollo local

```bash
npm install
npm run dev
```

### Despliegue en Cloudflare Pages

1. Conecta este repositorio a Cloudflare Pages.
2. Configura el comando de build: `npm run build`.
3. Directorio de salida: `dist/`.
4. Añade las variables de entorno en el panel de Cloudflare.
5. Cada push a `main` publicará automáticamente.
