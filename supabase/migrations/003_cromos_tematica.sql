-- ============================================================
-- AMPA Los Lirios — Añadir temática/valor a los cromos
-- ============================================================

alter table public.cromos add column tematica text not null default '';

update public.cromos set tematica = 'La Amistad'              where slug = 'logo7';
update public.cromos set tematica = 'La Curiosidad'            where slug = 'ladybug';
update public.cromos set tematica = 'El Amor por la Naturaleza' where slug = 'lirios';
update public.cromos set tematica = 'La Perseverancia'         where slug = 'konami';
update public.cromos set tematica = 'La Comunidad'             where slug = 'comunidad';
update public.cromos set tematica = 'La Valentía'              where slug = 'nocturno';
update public.cromos set tematica = 'El Respeto'               where slug = 'privacidad';
update public.cromos set tematica = 'La Alegría'               where slug = 'estrella';
update public.cromos set tematica = 'La Creatividad'           where slug = 'camara';
update public.cromos set tematica = 'La Colección Completa'    where slug = 'coleccion';
