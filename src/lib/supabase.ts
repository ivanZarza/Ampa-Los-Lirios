import { createClient, type SupabaseClient } from '@supabase/supabase-js';

if (typeof globalThis.WebSocket === 'undefined') {
  (globalThis as any).WebSocket = class NoopWebSocket {
    static CONNECTING = 0; static OPEN = 1; static CLOSING = 2; static CLOSED = 3;
    readyState = 3;
    close() {} send() {} addEventListener() {} removeEventListener() {}
  };
}

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL || 'https://jfeyforrbaxxmsgpvviu.supabase.co';
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmZXlmb3JyYmF4eG1zZ3B2dml1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTIxOTcwMjUsImV4cCI6MjEwNzc3MzAyNX0.dulwOTulQ9dJm7S_nThLF6y_MDnDUe0yX-VKCm-fbNA';

let _supabase: SupabaseClient;
export function getSupabase() {
  if (!_supabase) _supabase = createClient(supabaseUrl, supabaseAnonKey);
  return _supabase;
}

export const supabase = new Proxy({} as SupabaseClient, {
  get(_target, prop) {
    return (getSupabase() as any)[prop];
  }
});

export function getServiceClient() {
  const serviceKey = import.meta.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!serviceKey) return getSupabase();
  return createClient(supabaseUrl, serviceKey);
}
