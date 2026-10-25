export const prerender = false;
import type { APIRoute } from 'astro';
import { getServiceClient } from '../../../lib/supabase';

export const POST: APIRoute = async ({ request, cookies, redirect }) => {
  const form = await request.formData();
  const email = form.get('email')?.toString().trim().toLowerCase();
  const password = form.get('password')?.toString();

  if (!email || !password) {
    return redirect('/admin/login?error=Introduce+tu+correo+y+contraseña');
  }

  const service = getServiceClient();

  const { data: admin } = await service
    .from('admins')
    .select('email')
    .eq('email', email)
    .single();

  if (!admin) {
    return redirect('/admin/login?error=Este+correo+no+tiene+acceso+al+panel');
  }

  const { data: usersData } = await service.auth.admin.listUsers();
  const user = usersData?.users?.find(u => u.email === email);

  if (!user) {
    return redirect('/admin/login?error=Usuario+no+encontrado.+Contacta+con+el+administrador.');
  }

  const { createClient } = await import('@supabase/supabase-js');
  const authClient = createClient(
    import.meta.env.PUBLIC_SUPABASE_URL,
    import.meta.env.PUBLIC_SUPABASE_ANON_KEY,
  );

  const { data: signIn, error: signInErr } = await authClient.auth.signInWithPassword({
    email,
    password,
  });

  if (signInErr || !signIn.session) {
    return redirect('/admin/login?error=Correo+o+contraseña+incorrectos');
  }

  cookies.set('sb-access-token', signIn.session.access_token, {
    path: '/',
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
    maxAge: 60 * 60 * 24 * 7,
  });

  cookies.set('sb-refresh-token', signIn.session.refresh_token!, {
    path: '/',
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
    maxAge: 60 * 60 * 24 * 7,
  });

  return redirect('/admin');
};
