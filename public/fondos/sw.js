const CACHE='ampa-fondos-v1';
const ASSETS=['/fondos/','/fondos/index.html','/fondos/manifest.json','/fondos/favicon.svg'];

self.addEventListener('install',e=>{
  e.waitUntil(caches.open(CACHE).then(c=>c.addAll(ASSETS)));
  self.skipWaiting();
});

self.addEventListener('activate',e=>{
  e.waitUntil(caches.keys().then(ks=>Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k)))));
  self.clients.claim();
});

self.addEventListener('fetch',e=>{
  if(e.request.method!=='GET')return;
  e.respondWith(
    fetch(e.request).then(r=>{
      if(r.ok){const cl=r.clone();caches.open(CACHE).then(c=>c.put(e.request,cl))}
      return r;
    }).catch(()=>caches.match(e.request))
  );
});
