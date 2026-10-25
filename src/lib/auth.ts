import { supabase, getServiceClient } from './supabase';
import type { AstroCookies } from 'astro';

const SUPER_ADMIN_EMAIL = 'ivanzarzaestevez@gmail.com';

export async function getSession(cookies: AstroCookies) {
  const accessToken = cookies.get('sb-access-token')?.value;
  const refreshToken = cookies.get('sb-refresh-token')?.value;

  if (!accessToken || !refreshToken) return null;

  const { data, error } = await supabase.auth.setSession({
    access_token: accessToken,
    refresh_token: refreshToken,
  });

  if (error || !data.session) return null;

  if (data.session.access_token !== accessToken) {
    cookies.set('sb-access-token', data.session.access_token, {
      path: '/',
      httpOnly: true,
      secure: true,
      sameSite: 'lax',
      maxAge: 60 * 60 * 24 * 7,
    });
    cookies.set('sb-refresh-token', data.session.refresh_token!, {
      path: '/',
      httpOnly: true,
      secure: true,
      sameSite: 'lax',
      maxAge: 60 * 60 * 24 * 7,
    });
  }

  return data.session;
}

export async function isAdmin(email: string): Promise<boolean> {
  const service = getServiceClient();
  const { data } = await service
    .from('admins')
    .select('email')
    .eq('email', email)
    .single();
  return !!data;
}

export async function requireAdmin(cookies: AstroCookies) {
  const session = await getSession(cookies);
  if (!session?.user?.email) return null;

  const admin = await isAdmin(session.user.email);
  if (!admin) return null;

  return session;
}

export function isSuperAdmin(email: string): boolean {
  return email.toLowerCase() === SUPER_ADMIN_EMAIL;
}

export async function requireSuperAdmin(cookies: AstroCookies) {
  const session = await requireAdmin(cookies);
  if (!session?.user?.email) return null;
  if (!isSuperAdmin(session.user.email)) return null;
  return session;
}

export async function getAdminWithRole(email: string) {
  const service = getServiceClient();
  const { data } = await service
    .from('admins')
    .select('id, email, nombre, rol')
    .eq('email', email)
    .single();
  return data;
}

export async function canAccessRoute(email: string, ruta: string): Promise<boolean> {
  const service = getServiceClient();

  const admin = await getAdminWithRole(email);
  if (!admin) return false;
  if (admin.rol === 'superadmin') return true;

  // Normalizar ruta: /admin/actas/pdf → /admin/actas
  const rutaBase = '/' + ruta.replace(/^\//, '').split('/').slice(0, 2).join('/');

  // Comprobar permiso individual (override)
  const { data: permiso } = await service
    .from('permisos_rutas')
    .select('permitido')
    .eq('admin_id', admin.id)
    .eq('ruta', rutaBase)
    .single();

  if (permiso) return permiso.permitido;

  // Sin override → comprobar rol por defecto en rutas_admin
  const { data: rutaDef } = await service
    .from('rutas_admin')
    .select('roles_permitidos')
    .eq('ruta', rutaBase)
    .single();

  if (!rutaDef) return true; // ruta no definida → permitir
  return rutaDef.roles_permitidos.includes(admin.rol);
}

export async function getRoutesForUser(email: string) {
  const service = getServiceClient();
  const admin = await getAdminWithRole(email);
  if (!admin) return [];

  const { data: rutas } = await service
    .from('rutas_admin')
    .select('*')
    .order('orden');

  if (!rutas) return [];

  if (admin.rol === 'superadmin') return rutas;

  // Obtener overrides del usuario
  const { data: overrides } = await service
    .from('permisos_rutas')
    .select('ruta, permitido')
    .eq('admin_id', admin.id);

  const overrideMap = new Map((overrides || []).map(o => [o.ruta, o.permitido]));

  return rutas.filter(r => {
    if (overrideMap.has(r.ruta)) return overrideMap.get(r.ruta);
    return r.roles_permitidos.includes(admin.rol);
  });
}
