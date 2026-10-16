-- ============================================================
-- AMPA Los Lirios — Cromos (búsqueda del tesoro)
-- ============================================================

-- TABLA: cromos
create table public.cromos (
  slug text primary key,
  nombre text not null,
  descripcion text not null default '',
  imagen_ruta text,
  color text not null default '#4a8f4a'
);

alter table public.cromos enable row level security;

create policy "cromos_public_read"
  on public.cromos for select
  to anon, authenticated
  using (true);

create policy "cromos_admin_update"
  on public.cromos for update
  to authenticated
  using (auth.jwt() ->> 'email' in (select email from public.admins))
  with check (auth.jwt() ->> 'email' in (select email from public.admins));

-- STORAGE BUCKET
insert into storage.buckets (id, name, public) values ('cromos', 'cromos', true);

create policy "cromos_bucket_public_read"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'cromos');

create policy "cromos_bucket_admin_write"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'cromos' and
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "cromos_bucket_admin_update"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'cromos' and
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

create policy "cromos_bucket_admin_delete"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'cromos' and
    auth.jwt() ->> 'email' in (select email from public.admins)
  );

-- Valores por defecto (se pueden personalizar desde el admin)
insert into public.cromos (slug, nombre, descripcion, color) values
  ('logo7',      'Gatito curioso',      'Le encanta investigar',                  '#f59e0b'),
  ('ladybug',    'Mariquita viajera',   'Siempre está escondida en algún rincón', '#ef4444'),
  ('lirios',     'Hada de las flores',  'Aparece cuando dices la palabra mágica', '#ec4899'),
  ('konami',     'Dragón arcade',       'Solo los gamers lo conocen',             '#8b5cf6'),
  ('comunidad',  'Zorro lector',        'Lee cada palabra de la web',             '#f97316'),
  ('nocturno',   'Búho nocturno',       'Solo aparece cuando es de noche',        '#6366f1'),
  ('privacidad', 'Tortuga paciente',    'Premia a quien lee hasta el final',      '#14b8a6'),
  ('estrella',   'Estrella fugaz',      'Brilla donde menos lo esperas',          '#eab308'),
  ('camara',     'Mariposa fotógrafa',  'Le encantan las fotos',                  '#06b6d4'),
  ('coleccion',  'Unicornio arcoíris',  '¡Los has encontrado a todos!',           '#d946ef');
