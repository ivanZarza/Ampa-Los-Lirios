-- ============================================================
-- AMPA Los Lirios — Miembros y Actas
-- Ejecutar en Supabase SQL Editor con permisos de admin.
-- ============================================================

-- ============================================================
-- TABLA: miembros_ampa
-- Registro permanente de cada persona vinculada al AMPA.
-- ============================================================
create table public.miembros_ampa (
  id uuid primary key default gen_random_uuid(),
  nombre_completo text not null,
  dni text,
  telefono text,
  email text,
  fecha_alta date not null default current_date,
  fecha_baja date,
  activo boolean not null default true,
  notas text,
  created_at timestamptz not null default now()
);

alter table public.miembros_ampa enable row level security;

create policy "miembros_no_public_read"
  on public.miembros_ampa for select
  to anon
  using (false);

create policy "miembros_admin_read"
  on public.miembros_ampa for select
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "miembros_admin_insert"
  on public.miembros_ampa for insert
  to authenticated
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "miembros_admin_update"
  on public.miembros_ampa for update
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  )
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "miembros_admin_delete"
  on public.miembros_ampa for delete
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

-- ============================================================
-- TABLA: miembros_cargos
-- Historial de cargos de cada miembro con fechas.
-- ============================================================
create table public.miembros_cargos (
  id uuid primary key default gen_random_uuid(),
  miembro_id uuid not null references public.miembros_ampa(id) on delete cascade,
  cargo text not null,
  fecha_inicio date not null,
  fecha_fin date,
  created_at timestamptz not null default now()
);

alter table public.miembros_cargos enable row level security;

create policy "cargos_no_public_read"
  on public.miembros_cargos for select
  to anon
  using (false);

create policy "cargos_admin_read"
  on public.miembros_cargos for select
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "cargos_admin_insert"
  on public.miembros_cargos for insert
  to authenticated
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "cargos_admin_update"
  on public.miembros_cargos for update
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  )
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "cargos_admin_delete"
  on public.miembros_cargos for delete
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

-- ============================================================
-- TABLA: actas
-- Cada acta de reunión del AMPA.
-- ============================================================
create table public.actas (
  id uuid primary key default gen_random_uuid(),
  numero integer not null,
  tipo text not null default 'ordinaria',
  curso_escolar text not null,
  fecha date not null,
  hora_inicio time,
  hora_fin time,
  lugar text not null default 'Sala del AMPA',
  estado text not null default 'borrador',
  lectura_acta_anterior boolean not null default false,
  notas_brutas text,
  created_at timestamptz not null default now()
);

alter table public.actas enable row level security;

create policy "actas_no_public_read"
  on public.actas for select
  to anon
  using (false);

create policy "actas_admin_read"
  on public.actas for select
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "actas_admin_insert"
  on public.actas for insert
  to authenticated
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "actas_admin_update"
  on public.actas for update
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  )
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "actas_admin_delete"
  on public.actas for delete
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

-- Índice para ordenar y buscar rápido
create index actas_numero_idx on public.actas(numero);
create index actas_curso_idx on public.actas(curso_escolar);

-- ============================================================
-- TABLA: actas_asistentes
-- Snapshot de los asistentes a cada acta.
-- ============================================================
create table public.actas_asistentes (
  id uuid primary key default gen_random_uuid(),
  acta_id uuid not null references public.actas(id) on delete cascade,
  miembro_id uuid references public.miembros_ampa(id) on delete set null,
  nombre_snapshot text not null,
  dni_snapshot text,
  cargo_snapshot text,
  created_at timestamptz not null default now()
);

alter table public.actas_asistentes enable row level security;

create policy "actas_asist_no_public"
  on public.actas_asistentes for select
  to anon
  using (false);

create policy "actas_asist_admin_read"
  on public.actas_asistentes for select
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "actas_asist_admin_insert"
  on public.actas_asistentes for insert
  to authenticated
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "actas_asist_admin_update"
  on public.actas_asistentes for update
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  )
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "actas_asist_admin_delete"
  on public.actas_asistentes for delete
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

-- ============================================================
-- TABLA: actas_puntos
-- Puntos del orden del día de cada acta.
-- ============================================================
create table public.actas_puntos (
  id uuid primary key default gen_random_uuid(),
  acta_id uuid not null references public.actas(id) on delete cascade,
  orden integer not null,
  titulo text not null,
  desarrollo text,
  resultado_votacion text,
  created_at timestamptz not null default now()
);

alter table public.actas_puntos enable row level security;

create policy "actas_puntos_no_public"
  on public.actas_puntos for select
  to anon
  using (false);

create policy "actas_puntos_admin_read"
  on public.actas_puntos for select
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "actas_puntos_admin_insert"
  on public.actas_puntos for insert
  to authenticated
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "actas_puntos_admin_update"
  on public.actas_puntos for update
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  )
  with check (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "actas_puntos_admin_delete"
  on public.actas_puntos for delete
  to authenticated
  using (
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create index actas_puntos_acta_orden_idx on public.actas_puntos(acta_id, orden);
