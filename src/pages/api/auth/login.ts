import type { APIRoute } from 'astro';
import { supabase, getServiceClient } from '../../../lib/supabase';

export const POST: APIRoute = async ({ request, redirect }) => {
  const form = await request.formData();
  const email = form.get('email')?.toString().trim().toLowerCase();

  if (!email) {
    return redirect('/admin/login?error=Introduce+tu+correo+electrónico');
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

  const siteUrl = import.meta.env.PUBLIC_SITE_URL || new URL(request.url).origin;

  const { error } = await supabase.auth.signInWithOtp({
    email,
    options: {
      emailRedirectTo: `${siteUrl}/api/auth/callback`,
    },
  });

  if (error) {
    return redirect('/admin/login?error=Error+al+enviar+el+enlace.+Inténtalo+de+nuevo.');
  }

  return redirect('/admin/login?ok=Revisa+tu+correo.+Te+hemos+enviado+un+enlace+para+acceder.');
};
