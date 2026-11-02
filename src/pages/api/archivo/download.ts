export const prerender = false;
import type { APIRoute } from 'astro';
import { getSession, isAdmin } from '../../../lib/auth';
import { getServiceClient } from '../../../lib/supabase';

export const GET: APIRoute = async ({ cookies, url }) => {
  const session = await getSession(cookies);
  if (!session?.user?.email) return new Response('No autorizado', { status: 401 });
  const admin = await isAdmin(session.user.email);
  if (!admin) return new Response('No autorizado', { status: 401 });

  const id = url.searchParams.get('id');
  if (!id) return new Response('Falta id', { status: 400 });

  const service = getServiceClient();
  const { data: doc } = await service.from('documentos').select('nombre, storage_path, tipo_archivo').eq('id', id).single();
  if (!doc) return new Response('Documento no encontrado', { status: 404 });

  const { data, error } = await service.storage.from('documentos-ampa').download(doc.storage_path);
  if (error || !data) return new Response('Error al descargar: ' + error?.message, { status: 500 });

  const contentTypes: Record<string, string> = {
    pdf: 'application/pdf',
    docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    doc: 'application/msword',
    odt: 'application/vnd.oasis.opendocument.text',
    xlsx: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    txt: 'text/plain',
    html: 'text/html',
    jpg: 'image/jpeg',
    jpeg: 'image/jpeg',
    png: 'image/png',
  };

  return new Response(data, {
    headers: {
      'Content-Type': contentTypes[doc.tipo_archivo] || 'application/octet-stream',
      'Content-Disposition': `attachment; filename="${encodeURIComponent(doc.nombre)}"`,
    },
  });
};
