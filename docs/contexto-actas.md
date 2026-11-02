# Contexto para nueva herramienta: Actas del AMPA Los Lirios

## Quien soy
Ivan, tesorero del AMPA Los Lirios (colegio CEIP Los Lirios). Construyo herramientas web para la asociacion. Las otras miembros de la junta son Sandra, Ana y Jessy.

## Proyecto existente
Ya tenemos una app de gestion de fondos desplegada y funcionando:
- **URL**: https://ampa-los-lirios.pages.dev/fondos/
- **Repo GitHub**: https://github.com/ivanZarza/Ampa-Los-Lirios
- **La app de fondos esta en**: `public/fondos/index.html` (rama `main`)

## Stack tecnico (usar el mismo)
- **Frontend**: Single HTML file, vanilla JavaScript, Tailwind CSS via CDN (3.4.17)
- **Backend**: Supabase (proyecto `jfeyforrbaxxmsgpvviu`, region eu-west-1)
  - Supabase URL: `https://jfeyforrbaxxmsgpvviu.supabase.co`
  - Anon key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmZXlmb3JyYmF4eG1zZ3B2dml1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTIxOTcwMjUsImV4cCI6MjEwNzc3MzAyNX0.dulwOTulQ9dJm7S_nThLF6y_MDnDUe0yX-VKCm-fbNA`
- **Deploy**: Cloudflare Pages (auto-deploy desde GitHub main)
- **PWA**: Service Worker para instalar en movil
- **Sync**: Supabase Realtime para sincronizar entre dispositivos
- **Offline**: localStorage como cache/fallback
- **Convencion DB**: snake_case en Supabase, camelCase en JS

## Lo que quiero construir: App de Actas

Una herramienta sencilla para hacer actas de las reuniones del AMPA, pensada para rellenar en el momento desde el movil durante la reunion.

### Funcionalidad deseada:
- **Nueva acta**: crear acta con fecha, hora, lugar, asistentes (seleccionar de la junta + invitados)
- **Orden del dia**: anadir puntos al orden del dia antes o durante la reunion
- **Toma de notas en vivo**: ir rellenando cada punto con las decisiones/acuerdos durante la reunion
- **Votaciones**: registrar si algo se voto y el resultado (a favor, en contra, abstenciones)
- **Tareas**: asignar tareas con responsable y fecha limite
- **Firmar**: que cada asistente pueda firmar (con el dedo en la pantalla)
- **Exportar**: generar PDF del acta terminada para enviar o archivar
- **Historico**: ver actas anteriores

### Requisitos tecnicos:
- Misma arquitectura que fondos: un solo HTML, Tailwind CDN, Supabase, PWA
- Debe ir en una URL separada (ej: `/actas/` o nueva Cloudflare Pages)
- Mobile-first (se usa principalmente en el movil durante reuniones)
- Sincronizacion en tiempo real (varias personas pueden ver/editar el acta a la vez)
- Funcionar offline (al menos para consultar actas anteriores)

### Perfiles/acceso:
- Mismos usuarios que la app de fondos (Sandra, Ana, Jessy, Ivan)
- Mismo sistema de PIN o compartir el acceso via Supabase

### Auditoria:
- TODO queda registrado: quien creo/edito/borro cada cosa, con fecha y hora exacta
- Igual que en la app de fondos, una tabla de auditoria que registre cada accion (crear acta, editar punto, anadir tarea, firmar, etc.) con el usuario, timestamp y los valores antes/despues
- Nadie puede modificar nada sin que quede rastro

### Tablas Supabase necesarias (sugerencia):
- `actas` — id, fecha, hora_inicio, hora_fin, lugar, estado (borrador/finalizada)
- `actas_asistentes` — acta_id, nombre, cargo, firma (base64 de la firma)
- `actas_puntos` — acta_id, orden, titulo, notas, tipo (informativo/decision/votacion)
- `actas_votaciones` — punto_id, a_favor, en_contra, abstenciones, resultado
- `actas_tareas` — acta_id, punto_id, descripcion, responsable, fecha_limite, completada

### Estilo visual:
- Coherente con la app de fondos (verde como color principal, bordes redondeados, mobile-first)
- Usar las mismas clases de Tailwind y el mismo patron de UI (toast, modales, barra de navegacion)
