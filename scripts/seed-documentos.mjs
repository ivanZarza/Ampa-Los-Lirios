/**
 * Script para subir todos los documentos del AMPA a Supabase Storage
 * y crear registros en la tabla `documentos`.
 *
 * Uso: node scripts/seed-documentos.mjs
 *
 * Requiere variables de entorno:
 *   PUBLIC_SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
 */

import ws from 'ws';
globalThis.WebSocket = ws;
import { createClient } from '@supabase/supabase-js';
import { readFileSync, statSync } from 'fs';
import { basename, extname } from 'path';
import { execSync } from 'child_process';

// Load .env manually (no dotenv dependency)
const envContent = readFileSync(new URL('../.env', import.meta.url), 'utf-8');
for (const line of envContent.split('\n')) {
  const m = line.match(/^([A-Z_]+)=(.+)$/);
  if (m) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '');
}

const url = process.env.PUBLIC_SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
if (!url || !key) {
  console.error('Faltan PUBLIC_SUPABASE_URL y/o SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

const supabase = createClient(url, key);

const BASE = '/home/ivan/Escritorio/AMPA_Los_Lirios_Organizado';

const MIME_TYPES = {
  '.pdf': 'application/pdf',
  '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  '.doc': 'application/msword',
  '.odt': 'application/vnd.oasis.opendocument.text',
  '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  '.xls': 'application/vnd.ms-excel',
  '.txt': 'text/plain',
  '.html': 'text/html',
};

function categorizeFile(relPath) {
  const p = relPath.toLowerCase();
  if (p.includes('estatuto')) return 'estatutos';
  if (p.includes('plantilla') || p.includes('00_general/plantillas')) return 'plantillas';
  if (p.includes('informacion_socios') || p.includes('registro_y_censo')) return 'registros';
  if (p.includes('correspondencia')) return 'correspondencia';
  if (p.includes('economia') || p.includes('estado_de_cuentas') || p.includes('rifa')) return 'economia';
  if (p.includes('fiesta') || p.includes('navidad') || p.includes('halloween') || p.includes('fin_de_curso') || p.includes('dossier_fiestas')) return 'fiestas';
  if (p.includes('junta_directiva') || p.includes('reuniones_y_elecciones')) return 'junta_directiva';
  if (p.includes('proyecto')) return 'proyectos';
  if (p.includes('subvencion')) return 'subvenciones';
  if (p.includes('registro')) return 'registros';
  return 'varios';
}

function detectCurso(relPath) {
  const match = relPath.match(/(\d{4}-\d{4})\//);
  if (match) return match[1];
  const folder = relPath.split('/')[0];
  if (folder === '00_General' || folder === '01_Actas_Historicas') return null;
  return null;
}

async function main() {
  // Find all document files (excluding actas and images)
  const findCmd = `find "${BASE}" -type f \\( -name "*.pdf" -o -name "*.docx" -o -name "*.doc" -o -name "*.odt" -o -name "*.xlsx" -o -name "*.xls" -o -name "*.txt" -o -name "*.html" \\) ! -path "*/Actas/*" ! -path "*01_Actas_Historicas*" ! -path "*participantes-ampa*"`;
  const files = execSync(findCmd, { encoding: 'utf-8' }).trim().split('\n').filter(Boolean);

  console.log(`Encontrados ${files.length} documentos para subir.\n`);

  let ok = 0, fail = 0, skip = 0;

  for (const filePath of files) {
    const relPath = filePath.replace(BASE + '/', '');
    const name = basename(filePath);
    const ext = extname(filePath).toLowerCase();
    const categoria = categorizeFile(relPath);
    const curso = detectCurso(relPath);
    const mime = MIME_TYPES[ext] || 'application/octet-stream';

    // Check if already uploaded (by name + categoria + curso)
    const { data: existing } = await supabase
      .from('documentos')
      .select('id')
      .eq('nombre', name)
      .eq('categoria', categoria)
      .maybeSingle();

    if (existing) {
      skip++;
      continue;
    }

    try {
      const stat = statSync(filePath);
      const buffer = readFileSync(filePath);
      const safeName = name.replace(/[^a-zA-Z0-9._-]/g, '_');
      const storagePath = `${categoria}/${curso || 'general'}/${Date.now()}_${safeName}`;

      const { error: upErr } = await supabase.storage
        .from('documentos-ampa')
        .upload(storagePath, buffer, { contentType: mime, upsert: false });

      if (upErr) {
        console.error(`  ✗ ${name}: ${upErr.message}`);
        fail++;
        continue;
      }

      const { error: dbErr } = await supabase.from('documentos').insert({
        nombre: name,
        categoria,
        curso_escolar: curso,
        tipo_archivo: ext.replace('.', ''),
        tamano_bytes: stat.size,
        storage_path: storagePath,
        created_by: 'seed-script',
      });

      if (dbErr) {
        console.error(`  ✗ DB ${name}: ${dbErr.message}`);
        fail++;
      } else {
        console.log(`  ✓ ${name} → ${categoria}${curso ? ' (' + curso + ')' : ''}`);
        ok++;
      }
    } catch (err) {
      console.error(`  ✗ ${name}: ${err.message}`);
      fail++;
    }
  }

  console.log(`\nResultado: ${ok} subidos, ${skip} ya existían, ${fail} errores.`);
}

main();
