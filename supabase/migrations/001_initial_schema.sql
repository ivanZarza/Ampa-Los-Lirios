-- ============================================================
-- AMPA Los Lirios — esquema inicial
-- Ejecutar en Supabase SQL Editor con permisos de admin.
-- ============================================================

-- Extensión para generar UUIDs
create extension if not exists "pgcrypto";

-- ============================================================
-- TABLA: admins
-- ============================================================
create table public.admins (
  email text primary key
);

alter table public.admins enable row level security;

-- Solo lectura desde el servidor (service_role)
create policy "admins_no_public_read"
  on public.admins for select
  to anon, authenticated
  using (false);

-- ============================================================
-- TABLA: eventos
-- ============================================================
create table public.eventos (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  descripcion text,
  fecha_inicio timestamptz not null,
  fecha_fin timestamptz,
  lugar text,
  publicado boolean not null default true,
  creado_en timestamptz not null default now()
);

alter table public.eventos enable row level security;

-- Lectura pública: solo eventos publicados
create policy "eventos_public_read"
  on public.eventos for select
  to anon, authenticated
  using (publicado = true);

-- Escritura: solo admins autenticados
create policy "eventos_admin_insert"
  on public.eventos for insert
  to authenticated
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "eventos_admin_update"
  on public.eventos for update
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  )
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "eventos_admin_delete"
  on public.eventos for delete
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

-- ============================================================
-- TABLA: albumes
-- ============================================================
create table public.albumes (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  fecha date,
  evento_id uuid references public.eventos(id) on delete set null,
  publicado boolean not null default true
);

alter table public.albumes enable row level security;

create policy "albumes_public_read"
  on public.albumes for select
  to anon, authenticated
  using (publicado = true);

create policy "albumes_admin_insert"
  on public.albumes for insert
  to authenticated
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "albumes_admin_update"
  on public.albumes for update
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  )
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "albumes_admin_delete"
  on public.albumes for delete
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

-- ============================================================
-- TABLA: fotos
-- ============================================================
create table public.fotos (
  id uuid primary key default gen_random_uuid(),
  album_id uuid not null references public.albumes(id) on delete cascade,
  ruta_storage text not null,
  pie text,
  orden int not null default 0
);

alter table public.fotos enable row level security;

-- Lectura pública de fotos de álbumes publicados
create policy "fotos_public_read"
  on public.fotos for select
  to anon, authenticated
  using (
    album_id in (select id from public.albumes where publicado = true)
  );

create policy "fotos_admin_insert"
  on public.fotos for insert
  to authenticated
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "fotos_admin_update"
  on public.fotos for update
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  )
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "fotos_admin_delete"
  on public.fotos for delete
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

-- ============================================================
-- TABLA: colaboradores
-- ============================================================
create table public.colaboradores (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  logo_ruta text,
  descripcion_corta text,
  ventaja_socios text,
  web_url text not null,
  destacado boolean not null default false,
  activo boolean not null default true,
  orden int not null default 0
);

alter table public.colaboradores enable row level security;

-- Lectura pública: solo activos
create policy "colaboradores_public_read"
  on public.colaboradores for select
  to anon, authenticated
  using (activo = true);

create policy "colaboradores_admin_insert"
  on public.colaboradores for insert
  to authenticated
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "colaboradores_admin_update"
  on public.colaboradores for update
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  )
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "colaboradores_admin_delete"
  on public.colaboradores for delete
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

-- ============================================================
-- STORAGE BUCKETS
-- ============================================================

-- Bucket para fotos de la galería (lectura pública)
insert into storage.buckets (id, name, public) values ('fotos', 'fotos', true);

-- Bucket para logos de colaboradores (lectura pública)
insert into storage.buckets (id, name, public) values ('logos', 'logos', true);

-- Políticas de Storage: lectura pública
create policy "fotos_bucket_public_read"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'fotos');

create policy "logos_bucket_public_read"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'logos');

-- Políticas de Storage: escritura solo admins
create policy "fotos_bucket_admin_write"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'fotos' and
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "fotos_bucket_admin_delete"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'fotos' and
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "logos_bucket_admin_write"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'logos' and
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "logos_bucket_admin_delete"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'logos' and
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

-- ============================================================
-- Añadir aquí los correos de los administradores:
-- ============================================================
-- insert into public.admins (email) values ('admin@ejemplo.com');
