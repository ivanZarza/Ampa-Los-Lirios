import { createClient } from '@supabase/supabase-js';

if (typeof globalThis.WebSocket === 'undefined') {
  try {
    const ws = await import('ws');
    (globalThis as any).WebSocket = ws.default;
  } catch {}
}

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL || 'https://jfeyforrbaxxmsgpvviu.supabase.co';
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmZXlmb3JyYmF4eG1zZ3B2dml1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTIxOTcwMjUsImV4cCI6MjEwNzc3MzAyNX0.dulwOTulQ9dJm7S_nThLF6y_MDnDUe0yX-VKCm-fbNA';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export function getServiceClient() {
  const serviceKey = import.meta.env.SUPABASE_SERVICE_ROLE_KEY;
  return createClient(supabaseUrl, serviceKey);
}
