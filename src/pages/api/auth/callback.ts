import type { APIRoute } from 'astro';
import { supabase } from '../../../lib/supabase';

export const GET: APIRoute = async ({ url, cookies, redirect }) => {
  const code = url.searchParams.get('code');

  if (!code) {
    return redirect('/admin/login?error=Enlace+no+válido.+Solicita+uno+nuevo.');
  }

  const { data, error } = await supabase.auth.exchangeCodeForSession(code);

  if (error || !data.session) {
    return redirect('/admin/login?error=El+enlace+ha+caducado.+Solicita+uno+nuevo.');
  }

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

  return redirect('/admin');
};
