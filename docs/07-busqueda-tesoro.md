# Busqueda del tesoro (Easter eggs)

Sistema de gamificacion oculto en la web publica. Los visitantes (pensado para ninos) descubren secretos escondidos por las paginas y coleccionan cromos de personajes.

---

## Resumen

- **10 secretos** escondidos por la web, cada uno desbloquea un cromo.
- **Album de cromos** flotante para ver el progreso.
- **Animacion de celebracion** con confetis al encontrar uno nuevo.
- **Personajes personalizables** desde el panel de administracion.
- **Persistencia** en `localStorage` (sobrevive a recargas).
- **Compatible con View Transitions** (se reinicializa tras cada navegacion).

---

## Arquitectura

### Componente: `EasterEggs.astro`

Incluido en `Base.astro`, se carga en todas las paginas publicas.

#### Frontmatter (servidor)

1. Consulta la tabla `cromos` de Supabase.
2. Combina los datos de la BD (nombre, descripcion, imagen, color) con la configuracion fija del juego (slug, emoji, rareza, pista).
3. Serializa todo en un atributo `data-cromos` de un `<div>` oculto.

```typescript
const cromosData = HARDCODED.map(h => {
  const db = dbCromos.find(c => c.slug === h.slug);
  return {
    id: h.slug,
    emoji: h.emoji,
    name: db?.nombre || h.slug,
    desc: db?.descripcion || '',
    rarity: h.rarity,
    hint: h.hint,
    color: db?.color || '#4a8f4a',
    imageUrl: db?.imagen_ruta ? `${bucketUrl}/${db.imagen_ruta}` : null,
  };
});
```

#### Template (HTML)

- `#cromos-config`: div oculto con datos JSON para el script.
- `#secret-ladybug`: mariquita oculta (secreto 2), esquina inferior izquierda, opacidad 8%.
- `#secret-star`: estrella oculta (secreto 8), visible solo en `/fiestas`.
- `#album-btn`: boton flotante con badge de conteo.
- `#album-overlay`: overlay del album con grid de cromos.
- `#celebration`: overlay de celebracion al encontrar un cromo.
- `#particles`: contenedor de particulas y confetis.

#### Script (cliente)

Todo el JavaScript se ejecuta en el navegador. Funciones principales:

| Funcion | Responsabilidad |
|---------|-----------------|
| `loadCromos()` | Parsea el JSON del div oculto |
| `getFound()` / `saveFound()` | Lee/escribe en localStorage |
| `unlock(id)` | Marca un cromo como encontrado, lanza celebracion |
| `showCelebration(cromo)` | Muestra overlay con nombre, imagen y rareza |
| `spawnParticles(color)` | Crea 24 particulas + 40 confetis animados |
| `renderAlbum()` | Genera la cuadricula de cromos encontrados/por encontrar |
| `initEggs()` | Inicializa todos los listeners; se llama al cargar y tras `astro:after-swap` |

---

## Los 10 secretos

### 1. Logo x7 (`logo7`) — Comun

**Trigger**: pulsar cualquier enlace a `/` (el logo) 7 veces en menos de 2.5 segundos.

**Implementacion**: contador `logoTaps` con temporizador de 2500ms. Al llegar a 7, previene la navegacion y desbloquea.

### 2. Mariquita (`ladybug`) — Comun

**Trigger**: encontrar y pulsar 3 veces la mariquita oculta en la esquina inferior izquierda.

**Implementacion**: div fijo con emoji 🐞, opacidad 8% (30% en hover), 4x4 pixeles de area de clic.

### 3. Escribe "lirios" (`lirios`) — Raro

**Trigger**: escribir la palabra "lirios" con el teclado en cualquier pagina.

**Implementacion**: buffer de 30 caracteres que escucha `keypress`, busca la subcadena "lirios".

### 4. Codigo Konami (`konami`) — Legendario

**Trigger**: introducir la secuencia ↑↑↓↓←→←→BA.

**Implementacion**: array con la secuencia esperada, puntero que avanza con cada tecla correcta y se resetea si falla.

### 5. Doble clic en "comunidad" (`comunidad`) — Raro

**Trigger**: hacer doble clic sobre la palabra "comunidad" en la portada.

**Implementacion**: listener de `dblclick` global que comprueba `window.getSelection()`.

### 6. Visita nocturna (`nocturno`) — Epico

