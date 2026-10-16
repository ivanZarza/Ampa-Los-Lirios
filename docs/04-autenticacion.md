# Autenticacion

El sistema usa **magic links** de Supabase Auth: los administradores reciben un enlace por correo electronico para acceder, sin contrasena.

---

## Flujo completo

```
1. Usuario va a /admin/login
2. Escribe su correo y envia el formulario
3. POST /api/auth/login
   ├── Comprueba que el email esta en tabla `admins` (service_role)
   ├── Si no esta → redirige con error
   └── Si esta → supabase.auth.signInWithOtp({ email })
       └── Supabase envia un email con enlace
4. Usuario pulsa el enlace del correo
5. GET /api/auth/callback?code=...
   ├── supabase.auth.exchangeCodeForSession(code)
   ├── Guarda access_token y refresh_token en cookies httpOnly
   └── Redirige a /admin
6. Todas las paginas /admin/* comprueban cookies con requireAdmin()
```

---

## Archivos implicados

### `src/pages/admin/login.astro`

Pagina de login independiente (no usa el layout Admin). Muestra un formulario con campo de email y mensajes de error/exito via query params.

### `src/pages/api/auth/login.ts`

Endpoint POST que:
1. Recibe el email del formulario.
2. Consulta la tabla `admins` con `service_role` para verificar que el correo esta autorizado.
3. Si el correo no esta registrado, redirige con mensaje de error.
4. Si esta registrado, llama a `supabase.auth.signInWithOtp()` con `emailRedirectTo` apuntando a `/api/auth/callback`.

### `src/pages/api/auth/callback.ts`

Endpoint GET al que redirige el enlace del correo:
1. Recibe el parametro `code` de la URL.
2. Intercambia el codigo por una sesion con `supabase.auth.exchangeCodeForSession()`.
3. Guarda `access_token` y `refresh_token` en cookies httpOnly, secure, sameSite lax, maxAge 7 dias.
4. Redirige a `/admin`.

### `src/pages/api/auth/logout.ts`

Endpoint POST que borra las cookies de sesion y redirige a `/admin/login`.

### `src/lib/auth.ts`

Tres funciones:

```typescript
// Obtiene la sesion del usuario desde las cookies
getSession(cookies: AstroCookies): Promise<Session | null>

// Comprueba si un email esta en la tabla admins
isAdmin(email: string): Promise<boolean>

// Combinacion: obtiene sesion + verifica que es admin
requireAdmin(cookies: AstroCookies): Promise<Session | null>
```

`getSession` tambien refresca el token si ha cambiado (actualiza las cookies).

---

## Proteccion de rutas admin

Todas las paginas del panel (`/admin/*` excepto login) comienzan con:

```astro
---
const session = await requireAdmin(Astro.cookies);
if (!session) return Astro.redirect('/admin/login');
---
```

Si el usuario no tiene sesion valida o no es admin, se le redirige al login.

---

## Cookies

| Cookie | Contenido | Propiedades |
|--------|-----------|-------------|
| `sb-access-token` | JWT de Supabase | httpOnly, secure, sameSite=lax, maxAge=7d |
| `sb-refresh-token` | Token de refresco | httpOnly, secure, sameSite=lax, maxAge=7d |

Ambas cookies son:
- **httpOnly**: no accesibles desde JavaScript del cliente.
- **secure**: solo se envian por HTTPS.
- **sameSite=lax**: proteccion basica contra CSRF.

---

## Anadir o quitar administradores

Para dar acceso a un nuevo miembro de la junta:

```sql
INSERT INTO public.admins (email) VALUES ('nuevo@correo.com');
```

Para quitar acceso:

```sql
DELETE FROM public.admins WHERE email = 'viejo@correo.com';
```

Esto se hace en el SQL Editor de Supabase. No hay interfaz web para gestionar admins (por seguridad, solo alguien con acceso a Supabase puede hacerlo).
