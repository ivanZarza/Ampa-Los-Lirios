import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request, cookies, redirect }) => {
  const form = await request.formData();
  const email = form.get('email')?.toString().trim().toLowerCase();
  const password = form.get('password')?.toString();

  if (!email || !password) {
    return redirect('/admin/login?error=Introduce+tu+correo+y+contraseña');
  }

  const { createClient } = await import('@supabase/supabase-js');
  const authClient = createClient(
    import.meta.env.PUBLIC_SUPABASE_URL,
    import.meta.env.PUBLIC_SUPABASE_ANON_KEY,
  );

  const { data: adminRows } = await authClient.rpc('check_admin_email', { check_email: email });

  if (!adminRows || adminRows.length === 0) {
    return redirect('/admin/login?error=Este+correo+no+tiene+acceso+al+panel');
  }

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
