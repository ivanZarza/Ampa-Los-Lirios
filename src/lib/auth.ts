import { supabase, getServiceClient } from './supabase';
import type { AstroCookies } from 'astro';

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