**Trigger**: visitar la web entre las 22:00 y las 6:00 (hora local del dispositivo).

**Implementacion**: comprueba `new Date().getHours()` al cargar. Se desbloquea automaticamente.

### 7. Final de Privacidad (`privacidad`) — Raro

**Trigger**: hacer scroll hasta el final de la pagina `/privacidad`.

**Implementacion**: listener de `scroll` que compara `innerHeight + scrollY` con `body.offsetHeight - 50`. Solo activo en `/privacidad`.

### 8. Estrella en Fiestas (`estrella`) — Epico

**Trigger**: encontrar y pulsar la estrella oculta en la pagina `/fiestas`.

**Implementacion**: div fijo con ⭐, opacidad 6%, solo visible en `/fiestas`. Tiene animacion `hint-pulse` que oscila entre 5% y 15% de opacidad.

### 9. Camara en Galeria (`camara`) — Raro

**Trigger**: pulsar el icono 📸 en la pagina `/galeria` 3 veces en 2 segundos.

**Implementacion**: busca elementos con `textContent === '📸'`, contador con temporizador de 2000ms.

### 10. Coleccion completa (`coleccion`) — Legendario

**Trigger**: encontrar los 9 cromos anteriores.

**Implementacion**: al llamar a `unlock()`, si `found.size === 9`, se desbloquea automaticamente con 3 segundos de retardo.

---

## Niveles de rareza

| Rareza | Color del badge | Apariencia |
|--------|-----------------|------------|
| Comun | Gris (`gray-100/600`) | Faciles de encontrar |
| Raro | Azul (`blue-100/700`) | Requieren una accion especifica |
| Epico | Morado (`purple-100/700`) | Mas dificiles o condicionales |
| Legendario | Ambar (`amber-100/700`) | Los mas dificiles o meta |

---

## Album de cromos

### Boton flotante

- Posicion: esquina inferior derecha.
- Inicialmente oculto (`opacity: 0; pointer-events: none`).
- Aparece al encontrar el primer cromo.
- Badge circular verde con el numero de cromos encontrados.

### Vista del album

- Overlay con fondo oscuro y `backdrop-blur`.
- Tarjeta blanca con scroll vertical.
- Grid de 2 columnas.
- **Cromo encontrado**: imagen/emoji, nombre, descripcion, badge de rareza.
- **Cromo no encontrado**: interrogante con opacidad reducida + pista.
- Al final, pista aleatoria de un cromo no encontrado.
- Se cierra con boton X, clic fuera o tecla Escape.

---

## Celebracion

Al desbloquear un cromo:

1. **Overlay de celebracion** (3.5 segundos):
   - Fondo semitransparente.
   - Tarjeta centrada con imagen/emoji del personaje.
   - Animacion `celeb-bounce` (escala 0.3 → 1.15 → 1).
   - Nombre, descripcion y badge de rareza.

2. **Particulas** (24 emojis + 40 confetis):
   - Emojis (✨⭐🌟💫🎉🎊) salen del centro en patron radial.
   - Confetis caen desde arriba con rotacion y colores del cromo.
   - Se eliminan del DOM tras 2-5 segundos.

---

## Personalizacion (admin)

Desde `/admin/cromos`, los administradores pueden:

1. **Cambiar el personaje**: subir una imagen PNG/WebP para sustituir el emoji por defecto.
2. **Nombre y descripcion**: cambiar los textos que se muestran al encontrarlo.
3. **Color de celebracion**: elegir el color hex de los confetis.

Los 10 slots son fijos — no se pueden crear ni eliminar secretos.

La imagen se sube al bucket `cromos` de Supabase y se guarda como `{slug}.{extension}`. Al subir una nueva imagen, se borra automaticamente la anterior.

---

## Almacenamiento

- **localStorage** clave `ampa-cromos`: array JSON de slugs encontrados.
- Se lee con `getFound()` y se escribe con `saveFound()`.
- Envuelto en try/catch para navegacion privada o cookies bloqueadas.
- El progreso es por dispositivo y navegador; no se sincroniza entre dispositivos.

---

## View Transitions

El sistema se reinicializa completamente en cada navegacion:

```javascript
document.addEventListener('astro:after-swap', initEggs);
```

`initEggs()` recarga los datos del div oculto, recupera el progreso de localStorage, actualiza el boton del album y vuelve a registrar los listeners de los secretos especificos de pagina.
