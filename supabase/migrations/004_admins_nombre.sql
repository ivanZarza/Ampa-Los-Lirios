-- Añadir columnas nombre y created_at a la tabla admins
alter table public.admins
  add column if not exists nombre text default '',
  add column if not exists created_at timestamptz not null default now();
