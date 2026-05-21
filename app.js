// San Nicolas Central — PWA & Service Worker

(function(){
  // ── SERVICE WORKER via inline blob ─────────────────────────────────────
  var SW_CODE = [
    "var CACHE='sn-v2';",
    "self.addEventListener('install',function(e){",
    "  e.waitUntil(caches.open(CACHE).then(function(c){",
    "    return c.addAll(['/']);",
    "  }).then(function(){return self.skipWaiting();}));",
    "});",
    "self.addEventListener('activate',function(e){",
    "  e.waitUntil(caches.keys().then(function(keys){",
    "    return Promise.all(keys.filter(function(k){return k!==CACHE;}).map(function(k){return caches.delete(k);}));",
    "  }).then(function(){return self.clients.claim();}));",
    "});",
    "self.addEventListener('fetch',function(e){",
    "  if(e.request.method!=='GET')return;",
    "  e.respondWith(",
    "    caches.match(e.request).then(function(cached){",
    "      if(cached)return cached;",
    "      return fetch(e.request).then(function(resp){",
    "        if(resp&&resp.status===200){",
    "          var c=resp.clone();",
    "          caches.open(CACHE).then(function(cache){cache.put(e.request,c);});",
    "        }",
    "        return resp;",
    "      }).catch(function(){return cached;});",
    "    })",
    "  );",
    "});"
  ].join('\n');

  if('serviceWorker' in navigator){
    var blob = new Blob([SW_CODE], {type:'text/javascript'});
    var url = URL.createObjectURL(blob);
    navigator.serviceWorker.register(url).then(function(){
      console.log('[PWA] Service Worker registered');
    }).catch(function(e){
      console.log('[PWA] SW needs HTTPS to install:', e.message);
    });
  }

  // ── INSTALL PROMPT ──────────────────────────────────────────────────────
  var deferredPrompt = null;
  var dismissed = localStorage.getItem('pwa-dismissed') === '1';
  var installed = window.matchMedia('(display-mode: standalone)').matches
    || window.navigator.standalone === true;

  function showBanner(){
    if(dismissed||installed)return;
    document.getElementById('pwa-banner').classList.add('show');
  }

  function dismissPwa(){
    document.getElementById('pwa-banner').classList.remove('show');
    localStorage.setItem('pwa-dismissed','1');
  }
  window.dismissPwa = dismissPwa;

  // Android/Chrome: beforeinstallprompt
  window.addEventListener('beforeinstallprompt', function(e){
    e.preventDefault();
    deferredPrompt = e;
    document.getElementById('pwa-sub-txt').textContent = 'Instala la app para acceso rapido';
    document.getElementById('pwa-ios-steps').classList.remove('show');
    showBanner();
  });

  document.getElementById('pwa-install-btn').addEventListener('click', function(){
    if(deferredPrompt){
      // Android Chrome native prompt
      deferredPrompt.prompt();
      deferredPrompt.userChoice.then(function(r){
        deferredPrompt = null;
        if(r.outcome === 'accepted'){
          document.getElementById('pwa-banner').classList.remove('show');
        }
      });
    } else {
      // iOS Safari or other: show manual instructions
      var steps = document.getElementById('pwa-ios-steps');
      if(steps.classList.contains('show')){
        steps.classList.remove('show');
      } else {
        steps.classList.add('show');
        document.getElementById('pwa-sub-txt').textContent = 'Sigue los pasos para instalar en iPhone/iPad:';
      }
    }
  });

  // Detect iOS
  var isIOS = /iphone|ipad|ipod/i.test(navigator.userAgent);
  var isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);

  if(isIOS && isSafari && !installed && !dismissed){
    // Show banner with iOS instructions automatically on Safari iOS
    document.getElementById('pwa-sub-txt').textContent = 'Instala la app en tu iPhone o iPad';
    setTimeout(showBanner, 2000);
  }

  // Show banner for non-iOS non-Chrome if not installed
  if(!isIOS && !deferredPrompt && !installed && !dismissed){
    // Will show if beforeinstallprompt fires (Chrome/Edge on HTTPS)
    // On file:// protocol, show a hint after login
    window._pwaShowHint = function(){
      if(!deferredPrompt && !installed && !dismissed){
        document.getElementById('pwa-sub-txt').textContent = 'Sirve el archivo via HTTPS para instalar como app';
        showBanner();
      }
    };
  }

  // Hide if already installed (standalone mode)
  if(installed){
    document.getElementById('pwa-banner').classList.remove('show');
  }

  // After successful login, optionally show PWA hint
  var _origBuildNav = window.buildNav;
})();