// San Nicolas Central — Main Application

var SB=null, CU=null;
var cobros=[], tickets=[], cajaMov=[], usuarios=[];
var pendDel={t:null,id:null};
var editType=null, editRec=null, editUID=null;
var charts={};
var curPage='dashboard';
var isConn=false;
var stTmr=null;
var _insFlight=false;
var MESES=['','Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];

function fmt(n){return '$'+Math.round(+n||0).toLocaleString('es-AR');}
function fmtM(m){return (MESES[+m]||String(m)).slice(0,3);}
function fmtF(f){if(!f)return'-';try{var p=f.split('T')[0].split('-');return p[2]+'/'+p[1]+'/'+p[0];}catch(e){return f;}}
function today(){return new Date().toISOString().split('T')[0];}
function gv(id){var e=document.getElementById(id);return e?e.value:'';}
function sv(id,v){var e=document.getElementById(id);if(e)e.value=v;}
function el(id){return document.getElementById(id);}
function cleanN(inp){inp.value=inp.value.replace(/[^0-9.,]/g,'');}

function parseImp(raw){
  if(!raw)return NaN;
  var s=String(raw).replace(/\$/g,'').replace(/\s/g,'');
  var hD=s.indexOf('.')>=0, hC=s.indexOf(',')>=0;
  if(hD&&hC){
    s=s.lastIndexOf(',')>s.lastIndexOf('.')?s.replace(/\./g,'').replace(',','.'):s.replace(/,/g,'');
  } else if(hD){
    var p=s.split('.');
    if(p.length>2)s=s.replace(/\./g,'');
    else if(p[1]&&p[1].length===3)s=s.replace('.','');
  } else if(hC){
    var q=s.split(',');
    if(q.length>2)s=s.replace(/,/g,'');
    else if(q[1]&&q[1].length===3)s=s.replace(',','');
    else s=s.replace(',','.');
  }
  return Math.round(parseFloat(s)*100)/100;
}

function diagErr(e){
  if(!e)return'Error desconocido';
  var m=e.message||'', c=e.code||'';
  if(c==='42501'||m.indexOf('policy')>=0)return'Sin permisos RLS - re-ejecuta el schema SQL';
  if(m.indexOf('relation')>=0||m.indexOf('does not exist')>=0)return'Tabla no encontrada - ejecuta supabase_schema.sql';
  if(m.indexOf('JWT')>=0||c==='PGRST301')return'Sesion expirada - reconecta';
  return m;
}

function showSB(msg,type,dur){
  var e=el('sb');if(!e)return;
  e.className=type||'info';e.textContent=msg;e.style.display='flex';
  if(stTmr)clearTimeout(stTmr);
  var d=dur===undefined?4000:dur;
  if(d>0)stTmr=setTimeout(function(){e.style.display='none';},d);
}
function setDot(s){var d=el('dot');if(d)d.className='dot '+(s==='on'?'on':s==='ld'?'ld':'off');}
function setSyn(s,t){var b=el('syn');if(b){b.className='synbadge '+(s==='ok'?'ok':s==='sy'?'sy':'er');b.textContent=t;}}
function setConnBar(ok,msg){
  var bar=el('connbar'),txt=el('conntxt');
  if(bar)bar.className=ok?'cbar ok':'cbar', bar.id='connbar';
  if(txt)txt.textContent=msg;
}
function bdg(e){
  if(e==='cobrado')return'<span class="badge bgn">cobrado</span>';
  if(e==='pendiente')return'<span class="badge bam">pendiente</span>';
  if(e==='anulado')return'<span class="badge brd">anulado</span>';
  return'<span class="badge bbl">'+e+'</span>';
}
function bfl(f){return f==='ingreso'?'<span class="badge bgn">ingreso</span>':'<span class="badge brd">egreso</span>';}

function showOv(id){var e=el(id);if(e){e.style.display='flex';e.classList.add('open');}}
function hideOv(id){var e=el(id);if(e){e.classList.remove('open');e.style.display='none';}}

function openSidebar(){el('sidebar').classList.add('open');el('sdov').classList.add('open');}

function toggleSidebarCollapse(){
  // Only works on desktop (>768px)
  if(window.innerWidth<=768){
    openSidebar();return;
  }
  var collapsed=document.body.classList.toggle('sidebar-collapsed');
  // Save preference
  localStorage.setItem('sn_sidebar_collapsed', collapsed?'1':'0');
}
function closeSidebar(){el('sidebar').classList.remove('open');el('sdov').classList.remove('open');}

function showCfg(){
  if(!CU||CU.rol!=='admin_central'){
    showSB('Solo el administrador central puede acceder a la configuracion','error');
    return;
  }
  var lw=el('lw');
  if(lw){
    lw.style.display='flex';
    var aw=el('aw');
    if(aw)aw.style.display='none';
  }
}

function showCfgResult(ok,msg){
  var e=el('cfg-result');if(!e)return;
  e.style.display='block';
  if(ok===null){e.style.cssText='display:block;margin-top:8px;padding:8px 10px;border-radius:6px;font-size:12px;background:var(--amberbg);color:var(--amber);border:1px solid #5a3a05';}
  else if(ok){e.style.cssText='display:block;margin-top:8px;padding:8px 10px;border-radius:6px;font-size:12px;background:var(--greenbg);color:var(--green);border:1px solid #155c36';}
  else{e.style.cssText='display:block;margin-top:8px;padding:8px 10px;border-radius:6px;font-size:12px;background:var(--redbg);color:var(--red);border:1px solid #5a1a1a';}
  e.textContent=msg;
}

function testConn(){
  var url=gv('cfg-url').trim(), key=gv('cfg-key').trim();
  if(!url||!key){showCfgResult(false,'Completa URL y Key');return;}
  if(url.indexOf('https://')!==0){showCfgResult(false,'URL debe empezar con https://');return;}
  if(url.indexOf('.supabase.co')<0){showCfgResult(false,'URL debe contener .supabase.co');return;}
  if(key.indexOf('eyJ')!==0){showCfgResult(false,'Key invalida - usa la clave anon/public');return;}
  var btn=el('btn-test');if(btn){btn.disabled=true;btn.textContent='Probando...';}
  showCfgResult(null,'Verificando conexion...');
  try{
    var tmp=window.supabase.createClient(url,key);
    tmp.from('usuarios').select('id').limit(1).then(function(r){
      if(btn){btn.disabled=false;btn.textContent='Probar';}
      if(r.error)showCfgResult(false,'Error: '+r.error.message);
      else showCfgResult(true,'Conexion exitosa - podes guardar');
    }).catch(function(e){
      if(btn){btn.disabled=false;btn.textContent='Probar';}
      showCfgResult(false,'Error: '+e.message);
    });
  }catch(e){
    if(btn){btn.disabled=false;btn.textContent='Probar';}
    showCfgResult(false,'Error: '+e.message);
  }
}

function saveConn(){
  var url=gv('cfg-url').trim().replace(/\/+$/,''), key=gv('cfg-key').trim();
  if(!url||!key){showCfgResult(false,'Completa los dos campos');return;}
  if(url.indexOf('https://')!==0){showCfgResult(false,'URL debe empezar con https://');return;}
  if(url.indexOf('.supabase.co')<0){showCfgResult(false,'URL debe contener .supabase.co');return;}
  if(key.indexOf('eyJ')!==0){showCfgResult(false,'Key invalida - usa la clave anon/public de Supabase');return;}
  var btn=el('btn-connect');if(btn){btn.disabled=true;btn.textContent='Conectando...';}
  showCfgResult(null,'Verificando...');
  try{
    var tmp=window.supabase.createClient(url,key);
    tmp.from('usuarios').select('id').limit(1).then(function(r){
      if(btn){btn.disabled=false;btn.textContent='Guardar y conectar';}
      if(r.error){
        showCfgResult(false,'Error: '+r.error.message+' - Verifica credenciales y que ejecutaste el schema SQL');
        return;
      }
      localStorage.setItem('sn_url',url);
      localStorage.setItem('sn_key',key);
      SB=tmp;
      isConn=true;
      setDot('on');
      showCfgResult(true,'Conectado! Ahora ingresa con tu usuario y PIN');
    }).catch(function(e){
      if(btn){btn.disabled=false;btn.textContent='Guardar y conectar';}
      showCfgResult(false,'Sin conexion: '+e.message);
    });
  }catch(e){
    if(btn){btn.disabled=false;btn.textContent='Guardar y conectar';}
    showCfgResult(false,'Error: '+e.message);
  }
}

function showLerr(msg){var e=el('lerr');if(e){e.textContent=msg;e.style.display='block';}}
function hideLerr(){var e=el('lerr');if(e)e.style.display='none';}

var _loginMode='numero';
function setLoginMode(mode){
  _loginMode=mode;
  var mNum=el('mode-numero'), mUsr=el('mode-usuario');
  var tNum=el('tab-num'), tUsr=el('tab-usr');
  if(mode==='numero'){
    if(mNum)mNum.style.display='';
    if(mUsr)mUsr.style.display='none';
    if(tNum){tNum.style.background='var(--blue)';tNum.style.color='#fff';tNum.style.border='none';}
    if(tUsr){tUsr.style.background='var(--bg3)';tUsr.style.color='var(--txt2)';tUsr.style.border='1px solid var(--bord)';}
  } else {
    if(mNum)mNum.style.display='none';
    if(mUsr)mUsr.style.display='';
    if(tUsr){tUsr.style.background='var(--blue)';tUsr.style.color='#fff';tUsr.style.border='none';}
    if(tNum){tNum.style.background='var(--bg3)';tNum.style.color='var(--txt2)';tNum.style.border='1px solid var(--bord)';}
    setTimeout(function(){var e=el('lusername');if(e)e.focus();},100);
  }
}

function doLogin(){
  if(!SB||!isConn){showLerr('Configura la conexion a Supabase primero');return;}
  var btn=el('lbtn');if(btn){btn.disabled=true;btn.textContent='Verificando...';}
  hideLerr();

  if(_loginMode==='usuario'){
    // Cobrador login: username + password
    var username=gv('lusername').trim().toLowerCase();
    var pass=gv('lpass').trim();
    if(!username){if(btn){btn.disabled=false;btn.textContent='Ingresar';}showLerr('Ingresa tu nombre de usuario');return;}
    if(!pass){if(btn){btn.disabled=false;btn.textContent='Ingresar';}showLerr('Ingresa tu contraseña');return;}
    SB.from('usuarios').select('*').eq('activo',true)
      .or('username.eq.'+username+',username.eq.cob'+username.replace('cob',''))
      .then(function(r){
        if(btn){btn.disabled=false;btn.textContent='Ingresar';}
        if(r.error){showLerr('Error: '+diagErr(r.error));return;}
        // Try exact username match or number-based match
        var u=null;
        if(r.data){
          u=r.data.find(function(x){return (x.username||'').toLowerCase()===username;});
          if(!u&&username.indexOf('cob')===0){
            var num=parseInt(username.replace('cob',''),10);
            u=r.data.find(function(x){return x.numero===num;});
          }
        }
        if(!u){
          // Fallback: search by numero directly
          var tryNum=parseInt(username.replace('cob',''),10);
          if(!isNaN(tryNum)){
            SB.from('usuarios').select('*').eq('numero',tryNum).eq('activo',true).then(function(r2){
              if(r2.data&&r2.data.length){
                var u2=r2.data[0];
                if(u2.pin.trim()===pass){loginSuccess(u2);}
                else showLerr('Contraseña incorrecta');
              } else {
                showLerr('Usuario no encontrado. Usa cob+numero (Ej: cob25)');
              }
            }).catch(function(e){showLerr('Error: '+diagErr(e));});
          } else {
            showLerr('Usuario no encontrado. Usa cob+numero (Ej: cob25)');
          }
          return;
        }
        if(u.pin.trim()!==pass){showLerr('Contraseña incorrecta');return;}
        loginSuccess(u);
      }).catch(function(e){
        if(btn){btn.disabled=false;btn.textContent='Ingresar';}
        showLerr('Error: '+diagErr(e));
      });
  } else {
    // Numero + PIN login (admins, agencias)
    var num=parseInt(gv('lnum'),10), pin=gv('lpin').trim();
    if(isNaN(num)){if(btn){btn.disabled=false;btn.textContent='Ingresar';}showLerr('Selecciona un usuario');return;}
    if(!pin){if(btn){btn.disabled=false;btn.textContent='Ingresar';}showLerr('Ingresa tu PIN');return;}
    SB.from('usuarios').select('*').eq('numero',num).eq('activo',true).then(function(r){
      if(btn){btn.disabled=false;btn.textContent='Ingresar';}
      if(r.error){showLerr('Error: '+diagErr(r.error));return;}
      if(!r.data||!r.data.length){showLerr('Usuario '+num+' no existe o inactivo');return;}
      var u=r.data[0];
      if(u.pin.trim()!==pin){showLerr('PIN incorrecto. Defaults: admin=0000, agencias=1234');return;}
      loginSuccess(u);
    }).catch(function(e){
      if(btn){btn.disabled=false;btn.textContent='Ingresar';}
      showLerr('Error: '+diagErr(e));
    });
  }
}

function loginSuccess(u){
  CU=u;
  localStorage.setItem('sn_u',JSON.stringify(u));
  el('lw').style.display='none';
  el('aw').style.display='block';
  buildNav();
  loadAll();
  // Initialize current page (sets title + date + content)
  var startPage=(u.rol==='cobrador'||u.rol==='agencia')?'fc':'dashboard';
  setTimeout(function(){go(startPage);},80);
}

function renderEnlaces(){
  if(!CU||CU.rol!=='admin_central'){
    var tb=el('tb-enlaces');if(tb)tb.innerHTML='<tr class="erow"><td colspan="6">Acceso restringido</td></tr>';
    showSB('Acceso restringido — solo el admin central','error');
    go('dashboard');
    return;
  }
  var rolF=gv('enl-rol-filter');
  var zonaF=gv('enl-zona-filter');
  var busq=gv('enl-busq').toLowerCase();
  var base=window.location.origin+window.location.pathname;
  var list=usuarios.filter(function(u){
    if(rolF&&u.rol!==rolF)return false;
    if(zonaF&&+u.zona!==+zonaF)return false;
    if(busq&&u.nombre.toLowerCase().indexOf(busq)<0&&String(u.numero).indexOf(busq)<0)return false;
    return true;
  }).sort(function(a,b){
    if(a.rol!==b.rol){
      var ord={admin_central:1,admin_zona:2,agencia:3,cobrador:4};
      return (ord[a.rol]||9)-(ord[b.rol]||9);
    }
    return a.numero-b.numero;
  });

  var meta=el('enl-meta');if(meta)meta.textContent=list.length+' usuarios';

  function rolBadge(r){
    if(r==='admin_central')return '<span class="badge bam">Admin Central</span>';
    if(r==='admin_zona')return '<span class="badge bbl">Admin Zona</span>';
    if(r==='agencia')return '<span class="badge bgn">Agencia</span>';
    if(r==='cobrador')return '<span class="badge bpu2">Cobrador</span>';
    return r;
  }

  function buildLink(u){
    var param=u.rol==='cobrador'?(u.username||('cob'+u.numero)):String(u.numero);
    return base+'?u='+param;
  }

  var tb=el('tb-enlaces');if(!tb)return;
  if(!list.length){
    tb.innerHTML='<tr class="erow"><td colspan="6">No hay usuarios para los filtros</td></tr>';
    return;
  }
  tb.innerHTML=list.map(function(u){
    var link=buildLink(u);
    var shortLink=link.length>50?link.slice(0,30)+'...?u='+link.split('?u=')[1]:link;
    return '<tr>'
      +'<td style="font-size:10px;color:var(--txt3)">'+u.numero+'</td>'
      +'<td><strong>'+u.nombre+'</strong></td>'
      +'<td>'+rolBadge(u.rol)+'</td>'
      +'<td style="font-size:11px;color:var(--txt2)">'+(u.localidad||'-')+'</td>'
      +'<td><code style="font-size:10px;color:var(--blue);background:var(--bg3);padding:3px 7px;border-radius:4px;word-break:break-all">'+shortLink+'</code></td>'
      +'<td class="no-print" style="white-space:nowrap">'
        +'<button class="ab ae" title="Copiar" onclick="copiarLink(\''+link+'\',this)">📋 Copiar</button> '
        +'<button class="ab ae" title="Compartir" onclick="compartirLink(\''+link+'\',\''+(u.nombre.replace(/\'/g,"\\'"))+'\')">📤</button>'
      +'</td>'
      +'</tr>';
  }).join('');
}

function copiarLink(link,btn){
  if(navigator.clipboard&&navigator.clipboard.writeText){
    navigator.clipboard.writeText(link).then(function(){
      if(btn){var orig=btn.innerHTML;btn.innerHTML='✓ Copiado';setTimeout(function(){btn.innerHTML=orig;},2000);}
    }).catch(function(){fallbackCopy(link,btn);});
  } else {
    fallbackCopy(link,btn);
  }
}

function fallbackCopy(text,btn){
  var t=document.createElement('textarea');t.value=text;document.body.appendChild(t);t.select();
  try{document.execCommand('copy');if(btn){var orig=btn.innerHTML;btn.innerHTML='✓ Copiado';setTimeout(function(){btn.innerHTML=orig;},2000);}}catch(e){}
  document.body.removeChild(t);
}

function compartirLink(link,nombre){
  if(navigator.share){
    navigator.share({
      title:'Enlace de acceso - '+nombre,
      text:'Tu enlace personal para acceder al sistema San Nicolás:',
      url:link
    }).catch(function(){});
  } else {
    copiarLink(link,null);
    showSB('Enlace copiado al portapapeles','success');
  }
}

function exportEnlacesCSV(){
  var base=window.location.origin+window.location.pathname;
  function esc(v){var s=String(v==null?'':v);return(s.indexOf(',')>=0||s.indexOf('"')>=0)?'"'+s.replace(/"/g,'""')+'"':s;}
  var csv='numero,nombre,rol,localidad,enlace\n';
  csv+=usuarios.sort(function(a,b){return a.numero-b.numero;}).map(function(u){
    var param=u.rol==='cobrador'?(u.username||('cob'+u.numero)):String(u.numero);
    var link=base+'?u='+param;
    return [u.numero,u.nombre,u.rol,u.localidad||'',link].map(esc).join(',');
  }).join('\n');
  var b=new Blob(['\ufeff'+csv],{type:'text/csv;charset=utf-8;'});
  var a=document.createElement('a');
  a.href=URL.createObjectURL(b);
  a.download='Enlaces_acceso_'+today().replace(/-/g,'')+'.csv';
  a.click();URL.revokeObjectURL(a.href);
}

function mostrarMiEnlace(){
  if(!CU)return;
  var base=window.location.origin+window.location.pathname;
  // Build personal link based on role
  var param;
  if(CU.rol==='cobrador'){
    param=CU.username||('cob'+CU.numero);
  } else {
    param=String(CU.numero);
  }
  var link=base+'?u='+param;
  // Show modal
  var existing=document.getElementById('ov-enlace');
  if(existing)existing.remove();
  var modal=document.createElement('div');
  modal.id='ov-enlace';
  modal.className='ov open';
  modal.style.display='flex';
  modal.innerHTML='<div class="modal" style="max-width:480px">'
    +'<div class="mtitle">🔗 Tu enlace personal</div>'
    +'<div class="msub">Compartí este enlace con vos mismo o guardalo en favoritos. Al abrirlo, el usuario se completa automáticamente.</div>'
    +'<div style="background:var(--bg3);border:1px solid var(--bord2);border-radius:8px;padding:10px;margin:1rem 0;word-break:break-all;font-size:12px;color:var(--blue);font-family:monospace">'+link+'</div>'
    +'<div style="font-size:11px;color:var(--txt3);margin-bottom:10px">Solo tendrás que ingresar tu '+(CU.rol==='cobrador'?'contraseña':'PIN')+'</div>'
    +'<div class="mact" style="flex-wrap:wrap;gap:8px">'
    +'<button class="btn bg" onclick="hideOv(\'ov-enlace\');document.getElementById(\'ov-enlace\').remove()">Cerrar</button>'
    +'<button class="btn bp" onclick="copiarEnlace(\''+link.replace(/\\/g,'\\\\').replace(/\'/g,"\\'")+'\',this)">Copiar enlace</button>'
    +(navigator.share?'<button class="btn bs" onclick="compartirEnlace(\''+link.replace(/\\/g,'\\\\').replace(/\'/g,"\\'")+'\')">Compartir</button>':'')
    +'</div></div>';
  document.body.appendChild(modal);
}

function copiarEnlace(link,btn){
  if(navigator.clipboard&&navigator.clipboard.writeText){
    navigator.clipboard.writeText(link).then(function(){
      if(btn){btn.textContent='✓ Copiado!';setTimeout(function(){btn.textContent='Copiar enlace';},2000);}
    }).catch(function(){
      // Fallback
      var t=document.createElement('textarea');t.value=link;document.body.appendChild(t);t.select();
      try{document.execCommand('copy');if(btn){btn.textContent='✓ Copiado!';setTimeout(function(){btn.textContent='Copiar enlace';},2000);}}catch(e){}
      document.body.removeChild(t);
    });
  }
}

function compartirEnlace(link){
  if(navigator.share){
    navigator.share({
      title:'San Nicolás - Acceso',
      text:'Mi enlace de acceso al sistema',
      url:link
    }).catch(function(){});
  }
}

function doLogout(){
  stopNotifPolling();
  CU=null;cobros=[];tickets=[];cajaMov=[];usuarios=[];
  localStorage.removeItem('sn_u');
  el('aw').style.display='none';
  el('lw').style.display='flex';
  sv('lpin','');sv('lusername','');sv('lpass','');hideLerr();closeSidebar();
  setLoginMode('numero');
  document.body.classList.remove('is-agencia');
  window._saveMode=null;
  window._lastNotifId=null;
}

function buildNav(){
  if(!CU)return;
  var rol=CU.rol||'agencia';
  var isCent=rol==='admin_central'||rol==='admin';
  var isZona=rol==='admin_zona';
  var isAg=rol==='agencia';
  var isCob=rol==='cobrador';
  var isAgOrCob=isAg||isCob;
  var isAdmin=isCent||isZona;

  el('uav').textContent=CU.numero===0?'C':CU.numero;
  el('unm').textContent=CU.nombre;
  var agNombre=isCob&&CU.agencia_numero?(' — Agencia '+CU.localidad):'';
  el('url2').textContent=isCent?'Admin Central':(isZona?('Admin Zona '+CU.zona):(isCob?('Cobrador - '+CU.localidad+' (Ag. '+CU.agencia_numero+')'):('Agencia: '+CU.localidad)));

  var h='';
  if(isCob){
    h+='<div class="nsec">Cargar datos</div>';
    h+='<div class="ni active" data-page="fc">Nuevo cobro</div>';
    h+='<div class="ni" data-page="ft">Ticket devuelto</div>';
    h+='<div class="ni" data-page="fca">Movimiento caja</div>';
  } else if(isAg){
    h+='<div class="nsec">Cargar datos</div>';
    h+='<div class="ni active" data-page="fc">Nuevo cobro</div>';
    h+='<div class="ni" data-page="ft">Ticket devuelto</div>';
    h+='<div class="ni" data-page="fca">Movimiento caja</div>';
    h+='<div class="nsec">Mi planilla</div>';
    h+='<div class="ni-wrap" data-page="planilla"><span>📋 Cierre diario</span><span class="notif-badge" id="planilla-badge" style="position:static;display:none;margin-left:auto">!</span></div>';
    h+='<div class="ni" data-page="mis-cobradores">Mis Cobradores</div>';
  } else {
    h+='<div class="nsec">Analisis</div>';
    h+='<div class="ni'+(curPage==='dashboard'?' active':'')+'" data-page="dashboard">Dashboard</div>';
    h+='<div class="ni" data-page="central">'+(isCent?'Vista Central':'Vista Zona '+CU.zona)+'</div>';
    h+='<div class="nsec">Cargar datos</div>';
    h+='<div class="ni" data-page="fc">Nuevo cobro</div>';
    h+='<div class="ni" data-page="ft">Ticket devuelto</div>';
    h+='<div class="ni" data-page="fca">Movimiento caja</div>';
    h+='<div class="nsec">Registros</div>';
    h+='<div class="ni" data-page="lc">Cobros</div>';
    h+='<div class="ni" data-page="lt">Tickets</div>';
    h+='<div class="ni" data-page="lca">Caja</div>';
    h+='<div class="nsec">Aprobaciones</div>';
    h+='<div class="ni-wrap" data-page="aprobacion"><span>Aprobar registros</span><span class="notif-badge" id="aprov-badge" style="position:static;display:none;margin-left:auto">!</span></div>';
    if(isCent){
      h+='<div class="nsec">Admin</div>';
      h+='<div class="ni" data-page="usuarios">Usuarios</div>';
      h+='<div class="ni" data-page="enlaces">🔗 Enlaces de acceso</div>';
    }
  }
  if(!isCob){
    h+='<div class="nsec">Sistema</div>';
    if(isCent){
      h+='<div class="ni" data-cfg="1">Configurar DB</div>';
    }
  }

  var nm=el('nav');nm.innerHTML=h;
  nm.querySelectorAll('.ni[data-page]').forEach(function(n){
    n.addEventListener('click',function(){go(n.getAttribute('data-page'));closeSidebar();});
  });
  nm.querySelectorAll('.ni[data-cfg]').forEach(function(n){
    n.addEventListener('click',function(){showCfg();closeSidebar();});
  });

  document.querySelectorAll('.uh').forEach(function(e){e.style.display=isAdmin?'':'none';});
  var poc=el('po-ct');if(poc)poc.style.display=isAdmin?'flex':'none';

  sv('c-fec',today());sv('t-fec',today());sv('ca-fec',today());
  var loc=CU.localidad||'';
  sv('c-loc',loc);sv('t-loc',loc);sv('ca-loc',loc);sv('c-cob',CU.nombre);

  if(isAgOrCob){
    document.body.classList.add('is-agencia');
    setTimeout(function(){go('fc');},50);
    // Show planilla badge for agencias after data loads
    setTimeout(updatePlanillaBadge, 2000);
    // Cobradores guardan directo a agencia (sin aprobacion)
    // Agencias envian a admin de zona para aprobacion
    // Cobrador: registros van a agencia como 'pendiente'
    // Agencia: sus propios registros tambien quedan 'pendiente' hasta enviar el cierre
    // Solo el admin de zona los aprueba para que cuenten en estadisticas
    window._saveMode='pendiente';
    setTimeout(function(){
      var lbl=isCob?'Enviar a la agencia':'Guardar cobro';
      var lblT=isCob?'Enviar a la agencia':'Guardar ticket';
      var lblC=isCob?'Enviar a la agencia':'Guardar movimiento';
      // Cobrador page: localidad auto-filled, cobrador = self
      if(isCob){
        setTimeout(function(){
          // Auto-fill and lock fields for cobrador
          ['c-loc','t-loc','ca-loc'].forEach(function(id){
            var e=el(id);if(!e)return;
            e.value=CU.localidad||'';
            e.readOnly=true;e.style.color='var(--txt3)';
          });
          var ccob=el('c-cob');
          if(ccob){ccob.value=CU.nombre;ccob.readOnly=true;ccob.style.color='var(--txt3)';}
        },150);
      }
      var bsc=el('btn-sc');if(bsc)bsc.textContent=lbl;
      var bst=el('btn-st');if(bst)bst.textContent=lblT;
      var bsca=el('btn-sca');if(bsca)bsca.textContent=lblC;
    },100);
  } else {
    document.body.classList.remove('is-agencia');
    window._saveMode='directo';
  }

  // Show Config DB button in topbar only to admin_central
  var cfgTop=el('btn-cfg-top');
  if(cfgTop)cfgTop.style.display=isCent?'':'none';

  // Hide topbar action buttons for cobradores
  var topbarBtns=['btn-ref','btn-csv','btn-prt'];
  topbarBtns.forEach(function(id){
    var b=el(id);if(b)b.style.display=isCob?'none':'';
  });
  var bellBtn=el('bell-btn');
  var bellWrap=bellBtn?bellBtn.parentElement:null;
  if(bellWrap)bellWrap.style.display=isCob?'none':'';

  window._isAdmin=isAdmin;
  window._isCent=isCent;

  // Show folder button for admins and agencias (can export)
  var carpetaBtn=el('btn-carpeta');
  if(carpetaBtn){
    carpetaBtn.style.display=isAdmin?'':'none';
    var savedNombre=localStorage.getItem('sn_carpeta_nombre');
    var cnm=el('carpeta-nombre');
    if(cnm)cnm.textContent=savedNombre?savedNombre:'Carpeta';
  }

  // Start notification polling after login
  startNotifPolling();
  // Request browser notification permission
  pedirPermisoNotificacion();
}

function loadAll(){
  if(!SB||!isConn){showSB('Sin conexion Supabase','error',0);return;}
  var myGen=(window._loadGen=(window._loadGen||0)+1);
  setSyn('sy','Cargando...');
  var rol=CU.rol||'agencia';
  var isCent=rol==='admin_central'||rol==='admin';
  var isZona=rol==='admin_zona';
  var isAg=rol==='agencia';
  var isCob=rol==='cobrador';
  function q(t){
    var base=SB.from(t).select('*').order('created_at',{ascending:false});
    if(isCent)return base;
    if(isZona)return base.eq('zona',CU.zona);
    // Agencia: ve todos sus cobradores + ella misma
    if(isAg)return base.eq('localidad',CU.localidad).eq('zona',CU.zona);
    // Cobrador: solo sus propios registros
    return base.eq('usuario_id',CU.id);
  }
  var qu=SB.from('usuarios').select('*').order('numero');
  Promise.all([q('cobros'),q('tickets'),q('caja_movimientos'),qu]).then(function(rs){
    if(myGen!==window._loadGen)return;
    if(rs[0].error)throw rs[0].error;
    if(rs[1].error)throw rs[1].error;
    if(rs[2].error)throw rs[2].error;
    cobros=rs[0].data||[];tickets=rs[1].data||[];cajaMov=rs[2].data||[];usuarios=rs[3].data||[];
    setDot('on');setSyn('ok','Sincronizado');
    showSB(cobros.length+' cobros - '+tickets.length+' tickets - '+cajaMov.length+' caja','success');
    refreshAll();
  }).catch(function(e){
    setDot('off');setSyn('er','Error');
    showSB('Error: '+diagErr(e),'error',0);
  });
}

function ins(tbl,row,alId,btnId,lbl,ok){
  if(!SB||!isConn){showAlr(alId,'error','Sin conexion');return;}
  if(_insFlight){showAlr(alId,'error','Espera la operacion anterior');return;}
  var btn=el(btnId);if(btn){btn.disabled=true;btn.textContent='Guardando...';}
  _insFlight=true;
  showSB('Guardando...','info',0);
  SB.from(tbl).insert([row]).select().then(function(r){
    _insFlight=false;
    if(btn){btn.disabled=false;btn.textContent=window._saveMode==='pendiente'?'Enviar para ser aprobado':lbl;}
    if(r.error){showAlr(alId,'error','Error: '+diagErr(r.error));showSB('Error: '+diagErr(r.error),'error',8000);return;}
    if(!r.data||!r.data.length){showAlr(alId,'error','Sin respuesta de Supabase');return;}
    showAlr(alId,'success','Guardado correctamente');
    showSB('Guardado','success');setSyn('ok','Sincronizado');
    ok(r.data[0]);
  }).catch(function(e){
    _insFlight=false;
    if(btn){btn.disabled=false;btn.textContent=window._saveMode==='pendiente'?'Enviar para ser aprobado':lbl;}
    showAlr(alId,'error','Error: '+diagErr(e));
    showSB('Error: '+diagErr(e),'error',8000);
  });
}

function saveCobro(){
  if(window._saveMode==='pendiente'){saveCobroAgencia();return;}
  var soc=gv('c-soc').trim(), mes=gv('c-mes'), imp=parseImp(gv('c-imp'));
  if(!soc||!mes){showAlr('al-c','error','Completa Socio, Mes e Importe');return;}
  if(isNaN(imp)||imp<=0){showAlr('al-c','error','Importe invalido');return;}
  var row={fecha:gv('c-fec')||today(),localidad:gv('c-loc')||CU.localidad||'',zona:CU.zona||0,socio:soc,mes:+mes,importe:imp,factura:gv('c-fac')||null,ticket_num:gv('c-tic')||null,cobrador:gv('c-cob')||CU.nombre,empresa:gv('c-emp'),estado:gv('c-est'),obs:gv('c-obs')||null,usuario_id:CU.id,usuario_nombre:CU.nombre,usuario_numero:CU.numero,estado_revision:'aprobado'};
  ins('cobros',row,'al-c','btn-sc','Guardar cobro',function(r){clearFC();loadAll();});
}
function saveTicket(){
  if(window._saveMode==='pendiente'){saveTicketAgencia();return;}
  var soc=gv('t-soc').trim(), mes=gv('t-mes'), imp=parseImp(gv('t-imp'));
  if(!soc||!mes){showAlr('al-t','error','Completa Socio, Mes e Importe');return;}
  if(isNaN(imp)||imp<=0){showAlr('al-t','error','Importe invalido');return;}
  var row={fecha:gv('t-fec')||today(),localidad:gv('t-loc')||CU.localidad||'',zona:CU.zona||0,socio:soc,mes:+mes,importe:imp,ticket:gv('t-tic')||null,motivo:gv('t-mot')||null,empresa:gv('t-emp'),usuario_id:CU.id,usuario_nombre:CU.nombre,usuario_numero:CU.numero,estado_revision:'aprobado'};
  ins('tickets',row,'al-t','btn-st','Guardar ticket',function(r){clearFT();loadAll();});
}
function saveCaja(){
  if(window._saveMode==='pendiente'){saveCajaAgencia();return;}
  var imp=parseImp(gv('ca-imp'));
  if(isNaN(imp)||imp<=0){showAlr('al-ca','error','Importe invalido');return;}
  var row={fecha:gv('ca-fec')||today(),localidad:gv('ca-loc')||CU.localidad||'',zona:CU.zona||0,empresa:gv('ca-emp'),tipo:gv('ca-tip'),banco:gv('ca-ban')||null,flujo:gv('ca-flu'),importe:imp,obs:gv('ca-obs')||null,usuario_id:CU.id,usuario_nombre:CU.nombre,usuario_numero:CU.numero,estado_revision:'aprobado'};
  ins('caja_movimientos',row,'al-ca','btn-sca','Guardar movimiento',function(r){clearFCA();loadAll();});
}
function clearFC(){['c-soc','c-imp','c-fac','c-tic','c-obs'].forEach(function(i){sv(i,'');});sv('c-mes','4');sv('c-emp','San Nicolás');sv('c-est','cobrado');sv('c-cob',CU?CU.nombre:'');sv('c-loc',CU?CU.localidad:'');}
function clearFT(){['t-soc','t-imp','t-tic','t-mot'].forEach(function(i){sv(i,'');});sv('t-mes','3');sv('t-emp','San Nicolás');sv('t-loc',CU?CU.localidad:'');}
function clearFCA(){['ca-imp','ca-ban','ca-obs'].forEach(function(i){sv(i,'');});sv('ca-emp','San Nicolás');sv('ca-tip','ING. FACTURAS');sv('ca-flu','ingreso');sv('ca-loc',CU?CU.localidad:'');}

function showAlr(id,type,msg){
  var e=el(id);if(!e){showSB(msg,type==='error'?'error':'success');return;}
  e.className='alr '+type;e.textContent=msg;e.style.display='flex';
  e.scrollIntoView({behavior:'smooth',block:'nearest'});
  if(type==='success')setTimeout(function(){e.style.display='none';},6000);
}

function mSel(id,opts,val){
  var o=opts.map(function(op){
    var ov=typeof op==='object'?op.v:op, ol=typeof op==='object'?op.l:op;
    return '<option value="'+ov+'"'+(String(ov)===String(val)?' selected':'')+'>'+ol+'</option>';
  }).join('');
  return '<select id="'+id+'" style="background:var(--bg3);border:1px solid var(--bord2);color:var(--txt);border-radius:7px;padding:9px 11px;font-size:13px;font-family:inherit;outline:none;width:100%">'+o+'</select>';
}
function mInp(id,tp,val,ph){
  var v=String(val==null?'':val).replace(/"/g,'&quot;');
  return '<input id="'+id+'" type="'+tp+'" value="'+v+'" placeholder="'+(ph||'')+'" style="background:var(--bg3);border:1px solid var(--bord2);color:var(--txt);border-radius:7px;padding:9px 11px;font-size:13px;font-family:inherit;outline:none;width:100%">';
}
function fg2(l,i){return '<div class="fg"><label>'+l+'</label>'+i+'</div>';}
var MESESL=[{v:1,l:'Enero'},{v:2,l:'Febrero'},{v:3,l:'Marzo'},{v:4,l:'Abril'},{v:5,l:'Mayo'},{v:6,l:'Junio'},{v:7,l:'Julio'},{v:8,l:'Agosto'},{v:9,l:'Septiembre'},{v:10,l:'Octubre'},{v:11,l:'Noviembre'},{v:12,l:'Diciembre'}];
var E2=['San Nicolás','Renacimiento'], E3=['San Nicolás','Renacimiento','Cocheria'];
var ES=['cobrado','pendiente','anulado'];
var TI=['ING. FACTURAS','ING. POSNET','ING. TRANSFERENCIA','ING. TICKET','DEPOSITO','EGRESO','CIERRE DIA'];

function openEdit(t,r){
  editType=t;editRec=r;
  var h='';
  if(t==='cobro'){
    h='<div class="fgrid">'+fg2('Fecha',mInp('ef-fec','date',r.fecha))+fg2('Localidad',mInp('ef-loc','text',r.localidad))+fg2('Socio',mInp('ef-soc','text',r.socio))+fg2('Mes',mSel('ef-mes',MESESL,r.mes))+fg2('Importe',mInp('ef-imp','text',r.importe,'33.000'))+fg2('Factura',mInp('ef-fac','text',r.factura))+fg2('Cobrador',mInp('ef-cob','text',r.cobrador))+fg2('Empresa',mSel('ef-emp',E2,r.empresa))+fg2('Estado',mSel('ef-est',ES,r.estado))+fg2('Obs',mInp('ef-obs','text',r.obs))+'</div>';
  } else if(t==='ticket'){
    h='<div class="fgrid">'+fg2('Fecha',mInp('ef-fec','date',r.fecha))+fg2('Localidad',mInp('ef-loc','text',r.localidad))+fg2('Socio',mInp('ef-soc','text',r.socio))+fg2('Mes',mSel('ef-mes',MESESL,r.mes))+fg2('Importe',mInp('ef-imp','text',r.importe,'28.000'))+fg2('Ticket',mInp('ef-tic','text',r.ticket))+fg2('Motivo',mInp('ef-mot','text',r.motivo))+fg2('Empresa',mSel('ef-emp',E2,r.empresa))+'</div>';
  } else {
    h='<div class="fgrid">'+fg2('Fecha',mInp('ef-fec','date',r.fecha))+fg2('Localidad',mInp('ef-loc','text',r.localidad))+fg2('Empresa',mSel('ef-emp',E3,r.empresa))+fg2('Tipo',mSel('ef-tip',TI,r.tipo))+fg2('Importe',mInp('ef-imp','text',r.importe,'1.078.500'))+fg2('Banco',mInp('ef-ban','text',r.banco))+fg2('Flujo',mSel('ef-flu',['ingreso','egreso'],r.flujo))+fg2('Obs',mInp('ef-obs','text',r.obs))+'</div>';
  }
  el('etit').textContent='Editar '+t+' - Socio: '+(r.socio||'');
  el('efields').innerHTML=h;
  showOv('ovedit');
}

function saveEdit(){
  if(!editRec||!editType)return;
  var btn=el('e-sav');if(btn){btn.disabled=true;btn.textContent='Guardando...';}
  var imp=parseImp((el('ef-imp')||{}).value||'');
  var u={fecha:(el('ef-fec')||{}).value||editRec.fecha,localidad:(el('ef-loc')||{}).value||editRec.localidad,importe:isNaN(imp)?editRec.importe:imp};
  if(editType==='cobro'){u.socio=(el('ef-soc')||{}).value||editRec.socio;u.mes=+((el('ef-mes')||{}).value||editRec.mes);u.factura=(el('ef-fac')||{}).value||null;u.cobrador=(el('ef-cob')||{}).value||null;u.empresa=(el('ef-emp')||{}).value;u.estado=(el('ef-est')||{}).value;u.obs=(el('ef-obs')||{}).value||null;}
  else if(editType==='ticket'){u.socio=(el('ef-soc')||{}).value||editRec.socio;u.mes=+((el('ef-mes')||{}).value||editRec.mes);u.ticket=(el('ef-tic')||{}).value||null;u.motivo=(el('ef-mot')||{}).value||null;u.empresa=(el('ef-emp')||{}).value;}
  else{u.empresa=(el('ef-emp')||{}).value;u.tipo=(el('ef-tip')||{}).value;u.banco=(el('ef-ban')||{}).value||null;u.flujo=(el('ef-flu')||{}).value;u.obs=(el('ef-obs')||{}).value||null;}
  var tbl=editType==='cobro'?'cobros':editType==='ticket'?'tickets':'caja_movimientos';
  SB.from(tbl).update(u).eq('id',editRec.id).then(function(r){
    if(btn){btn.disabled=false;btn.textContent='Guardar';}
    if(r.error){showSB('Error: '+diagErr(r.error),'error',8000);return;}
    var arr=editType==='cobro'?cobros:editType==='ticket'?tickets:cajaMov;
    for(var i=0;i<arr.length;i++){if(arr[i].id===editRec.id){for(var k in u)arr[i][k]=u[k];break;}}
    hideOv('ovedit');
    if(editType==='cobro')renderCobros();else if(editType==='ticket')renderTickets();else renderCaja();
    if(curPage==='dashboard')refreshDashboard();
    showSB('Actualizado','success');
  }).catch(function(e){if(btn){btn.disabled=false;btn.textContent='Guardar';}showSB('Error: '+diagErr(e),'error',8000);});
}

function askDel(t,id){pendDel.t=t;pendDel.id=id;showOv('ovdel');}
function confirmDel(){
  var tbl=pendDel.t==='cobro'?'cobros':pendDel.t==='ticket'?'tickets':'caja_movimientos';
  hideOv('ovdel');
  SB.from(tbl).delete().eq('id',pendDel.id).then(function(r){
    if(r.error){showSB('Error: '+diagErr(r.error),'error');return;}
    if(pendDel.t==='cobro')cobros=cobros.filter(function(x){return x.id!==pendDel.id;});
    else if(pendDel.t==='ticket')tickets=tickets.filter(function(x){return x.id!==pendDel.id;});
    else cajaMov=cajaMov.filter(function(x){return x.id!==pendDel.id;});
    if(pendDel.t==='cobro')renderCobros();else if(pendDel.t==='ticket')renderTickets();else renderCaja();
    if(curPage==='dashboard')refreshDashboard();
    showSB('Eliminado','success');
  }).catch(function(e){showSB('Error: '+diagErr(e),'error');});
}

function openEditUser(uid){
  if(!CU||CU.rol!=='admin_central'){
    showSB('Solo el admin central puede editar usuarios','error');
    return;
  }
  var u=null;
  for(var i=0;i<usuarios.length;i++){if(usuarios[i].id===uid){u=usuarios[i];break;}}
  if(!u)return;
  editUID=uid;
  el('eu-tit').textContent='Editar usuario '+u.numero+' - '+u.nombre;
  sv('eu-nom',u.nombre);sv('eu-loc',u.localidad||'');sv('eu-pin','');sv('eu-act',u.activo?'true':'false');
  showOv('oveu');
}
function saveUser(){
  if(!CU||CU.rol!=='admin_central'){
    showSB('Solo el admin central puede modificar usuarios','error');
    return;
  }
  var nom=gv('eu-nom').trim(), loc=gv('eu-loc').trim(), pin=gv('eu-pin').trim(), act=gv('eu-act')==='true';
  if(!nom){showSB('Nombre requerido','error');return;}
  var upd={nombre:nom,localidad:loc||'',activo:act};
  if(pin)upd.pin=pin;
  SB.from('usuarios').update(upd).eq('id',editUID).then(function(r){
    if(r.error){showSB('Error: '+diagErr(r.error),'error');return;}
    for(var i=0;i<usuarios.length;i++){if(usuarios[i].id===editUID){for(var k in upd)usuarios[i][k]=upd[k];break;}}
    hideOv('oveu');renderUsuarios();showSB('Usuario actualizado','success');
  }).catch(function(e){showSB('Error: '+diagErr(e),'error');});
}
function renderPlanilla(){
  if(!CU)return;
  // Default to today if not set
  var fechaInput=el('pl-fecha');
  if(fechaInput&&!fechaInput.value){fechaInput.value=today();}
  var fecha=fechaInput?fechaInput.value:today();

  // Get ALL records for the selected date (cobradores' + own)
  var allPend = [];
  function addPend(arr,tabla){
    dedup(arr).filter(function(r){return r.fecha===fecha;})
      .forEach(function(r){allPend.push({rec:r,tabla:tabla});});
  }
  addPend(cobros,'cobros');
  addPend(tickets,'tickets');
  addPend(cajaMov,'caja_movimientos');

  // Sort by date asc
  allPend.sort(function(a,b){return new Date(a.rec.created_at)-new Date(b.rec.created_at);});

  // Compute totals
  var totC=0,cntC=0,totT=0,cntT=0,totK=0,cntK=0;
  allPend.forEach(function(p){
    var v=+p.rec.importe||0;
    if(p.tabla==='cobros'){totC+=v;cntC++;}
    else if(p.tabla==='tickets'){totT+=v;cntT++;}
    else {totK+=v;cntK++;}
  });

  function st(id,v){var e=el(id);if(e)e.textContent=v;}
  st('pl-total',fmt(totC+totT+totK));
  st('pl-cant',allPend.length+' registros');
  st('pl-cobros-total',fmt(totC));st('pl-cobros-cant',cntC+' registros');
  st('pl-tickets-total',fmt(totT));st('pl-tickets-cant',cntT+' registros');
  st('pl-caja-total',fmt(totK));st('pl-caja-cant',cntK+' registros');
  st('pl-meta',allPend.length+' registros pendientes — Total: '+fmt(totC+totT+totK));
  st('pl-total-foot',fmt(totC+totT+totK));

  // Update sidebar badge
  var pbadge=el('planilla-badge');
  if(pbadge){
    pbadge.textContent=allPend.length>9?'9+':String(allPend.length);
    pbadge.style.display=allPend.length>0?'inline-block':'none';
  }

  // Disable button if empty
  var btn=el('pl-enviar-btn');
  if(btn){
    btn.disabled=!allPend.length;
    btn.style.opacity=allPend.length?'1':'.5';
    btn.textContent=allPend.length?('Enviar '+allPend.length+' registros al admin de zona'):'Sin registros para enviar';
  }

  var tb=el('tb-planilla');if(!tb)return;
  if(!allPend.length){
    tb.innerHTML='<tr class="erow"><td colspan="8">No hay registros pendientes. Carga un cobro, ticket o movimiento de caja para empezar.</td></tr>';
    return;
  }
  tb.innerHTML=allPend.map(function(p){
    var r=p.rec, t=p.tabla;
    var tipoBadge=t==='cobros'?'<span class="badge bgn">Cobro</span>':
                  t==='tickets'?'<span class="badge brd">Ticket</span>':
                  '<span class="badge bam">Caja</span>';
    var quien=r.usuario_nombre||'-';
    var detalle=r.socio||r.tipo||'-';
    return '<tr>'
      +'<td style="font-size:10px">'+fmtF(r.fecha)+'</td>'
      +'<td>'+tipoBadge+'</td>'
      +'<td><span class="badge bbl" style="font-size:9px">'+quien+'</span></td>'
      +'<td><strong>'+detalle+'</strong>'+(r.factura?' <span style="color:var(--txt3);font-size:10px">F:'+r.factura+'</span>':'')+'</td>'
      +'<td>'+(r.mes?fmtM(r.mes):'-')+'</td>'
      +'<td style="font-size:11px">'+(r.empresa||'-')+'</td>'
      +'<td class="num" style="color:var(--green)">'+fmt(r.importe)+'</td>'
      +'<td><span class="badge bam">Pendiente</span></td>'
      +'</tr>';
  }).join('');
}

function enviarPlanilla(){
  var fecha=gv('pl-fecha')||today();
  // Only pendiente records for this date and this agency's locality
  var allReg=[];
  function add(arr,tabla){
    dedup(arr).filter(function(r){
      return r.fecha===fecha && r.estado_revision==='pendiente' && r.localidad===CU.localidad;
    }).forEach(function(r){allReg.push({rec:r,tabla:tabla});});
  }
  add(cobros,'cobros');add(tickets,'tickets');add(cajaMov,'caja_movimientos');

  if(!allReg.length){showSB('No hay registros pendientes para la fecha '+fmtF(fecha),'info');return;}

  if(!confirm('Enviar '+allReg.length+' registros del '+fmtF(fecha)+' al administrador de zona?')){return;}

  var btn=el('pl-enviar-btn');
  if(btn){btn.disabled=true;btn.textContent='Enviando...';}

  var totC=0,cntC=0,totT=0,cntT=0,totK=0,cntK=0;
  var idsC=[],idsT=[],idsK=[];
  allReg.forEach(function(p){
    var v=+p.rec.importe||0;
    if(p.tabla==='cobros'){totC+=v;cntC++;idsC.push(p.rec.id);}
    else if(p.tabla==='tickets'){totT+=v;cntT++;idsT.push(p.rec.id);}
    else {totK+=v;cntK++;idsK.push(p.rec.id);}
  });
  var neto=totC-totT;
  var resumen='Cobros: '+cntC+' ('+fmt(totC)+') | Tickets: '+cntT+' ('+fmt(totT)+') | Caja: '+cntK+' ('+fmt(totK)+') | Neto: '+fmt(neto);

  // 1. Create cierre record in cierres_diarios
  var cierreRow={
    fecha:fecha,
    agencia_id:CU.id,
    agencia_numero:CU.numero,
    localidad:CU.localidad,
    zona:CU.zona,
    cobros_cant:cntC, cobros_total:totC,
    tickets_cant:cntT, tickets_total:totT,
    caja_cant:cntK, caja_total:totK,
    neto:neto,
    estado:'enviado',
    enviado_por:CU.nombre,
    registros_ids:{cobros:idsC,tickets:idsT,caja:idsK}
  };

  SB.from('cierres_diarios').insert([cierreRow]).select().then(function(rCierre){
    if(rCierre.error){
      if(btn){btn.disabled=false;btn.textContent='Enviar cierre del día';}
      showSB('Error al crear cierre: '+diagErr(rCierre.error)+' — Ejecutaste supabase_cobradores.sql v5.6?','error',10000);
      return;
    }
    var cierreId=rCierre.data&&rCierre.data[0]?rCierre.data[0].id:null;

    // 2. Send notification to admin_zona + admin_central
    var notifs=[
      {para_rol:'admin_zona',para_zona:CU.zona,tipo:'pendiente',
       titulo:'Cierre '+fmtF(fecha)+' — '+CU.localidad,
       mensaje:resumen,tabla_origen:'cierres_diarios',registro_id:cierreId,leida:false},
      {para_rol:'admin_central',para_zona:0,tipo:'pendiente',
       titulo:'Cierre '+fmtF(fecha)+' — '+CU.localidad,
       mensaje:resumen,tabla_origen:'cierres_diarios',registro_id:cierreId,leida:false}
    ];

    SB.from('notificaciones').insert(notifs).then(function(r){
      if(btn){btn.disabled=false;btn.textContent='Enviar cierre del día';}
      if(r.error){showSB('Cierre creado pero error en notif: '+diagErr(r.error),'error');return;}
      showSB('Cierre del '+fmtF(fecha)+' enviado al admin — Neto '+fmt(neto)+' ('+allReg.length+' registros)','success',8000);
      // Refresh data
      loadAll();
    }).catch(function(e){
      if(btn){btn.disabled=false;btn.textContent='Enviar cierre del día';}
      showSB('Error: '+diagErr(e),'error');
    });
  }).catch(function(e){
    if(btn){btn.disabled=false;btn.textContent='Enviar cierre del día';}
    showSB('Error: '+diagErr(e),'error');
  });
}

function exportPlanillaCSV(){
  var allPend = [];
  function addPend(arr,tabla){
    dedup(arr).filter(function(r){return r.estado_revision==='pendiente';})
      .forEach(function(r){allPend.push({rec:r,tabla:tabla});});
  }
  addPend(cobros,'cobros');
  addPend(tickets,'tickets');
  addPend(cajaMov,'caja_movimientos');
  function esc(v){var s=String(v==null?'':v);return(s.indexOf(',')>=0||s.indexOf('"')>=0)?'"'+s.replace(/"/g,'""')+'"':s;}
  var csv='fecha,tipo,cobrador,socio,mes,empresa,importe,localidad\n';
  csv+=allPend.map(function(p){
    var t=p.tabla==='cobros'?'Cobro':p.tabla==='tickets'?'Ticket':'Caja';
    return [p.rec.fecha,t,p.rec.usuario_nombre||'',p.rec.socio||p.rec.tipo||'',p.rec.mes||'',p.rec.empresa||'',p.rec.importe,p.rec.localidad].map(esc).join(',');
  }).join('\n');
  var nombre='Planilla_'+(CU?CU.localidad:'')+'_'+today().replace(/-/g,'')+'.csv';
  guardarArchivo(nombre, '\ufeff'+csv, 'text/csv;charset=utf-8;');
}

function renderPendientesCob(){
  // Show cobrador records pending approval visible to the agency
  if(!SB||!isConn||!CU)return;
  var pend=dedup(cobros.concat(tickets).concat(cajaMov)).filter(function(r){
    return r.estado_revision==='pendiente';
  });
  // Only show records from cobradores (not from agencia itself)
  // A cobrador record has usuario_numero >= 25
  var cobPend=pend.filter(function(r){return (r.usuario_numero||0)>=25;});

  var meta=el('mc-pend-meta');
  var btn=el('mc-btn-enviar');
  if(meta)meta.textContent=cobPend.length+' registros de cobradores pendientes';
  if(btn)btn.style.display=cobPend.length?'':'none';

  var tb=el('tb-mc-pend');if(!tb)return;
  if(!cobPend.length){
    tb.innerHTML='<tr class="erow"><td colspan="6">Sin registros pendientes de cobradores</td></tr>';
    return;
  }
  tb.innerHTML=cobPend.map(function(r){
    var tipo=cobros.find(function(x){return x.id===r.id;})?'Cobro':
             tickets.find(function(x){return x.id===r.id;})?'Ticket':'Caja';
    var desc=r.socio||(r.tipo)||'-';
    return '<tr>'
      +'<td style="font-size:10px">'+fmtF(r.fecha)+'</td>'
      +'<td><span class="badge bbl" style="font-size:9px">'+(r.usuario_nombre||'-')+'</span></td>'
      +'<td><span class="badge '+(tipo==='Cobro'?'bgn':tipo==='Ticket'?'brd':'bam')+'">'+tipo+'</span></td>'
      +'<td><strong>'+desc+'</strong></td>'
      +'<td class="num" style="color:var(--green)">'+fmt(r.importe)+'</td>'
      +'<td style="font-size:11px">'+r.empresa+'</td>'
      +'</tr>';
  }).join('');
}

function enviarPendientesCobradoresAlAdmin(){
  var pend=dedup(cobros.concat(tickets).concat(cajaMov)).filter(function(r){
    return r.estado_revision==='pendiente'&&(r.usuario_numero||0)>=25;
  });
  if(!pend.length){showSB('No hay registros pendientes de cobradores','info');return;}
  var btn=el('mc-btn-enviar');
  if(btn){btn.disabled=true;btn.textContent='Enviando...';}
  // Records are already in DB as 'pendiente' - just send notifications to zone admin
  var tipoLabel={'cobros':'cobro','tickets':'ticket','caja_movimientos':'movimiento de caja'};
  var notifs=[];
  pend.forEach(function(r){
    var tbl=cobros.find(function(x){return x.id===r.id;})?'cobros':
            tickets.find(function(x){return x.id===r.id;})?'tickets':'caja_movimientos';
    notifs.push({
      para_rol:'admin_zona',para_zona:CU.zona,tipo:'pendiente',
      titulo:'Agencia '+CU.nombre+': '+(tipoLabel[tbl]||'registro')+' de cobrador',
      mensaje:(r.usuario_nombre||'Cobrador')+' - $'+fmt(r.importe).replace('$','')+' - '+fmtF(r.fecha),
      tabla_origen:tbl,registro_id:r.id,leida:false
    });
    notifs.push({
      para_rol:'admin_central',para_zona:0,tipo:'pendiente',
      titulo:'Agencia '+CU.nombre+': '+(tipoLabel[tbl]||'registro')+' de cobrador',
      mensaje:(r.usuario_nombre||'Cobrador')+' - $'+fmt(r.importe).replace('$','')+' - '+fmtF(r.fecha),
      tabla_origen:tbl,registro_id:r.id,leida:false
    });
  });
  SB.from('notificaciones').insert(notifs).then(function(r){
    if(btn){btn.disabled=false;btn.textContent='Enviar al admin de zona';}
    if(r.error){showSB('Error: '+diagErr(r.error),'error');return;}
    showSB(pend.length+' registros enviados al administrador de zona para aprobacion','success',6000);
  }).catch(function(e){
    if(btn){btn.disabled=false;btn.textContent='Enviar al admin de zona';}
    showSB('Error: '+diagErr(e),'error');
  });
}

function renderMisCobradores(){
  if(!SB||!isConn||!CU)return;
  // Load cobradores list
  SB.from('usuarios').select('*')
    .eq('rol','cobrador')
    .eq('agencia_numero',CU.numero)
    .order('numero')
    .then(function(r){
      if(r.error){showSB('Error: '+diagErr(r.error),'error');return;}
      var list=r.data||[];
      var meta=el('mc-meta');if(meta)meta.textContent=list.length+' cobradores registrados';
      // Populate cobrador filter
      var fsel=el('fc-cobrador');
      if(fsel&&fsel.options.length<=1){
        list.forEach(function(u){
          var o=document.createElement('option');
          o.value=u.nombre;o.textContent=u.nombre+'  (#'+u.numero+')';
          fsel.appendChild(o);
        });
      }
      var tb=el('tb-mc');if(!tb)return;
      if(!list.length){
        tb.innerHTML='<tr class="erow"><td colspan="5">No hay cobradores en esta agencia</td></tr>';
      } else {
        tb.innerHTML=list.map(function(u){
          return '<tr>'
            +'<td><span class="badge bbl">#'+u.numero+'</span></td>'
            +'<td><strong>'+u.nombre+'</strong></td>'
            +'<td><span class="badge '+(u.zona===1?'bbl':'bpu2')+'">Zona '+u.zona+'</span></td>'
            +'<td>'+(u.activo?'<span class="badge bgn">Activo</span>':'<span class="badge brd">Inactivo</span>')+'</td>'
            +'<td class="no-print" style="color:var(--txt3);font-size:11px">Solo admin central</td>'
            +'</tr>';
        }).join('');
      }
    }).catch(function(e){showSB('Error: '+diagErr(e),'error');});
  // Also render cobros filtered
  renderCobrosAgencia();
  renderPendientesCob();
}

function renderCobrosAgencia(){
  if(!SB||!isConn||!CU)return;
  var fD=gv('fc-desde'), fH=gv('fc-hasta');
  var fCob=gv('fc-cobrador'), fSoc=gv('fc-socio').toLowerCase();
  var fMes=gv('fc-mes'), fEmp=gv('fc-empresa');

  // Get ALL cobros for this agencia's localidad+zona (includes cobradores)
  var allCobros=dedup(cobros).filter(function(r){
    if(fD&&r.fecha<fD)return false;
    if(fH&&r.fecha>fH)return false;
    if(fCob&&r.cobrador!==fCob)return false;
    if(fSoc&&(r.socio||'').toLowerCase().indexOf(fSoc)<0)return false;
    if(fMes&&+r.mes!==+fMes)return false;
    if(fEmp&&r.empresa!==fEmp)return false;
    return true;
  });
  var allTickets=dedup(tickets).filter(function(r){
    if(fD&&r.fecha<fD)return false;
    if(fH&&r.fecha>fH)return false;
    return true;
  });

  var tc=allCobros.reduce(function(s,r){return s+(+r.importe||0);},0);
  var tt=allTickets.reduce(function(s,r){return s+(+r.importe||0);},0);
  var socios=allCobros.map(function(r){return r.socio;}).filter(function(s,i,a){return a.indexOf(s)===i;}).length;

  function st(id,v){var e=el(id);if(e)e.textContent=v;}
  st('mc-tc',fmt(tc));st('mc-tcs',allCobros.length+' facturas');
  st('mc-tt',fmt(tt));st('mc-tts',allTickets.length+' devueltos');
  st('mc-nt',fmt(tc-tt));
  st('mc-soc',socios);

  // Cobros table
  var tb=el('tb-mc-cobros');
  if(tb){
    if(!allCobros.length){
      tb.innerHTML='<tr class="erow"><td colspan="8">Sin cobros para los filtros</td></tr>';
    } else {
      tb.innerHTML=allCobros.map(function(r){
        return '<tr>'
          +'<td style="font-size:10px">'+fmtF(r.fecha)+'</td>'
          +'<td><span class="badge bbl" style="font-size:9px">'+(r.cobrador||'-')+'</span></td>'
          +'<td><strong>'+r.socio+'</strong></td>'
          +'<td>'+fmtM(r.mes)+'</td>'
          +'<td style="font-size:11px">'+r.empresa+'</td>'
          +'<td class="num" style="color:var(--green)">'+fmt(r.importe)+'</td>'
          +'<td><span class="badge bbl" style="font-size:9px">'+(r.factura||'-')+'</span></td>'
          +'<td>'+bdg(r.estado)+'</td>'
          +'</tr>';
      }).join('');
    }
    st('mc-total',fmt(tc));
    st('mc-cobros-meta',allCobros.length+' cobros - Total: '+fmt(tc));
  }

  // Resumen por cobrador
  var byC={};
  allCobros.forEach(function(r){
    var k=r.cobrador||r.usuario_nombre||'Sin nombre';
    if(!byC[k])byC[k]={nom:k,c:0,tc:0,socios:[]};
    byC[k].c++;byC[k].tc+=(+r.importe||0);
    if(r.socio&&byC[k].socios.indexOf(r.socio)<0)byC[k].socios.push(r.socio);
  });
  var tkt={};
  dedup(tickets).forEach(function(r){
    var k=r.usuario_nombre||'Sin nombre';
    if(!tkt[k])tkt[k]={t:0,tt:0};
    tkt[k].t++;tkt[k].tt+=(+r.importe||0);
  });
  var sorted2=Object.values(byC).sort(function(a,b){return b.tc-a.tc;});
  var tbR=el('tb-mc-resumen');
  if(tbR){
    if(!sorted2.length){
      tbR.innerHTML='<tr class="erow"><td colspan="7">Sin datos</td></tr>';
    } else {
      tbR.innerHTML=sorted2.map(function(u){
        var tk=tkt[u.nom]||{t:0,tt:0};
        return '<tr>'
          +'<td><strong>'+u.nom+'</strong></td>'
          +'<td>'+u.c+'</td>'
          +'<td>'+u.socios.length+'</td>'
          +'<td class="num" style="color:var(--green)">'+fmt(u.tc)+'</td>'
          +'<td>'+tk.t+'</td>'
          +'<td class="num" style="color:var(--red)">'+fmt(tk.tt)+'</td>'
          +'<td class="num" style="color:var(--purple);font-weight:700">'+fmt(u.tc-tk.tt)+'</td>'
          +'</tr>';
      }).join('');
    }
  }
}

function clearFiltrosCob(){
  ['fc-desde','fc-hasta','fc-socio'].forEach(function(i){sv(i,'');});
  ['fc-cobrador','fc-mes','fc-empresa'].forEach(function(i){var e=el(i);if(e)e.selectedIndex=0;});
  // Reset cobrador dropdown
  var s=el('fc-cobrador');if(s){while(s.options.length>1)s.remove(1);}
  renderMisCobradores();
}

function printMisCobradores(){
  var fD=gv('fc-desde'),fH=gv('fc-hasta'),fCob=gv('fc-cobrador');
  var pg=el('page-mis-cobradores');if(!pg)return;
  var pw=window.open('','_blank','width=900,height=700');
  if(!pw){alert('Habilita los pop-ups e intenta de nuevo');return;}
  pw.document.write('<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>Cobros - '+CU.localidad+'</title>');
  pw.document.write('<style>');
  pw.document.write('*{box-sizing:border-box;margin:0;padding:0}body{font-family:Arial,sans-serif;font-size:10pt;color:#000;background:#fff;padding:1.5cm}');
  pw.document.write('h1{font-size:16pt;margin-bottom:4px}p{font-size:10pt;color:#555;margin-bottom:16px}');
  pw.document.write('table{width:100%;border-collapse:collapse;margin-top:12px;font-size:9pt}');
  pw.document.write('thead th{background:#2c3e50;color:#fff;padding:7px 9px;text-align:left;border:1px solid #2c3e50}');
  pw.document.write('tbody td{padding:6px 9px;border:1px solid #ddd}tbody tr:nth-child(even) td{background:#f9f9f9}');
  pw.document.write('tfoot td{padding:6px 9px;border:1px solid #bbb;background:#eee;font-weight:bold}');
  pw.document.write('.kgrid{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin-bottom:14px}');
  pw.document.write('.kpi{border:1px solid #ccc;border-radius:4px;padding:10px;background:#f9f9f9}');
  pw.document.write('.kl{font-size:8pt;font-weight:bold;text-transform:uppercase;color:#555;margin-bottom:3px}');
  pw.document.write('.kv{font-size:14pt;font-weight:bold;color:#000}.ks{font-size:8pt;color:#555}');
  pw.document.write('.num{text-align:right}.no-print,.btn,.ab,.cctrl,.alr,.fa,.div,.ov{display:none!important}');
  pw.document.write('.card{border:1px solid #ccc;border-radius:4px;overflow:hidden;margin-bottom:12px}');
  pw.document.write('.ch{background:#f5f5f5;padding:8px 12px;border-bottom:1px solid #ccc}');
  pw.document.write('.ct2{font-size:12pt;font-weight:bold}.cm{font-size:9pt;color:#555;margin-top:2px}');
  pw.document.write('.badge{display:inline-block;padding:2px 6px;border-radius:3px;font-size:8pt;border:1px solid #999;background:#eee;color:#333}');
  pw.document.write('@page{margin:1.5cm;size:A4}');
  pw.document.write('</style></head><body>');
  var periodo=(fD||'inicio')+' al '+(fH||'hoy');
  var cob2=fCob||'Todos los cobradores';
  pw.document.write('<h1>Cobros - '+CU.localidad+'</h1>');
  pw.document.write('<p>'+new Date().toLocaleDateString('es-AR',{day:'2-digit',month:'long',year:'numeric'})+' &nbsp;|&nbsp; '+periodo+' &nbsp;|&nbsp; '+cob2+'</p>');
  pw.document.write(pg.innerHTML);
  pw.document.write('</body></html>');
  pw.document.close();
  pw.focus();
  setTimeout(function(){pw.print();},600);
}

function exportCobrosAgenciaXLSX(){
  var fD=gv('fc-desde'),fH=gv('fc-hasta'),fCob=gv('fc-cobrador'),fSoc=gv('fc-socio').toLowerCase(),fMes=gv('fc-mes'),fEmp=gv('fc-empresa');
  var rows=dedup(cobros).filter(function(r){
    if(fD&&r.fecha<fD)return false;if(fH&&r.fecha>fH)return false;
    if(fCob&&r.cobrador!==fCob)return false;if(fSoc&&(r.socio||'').toLowerCase().indexOf(fSoc)<0)return false;
    if(fMes&&+r.mes!==+fMes)return false;if(fEmp&&r.empresa!==fEmp)return false;return true;
  });
  var datos=[['Fecha','Cobrador','Socio','Mes','Empresa','Importe','Factura','Estado']];
  rows.forEach(function(r){datos.push([r.fecha,r.cobrador||'',r.socio,r.mes,r.empresa,+r.importe,r.factura||'',r.estado]);});
  exportarComoXLSX(datos,'Cobros_'+(CU.localidad||'Agencia'),'Cobros');
}

function exportCobrosAgenciaCSV(){
  var fD=gv('fc-desde'),fH=gv('fc-hasta'),fCob=gv('fc-cobrador');
  var fSoc=gv('fc-socio').toLowerCase(),fMes=gv('fc-mes'),fEmp=gv('fc-empresa');
  var rows=dedup(cobros).filter(function(r){
    if(fD&&r.fecha<fD)return false;
    if(fH&&r.fecha>fH)return false;
    if(fCob&&r.cobrador!==fCob)return false;
    if(fSoc&&(r.socio||'').toLowerCase().indexOf(fSoc)<0)return false;
    if(fMes&&+r.mes!==+fMes)return false;
    if(fEmp&&r.empresa!==fEmp)return false;
    return true;
  });
  function esc(v){var s=String(v==null?'':v);return(s.indexOf(',')>=0||s.indexOf('"')>=0)?'"'+s.replace(/"/g,'""')+'"':s;}
  var csv='fecha,cobrador,socio,mes,importe,factura,empresa,estado,obs\n';
  csv+=rows.map(function(r){return[r.fecha,r.cobrador,r.socio,r.mes,r.importe,r.factura,r.empresa,r.estado,r.obs].map(esc).join(',');}).join('\n');
  var nombre='Cobros_Agencia_'+(CU?CU.localidad:'')+'_'+today().replace(/-/g,'')+'.csv';
  guardarArchivo(nombre, '﻿'+csv, 'text/csv;charset=utf-8;');
}

function renderUsuarios(){
  // Solo el admin central puede ver usuarios y PINs
  if(!CU||CU.rol!=='admin_central'){
    var tbX=el('tb-us');if(tbX)tbX.innerHTML='<tr class="erow"><td colspan="6">Acceso restringido — solo el admin central puede ver usuarios</td></tr>';
    showSB('Acceso restringido','error');
    go('dashboard');
    return;
  }
  var tb=el('tb-us');if(!tb)return;
  tb.innerHTML=usuarios.map(function(u){
    return '<tr>'
      +'<td><span class="badge '+(u.numero===0?'bam':'bbl')+'">'+(u.numero===0?'ADM':u.numero)+'</span></td>'
      +'<td><strong>'+u.nombre+'</strong></td>'
      +'<td style="color:var(--txt2)">'+(u.localidad||'-')+'</td>'
      +'<td>'+u.rol+'</td>'
      +'<td>'+(u.activo?'<span class="badge bgn">Si</span>':'<span class="badge brd">No</span>')+'</td>'
      +'<td class="no-print"><button class="ab ae" onclick="openEditUser(\''+u.id+'\')">Editar</button></td>'
      +'</tr>';
  }).join('');
}

function dedup(arr){
  var seen={};
  return arr.filter(function(r){if(!r||!r.id||seen[r.id])return false;seen[r.id]=true;return true;});
}

function renderCobros(){
  var q=gv('sc').toLowerCase(), mes=gv('fm'), est=gv('fe');
  var isA=window._isAdmin;
  var rows=dedup(cobros).filter(function(r){
    return (!q||(r.socio||'').toLowerCase().indexOf(q)>=0||(r.factura||'').indexOf(q)>=0||(r.cobrador||'').toLowerCase().indexOf(q)>=0)
      &&(!mes||+r.mes===+mes)&&(!est||r.estado===est);
  });
  var tb=el('tb-cobros');if(!tb)return;
  if(!rows.length){tb.innerHTML='<tr class="erow"><td colspan="11">No hay cobros</td></tr>';}
  else{
    tb.innerHTML=rows.map(function(r,i){
      var uh=isA?('<td><span class="badge bbl" style="font-size:9px">U'+(r.usuario_numero||'?')+'</span></td>'):'';
      var rs=JSON.stringify(r).replace(/\\/g,'\\\\').replace(/'/g,"\\'");
      return '<tr>'
        +'<td style="color:var(--txt3);font-size:10px">'+(i+1)+'</td>'
        +'<td style="font-size:10px">'+fmtF(r.fecha)+'</td>'
        +'<td><strong>'+r.socio+'</strong></td>'
        +'<td>'+fmtM(r.mes)+'</td>'
        +uh
        +'<td style="font-size:11px;color:var(--txt2)">'+(r.cobrador||'-')+'</td>'
        +'<td style="font-size:11px">'+r.empresa+'</td>'
        +'<td class="num" style="color:var(--green)">'+fmt(r.importe)+'</td>'
        +'<td><span class="badge bbl" style="font-size:9px">'+(r.factura||'-')+'</span></td>'
        +'<td>'+bdg(r.estado)+'</td>'
        +'<td class="no-print" style="white-space:nowrap"><button class="ab ae" onclick="openEdit(\'cobro\','+rs+')">Ed</button> <button class="ab ad2" onclick="askDel(\'cobro\',\''+r.id+'\')">X</button></td>'
        +'</tr>';
    }).join('');
  }
  var total=rows.reduce(function(s,r){return s+(+r.importe||0);},0);
  el('lc-total').textContent=fmt(total);
  el('lc-meta').textContent=rows.length+' registros - Total: '+fmt(total);
}

function renderTickets(){
  var isA=window._isAdmin;
  var rows=dedup(tickets);
  var tb=el('tb-tickets');if(!tb)return;
  if(!rows.length){tb.innerHTML='<tr class="erow"><td colspan="9">No hay tickets</td></tr>';}
  else{
    tb.innerHTML=rows.map(function(r){
      var uh=isA?('<td><span class="badge bbl" style="font-size:9px">U'+(r.usuario_numero||'?')+'</span></td>'):'';
      var rs=JSON.stringify(r).replace(/\\/g,'\\\\').replace(/'/g,"\\'");
      return '<tr>'
        +'<td style="font-size:10px">'+fmtF(r.fecha)+'</td>'
        +'<td><strong>'+r.socio+'</strong></td>'
        +'<td>'+fmtM(r.mes)+'</td>'
        +uh
        +'<td style="font-size:11px">'+r.empresa+'</td>'
        +'<td class="num" style="color:var(--red)">'+fmt(r.importe)+'</td>'
        +'<td><span class="badge bam">#'+(r.ticket||'-')+'</span></td>'
        +'<td style="font-size:11px;color:var(--txt2)">'+(r.motivo||'-')+'</td>'
        +'<td class="no-print" style="white-space:nowrap"><button class="ab ae" onclick="openEdit(\'ticket\','+rs+')">Ed</button> <button class="ab ad2" onclick="askDel(\'ticket\',\''+r.id+'\')">X</button></td>'
        +'</tr>';
    }).join('');
  }
  var total=rows.reduce(function(s,r){return s+(+r.importe||0);},0);
  el('lt-total').textContent=fmt(total);
  el('lt-meta').textContent=rows.length+' tickets - Total: '+fmt(total);
}

function renderCaja(){
  var emp=gv('fce'), flujo=gv('fcf');
  var isA=window._isAdmin;
  var rows=dedup(cajaMov).filter(function(r){return(!emp||r.empresa===emp)&&(!flujo||r.flujo===flujo);});
  var tb=el('tb-caja');if(!tb)return;
  if(!rows.length){tb.innerHTML='<tr class="erow"><td colspan="9">No hay movimientos</td></tr>';}
  else{
    tb.innerHTML=rows.map(function(r){
      var uh=isA?('<td><span class="badge bbl" style="font-size:9px">U'+(r.usuario_numero||'?')+'</span></td>'):'';
      var rs=JSON.stringify(r).replace(/\\/g,'\\\\').replace(/'/g,"\\'");
      return '<tr>'
        +'<td style="font-size:10px">'+fmtF(r.fecha)+'</td>'
        +'<td>'+r.empresa+'</td>'
        +'<td style="font-size:11px;color:var(--txt2)">'+(r.localidad||'-')+'</td>'
        +uh
        +'<td style="font-size:11px;color:var(--txt2)">'+r.tipo+'</td>'
        +'<td style="font-size:11px;color:var(--txt3)">'+(r.banco||'-')+'</td>'
        +'<td>'+bfl(r.flujo)+'</td>'
        +'<td class="num" style="color:'+(r.flujo==='ingreso'?'var(--green)':'var(--red)')+';">'+(r.flujo==='egreso'?'-':'')+fmt(r.importe)+'</td>'
        +'<td class="no-print" style="white-space:nowrap"><button class="ab ae" onclick="openEdit(\'caja\','+rs+')">Ed</button> <button class="ab ad2" onclick="askDel(\'caja\',\''+r.id+'\')">X</button></td>'
        +'</tr>';
    }).join('');
  }
  var neto=rows.reduce(function(s,r){return s+(r.flujo==='ingreso'?+r.importe:-r.importe);},0);
  el('lca-neto').textContent=(neto<0?'-':'')+fmt(Math.abs(neto));
  el('lca-meta').textContent=rows.length+' movimientos';
  var cs=el('csum');if(!cs)return;
  cs.innerHTML=['San Nicolás','Renacimiento','Cocheria'].map(function(e){
    var ms=cajaMov.filter(function(r){return r.empresa===e;});
    var ing=ms.filter(function(r){return r.flujo==='ingreso';}).reduce(function(s,r){return s+(+r.importe||0);},0);
    var eg=ms.filter(function(r){return r.flujo==='egreso';}).reduce(function(s,r){return s+(+r.importe||0);},0);
    return '<div class="cscard"><div style="font-size:10px;font-weight:700;text-transform:uppercase;color:var(--txt3);margin-bottom:3px">'+e+'</div>'
      +(ing?'<div style="font-size:12px;color:var(--txt3)">Ingresos</div><div style="font-size:18px;font-weight:700;color:var(--green)">'+fmt(ing)+'</div>':'')
      +(eg?'<div style="font-size:12px;color:var(--txt3);margin-top:4px">Egresos</div><div style="font-size:18px;font-weight:700;color:var(--red)">'+fmt(eg)+'</div>':'')
      +(!ing&&!eg?'<div style="font-size:18px;font-weight:700;color:var(--txt3)">$0</div>':'')
      +'</div>';
  }).join('');
}

function refreshDashboard(){
  var tc=dedup(cobros).reduce(function(s,r){return s+(+r.importe||0);},0);
  var tt=dedup(tickets).reduce(function(s,r){return s+(+r.importe||0);},0);
  var sn=cajaMov.filter(function(r){return r.empresa==='San Nicolás'&&r.flujo==='ingreso';}).reduce(function(s,r){return s+(+r.importe||0);},0);
  var ren=cajaMov.filter(function(r){return r.empresa==='Renacimiento'&&r.flujo==='egreso';}).reduce(function(s,r){return s+(+r.importe||0);},0);
  var net=cajaMov.filter(function(r){return r.empresa==='Cocheria';}).reduce(function(s,r){return s+(+r.importe||0);},0);
  var mx=Math.max(tc,sn,ren,net,1);
  function st(id,v){var e=el(id);if(e)e.textContent=v;}
  st('k-sn',fmt(sn));st('k-ren',fmt(ren));st('k-net',fmt(net));
  st('k-cob',fmt(tc));st('k-cobs',dedup(cobros).length+' facturas');
  st('k-tick',fmt(tt));st('k-ticks',dedup(tickets).length+' tickets');
  st('k-neto',fmt(tc-tt));
  function bar(id,v){var e=el(id);if(e)e.style.width=Math.round(v/mx*100)+'%';}
  bar('kf-sn',sn);bar('kf-ren',ren);bar('kf-net',net);
  var isA=window._isAdmin;
  var tb=el('tb-rec');if(!tb)return;
  var rec=dedup(cobros).slice(0,10);
  if(!rec.length)tb.innerHTML='<tr class="erow"><td colspan="8">Sin cobros</td></tr>';
  else tb.innerHTML=rec.map(function(r){
    var uh=isA?('<td style="font-size:10px;color:var(--txt2)">'+(r.usuario_nombre||'-')+'</td>'):'';
    return '<tr>'
      +'<td><strong>'+r.socio+'</strong></td>'
      +'<td>'+fmtM(r.mes)+'</td>'
      +'<td style="font-size:10px;color:var(--txt2)">'+(r.localidad||'-')+'</td>'
      +uh
      +'<td style="font-size:10px;color:var(--txt2)">'+(r.cobrador||'-')+'</td>'
      +'<td class="num" style="color:var(--green)">'+fmt(r.importe)+'</td>'
      +'<td><span class="badge bbl" style="font-size:9px">'+(r.factura||'-')+'</span></td>'
      +'<td>'+bdg(r.estado)+'</td>'
      +'</tr>';
  }).join('');
  buildCharts();
}

function buildCharts(){
  Chart.defaults.color='#8e99b5';
  var cl=['#3d8ef8','#2ec98a','#f59e0b','#f05252','#a78bfa','#38bdf8','#fb923c'];
  var dist={};dedup(cobros).forEach(function(r){var k=fmt(r.importe);dist[k]=(dist[k]||0)+1;});
  if(charts.dist)charts.dist.destroy();
  var cd=el('ch-dist');
  if(cd&&Object.keys(dist).length)charts.dist=new Chart(cd,{type:'doughnut',data:{labels:Object.keys(dist),datasets:[{data:Object.values(dist),backgroundColor:cl.slice(0,Object.keys(dist).length),borderWidth:0}]},options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{position:'right',labels:{color:'#8e99b5',font:{size:9},boxWidth:8,padding:5}}}}});
  var mes={};dedup(cobros).forEach(function(r){var k=fmtM(r.mes);mes[k]=(mes[k]||0)+(+r.importe||0);});
  if(charts.mes)charts.mes.destroy();
  var cm=el('ch-mes');
  if(cm&&Object.keys(mes).length)charts.mes=new Chart(cm,{type:'bar',data:{labels:Object.keys(mes),datasets:[{data:Object.values(mes),backgroundColor:'#3d8ef8',borderRadius:3}]},options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{x:{ticks:{color:'#596175',font:{size:9}},grid:{color:'rgba(42,51,74,.4)'}},y:{ticks:{color:'#596175',font:{size:9},callback:function(v){return '$'+Math.round(v/1000)+'k';}},grid:{color:'rgba(42,51,74,.4)'}}}}});
  var acc=0,lD=[],lL=[];dedup(cobros).slice().reverse().forEach(function(r,i){acc+=(+r.importe||0);lD.push(acc);lL.push('F'+(i+1));});
  if(charts.line)charts.line.destroy();
  var cl2=el('ch-line');
  if(cl2&&lD.length)charts.line=new Chart(cl2,{type:'line',data:{labels:lL,datasets:[{data:lD,borderColor:'#2ec98a',pointRadius:0,fill:true,backgroundColor:'rgba(46,201,138,.07)',tension:.4,borderWidth:2}]},options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{x:{ticks:{color:'#596175',font:{size:9},maxTicksLimit:14,autoSkip:true},grid:{display:false}},y:{ticks:{color:'#596175',font:{size:9},callback:function(v){return '$'+Math.round(v/1000)+'k';}},grid:{color:'rgba(42,51,74,.4)'}}}}});
}

function refreshCentral(){
  var fagSel=el('f-agencia');
  if(fagSel&&fagSel.options.length<=1){
    var ags=usuarios.filter(function(u){return u.rol==='agencia';});
    if(!window._isCent)ags=ags.filter(function(u){return u.zona===CU.zona;});
    ags.forEach(function(u){var o=document.createElement('option');o.value=u.localidad;o.textContent=u.localidad;fagSel.appendChild(o);});
  }
  var fD=gv('f-desde'),fH=gv('f-hasta'),fAg=gv('f-agencia'),fSvc=gv('f-servicio'),fSoc=gv('f-socio-c').toLowerCase(),fEst=gv('f-estado-c');
  function filt(arr,checkSoc,checkEst){
    return arr.filter(function(r){
      if(fD&&r.fecha<fD)return false;
      if(fH&&r.fecha>fH)return false;
      if(fAg&&r.localidad!==fAg)return false;
      if(fSvc&&r.empresa!==fSvc)return false;
      if(checkSoc&&fSoc&&(r.socio||'').toLowerCase().indexOf(fSoc)<0)return false;
      if(checkEst&&fEst&&r.estado!==fEst)return false;
      return true;
    });
  }
  var fCobros=filt(dedup(cobros),true,true);
  var fTickets=filt(dedup(tickets),false,false);
  var fCaja=filt(dedup(cajaMov),false,false);
  var aT=fCobros.reduce(function(s,r){return s+(+r.importe||0);},0);
  var aK=fTickets.reduce(function(s,r){return s+(+r.importe||0);},0);
  var cIng=fCaja.filter(function(r){return r.flujo==='ingreso';}).reduce(function(s,r){return s+(+r.importe||0);},0);
  var cEg=fCaja.filter(function(r){return r.flujo==='egreso';}).reduce(function(s,r){return s+(+r.importe||0);},0);
  function st(id,v){var e=el(id);if(e)e.textContent=v;}
  st('ct-tc',fmt(aT));st('ct-tcs',fCobros.length+' facturas');
  st('ct-tt',fmt(aK));st('ct-tts',fTickets.length+' devueltos');
  st('ct-nt',fmt(aT-aK));st('ct-ci',fmt(cIng));st('ct-ce',fmt(cEg));
  var byAg={};
  fCobros.forEach(function(r){var k=r.localidad||r.usuario_nombre||'?';if(!byAg[k])byAg[k]={nom:k,zona:r.zona||0,c:0,tc:0,t:0,tt:0};byAg[k].c++;byAg[k].tc+=(+r.importe||0);});
  fTickets.forEach(function(r){var k=r.localidad||r.usuario_nombre||'?';if(!byAg[k])byAg[k]={nom:k,zona:r.zona||0,c:0,tc:0,t:0,tt:0};byAg[k].t++;byAg[k].tt+=(+r.importe||0);});
  var sorted=Object.values(byAg).sort(function(a,b){return a.zona!==b.zona?a.zona-b.zona:a.nom.localeCompare(b.nom);});
  st('ct-ua',sorted.length+'');
  var tb=el('tb-ct');
  if(tb)tb.innerHTML=sorted.length?sorted.map(function(u,i){
    return '<tr>'
      +'<td style="color:var(--txt3);font-size:10px">'+(i+1)+'</td>'
      +'<td><strong>'+u.nom+'</strong></td>'
      +'<td><span class="badge '+(u.zona===1?'bbl':'bpu2')+'">Zona '+u.zona+'</span></td>'
      +'<td>'+u.c+'</td>'
      +'<td class="num" style="color:var(--green)">'+fmt(u.tc)+'</td>'
      +'<td>'+u.t+'</td>'
      +'<td class="num" style="color:var(--red)">'+fmt(u.tt)+'</td>'
      +'<td class="num" style="color:var(--purple);font-weight:700">'+fmt(u.tc-u.tt)+'</td>'
      +'</tr>';
  }).join(''):'<tr class="erow"><td colspan="8">Sin datos para los filtros seleccionados</td></tr>';
  var fc2=sorted.reduce(function(s,u){return s+u.c;},0),ft2=sorted.reduce(function(s,u){return s+u.t;},0);
  st('cf-c',fc2);st('cf-tc',fmt(aT));st('cf-t',ft2);st('cf-tt',fmt(aK));st('cf-n',fmt(aT-aK));
  var metaTxt=sorted.length+' agencias';
  if(fD||fH)metaTxt+=' - '+(fD||'inicio')+' al '+(fH||'hoy');
  if(fAg)metaTxt+=' - '+fAg;
  st('ct-meta',metaTxt);
  var tbDet=el('tb-ct-det');
  if(tbDet){
    if(!fCobros.length){tbDet.innerHTML='<tr class="erow"><td colspan="9">Sin cobros</td></tr>';}
    else{
      tbDet.innerHTML=fCobros.map(function(r){
        return '<tr>'
          +'<td style="font-size:10px">'+fmtF(r.fecha)+'</td>'
          +'<td><span class="badge bbl" style="font-size:9px">'+r.localidad+'</span></td>'
          +'<td><strong>'+r.socio+'</strong></td>'
          +'<td>'+fmtM(r.mes)+'</td>'
          +'<td style="font-size:11px;color:var(--txt2)">'+(r.cobrador||'-')+'</td>'
          +'<td style="font-size:11px">'+r.empresa+'</td>'
          +'<td class="num" style="color:var(--green)">'+fmt(r.importe)+'</td>'
          +'<td><span class="badge bbl" style="font-size:9px">'+(r.factura||'-')+'</span></td>'
          +'<td>'+bdg(r.estado)+'</td>'
          +'</tr>';
      }).join('');
    }
    st('ct-det-meta',fCobros.length+' cobros - Total: '+fmt(aT));
  }
  if(charts.ct)charts.ct.destroy();
  var cc=el('ch-ct');if(!cc||!sorted.length)return;
  charts.ct=new Chart(cc,{type:'bar',data:{labels:sorted.map(function(u){return u.nom;}),datasets:[{label:'Cobrado',data:sorted.map(function(u){return u.tc;}),backgroundColor:'#3d8ef8',borderRadius:3},{label:'Tickets',data:sorted.map(function(u){return u.tt;}),backgroundColor:'#f05252',borderRadius:3}]},options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{position:'top',labels:{color:'#8e99b5',font:{size:10}}}},scales:{x:{ticks:{color:'#596175',font:{size:9},maxRotation:45},grid:{color:'rgba(42,51,74,.4)'}},y:{ticks:{color:'#596175',font:{size:9},callback:function(v){return '$'+Math.round(v/1000)+'k';}},grid:{color:'rgba(42,51,74,.4)'}}}}});
}

function clearFiltros(){
  sv('f-desde','');sv('f-hasta','');sv('f-agencia','');sv('f-servicio','');sv('f-socio-c','');sv('f-estado-c','');
  var s=el('f-agencia');if(s){while(s.options.length>1)s.remove(1);}
  refreshCentral();
}

function exportCentralXLSX(){
  var fD=gv('f-desde'),fH=gv('f-hasta'),fAg=gv('f-agencia'),fSvc=gv('f-servicio'),fSoc=gv('f-socio-c').toLowerCase(),fEst=gv('f-estado-c');
  var rows=dedup(cobros).filter(function(r){
    if(fD&&r.fecha<fD)return false;if(fH&&r.fecha>fH)return false;
    if(fAg&&r.localidad!==fAg)return false;if(fSvc&&r.empresa!==fSvc)return false;
    if(fSoc&&(r.socio||'').toLowerCase().indexOf(fSoc)<0)return false;
    if(fEst&&r.estado!==fEst)return false;return true;
  });
  var datos=[['Fecha','Localidad','Zona','Socio','Mes','Importe','Factura','Cobrador','Empresa','Estado']];
  rows.forEach(function(r){datos.push([r.fecha,r.localidad,r.zona,r.socio,r.mes,+r.importe,r.factura||'',r.cobrador||'',r.empresa,r.estado]);});
  exportarComoXLSX(datos,'Cobros_Zona'+CU.zona,'Cobros');
}

function exportCentralCSV(){
  var rows=dedup(cobros);
  var fD=gv('f-desde'),fH=gv('f-hasta'),fAg=gv('f-agencia'),fSvc=gv('f-servicio'),fSoc=gv('f-socio-c').toLowerCase(),fEst=gv('f-estado-c');
  rows=rows.filter(function(r){
    if(fD&&r.fecha<fD)return false;
    if(fH&&r.fecha>fH)return false;
    if(fAg&&r.localidad!==fAg)return false;
    if(fSvc&&r.empresa!==fSvc)return false;
    if(fSoc&&(r.socio||'').toLowerCase().indexOf(fSoc)<0)return false;
    if(fEst&&r.estado!==fEst)return false;
    return true;
  });
  function esc(v){var s=String(v==null?'':v);return(s.indexOf(',')>=0||s.indexOf('"')>=0)?'"'+s.replace(/"/g,'""')+'"':s;}
  var hdr='fecha,localidad,zona,socio,mes,importe,factura,cobrador,empresa,estado,obs';
  var csv=hdr+'\n'+rows.map(function(r){return[r.fecha,r.localidad,r.zona,r.socio,r.mes,r.importe,r.factura,r.cobrador,r.empresa,r.estado,r.obs].map(esc).join(',');}).join('\n');
  var b=new Blob(['\ufeff'+csv],{type:'text/csv;charset=utf-8;'});
  var a=document.createElement('a');a.href=URL.createObjectURL(b);a.download='Cobros_'+today().replace(/-/g,'')+'.csv';a.click();URL.revokeObjectURL(a.href);
}

var PGINFO={dashboard:'Dashboard',aprobacion:'Aprobar registros pendientes','mis-cobradores':'Mis Cobradores',planilla:'Cierre Diario',enlaces:'Enlaces de acceso',central:'Vista Central / Zona',fc:'Nuevo cobro',ft:'Ticket devuelto',fca:'Movimiento caja',lc:'Cobros',lt:'Tickets devueltos',lca:'Caja',usuarios:'Usuarios'};
function go(name){
  document.documentElement.scrollTop=0;document.body.scrollTop=0;var mn=document.querySelector('.main');if(mn)mn.scrollTop=0;
  if(window.innerWidth<=768)closeSidebar();
  document.querySelectorAll('.page').forEach(function(p){p.classList.remove('active');});
  document.querySelectorAll('.ni').forEach(function(n){n.classList.remove('active');});
  var pg=el('page-'+name);if(!pg)return;
  pg.classList.add('active');
  document.querySelectorAll('.ni[data-page="'+name+'"]').forEach(function(n){n.classList.add('active');});
  var fechaCompleta=new Date().toLocaleDateString('es-AR',{weekday:'long',day:'2-digit',month:'long',year:'numeric'});
  // Capitalize first letter
  fechaCompleta=fechaCompleta.charAt(0).toUpperCase()+fechaCompleta.slice(1);
  el('ttl').textContent=PGINFO[name]||name;
  el('tmeta').textContent=fechaCompleta;
  // Update dashboard header if visible
  if(name==='dashboard'){
    var du=el('dash-user');if(du&&CU)du.textContent=CU.nombre;
    var df=el('dash-fecha');if(df)df.textContent=fechaCompleta;
  }
  curPage=name;
  if(name==='lc')renderCobros();
  else if(name==='lt')renderTickets();
  else if(name==='lca')renderCaja();
  else if(name==='central')refreshCentral();
  else if(name==='usuarios')renderUsuarios();
  else if(name==='mis-cobradores'){
    // Reset cobrador dropdown so it repopulates
    var s=el('fc-cobrador');if(s){while(s.options.length>1)s.remove(1);}
    renderMisCobradores();
  }
  else if(name==='aprobacion')renderAprobacion();
  else if(name==='planilla')renderPlanilla();
  else if(name==='enlaces')renderEnlaces();
}

function refreshAll(){
  refreshDashboard();
  if(curPage==='lc')renderCobros();
  else if(curPage==='lt')renderTickets();
  else if(curPage==='lca')renderCaja();
  else if(curPage==='central')refreshCentral();
  else if(curPage==='usuarios')renderUsuarios();
  else if(curPage==='aprobacion')renderAprobacion();
  else if(curPage==='planilla')renderPlanilla();
  else if(curPage==='mis-cobradores'){renderCobrosAgencia();renderPendientesCob();}
  // Update planilla badge for agencia regardless of current page
  if(CU&&CU.rol==='agencia')updatePlanillaBadge();
}

function updatePlanillaBadge(){
  var hoy=today();
  var cnt=dedup(cobros).filter(function(r){return r.fecha===hoy;}).length
    +dedup(tickets).filter(function(r){return r.fecha===hoy;}).length
    +dedup(cajaMov).filter(function(r){return r.fecha===hoy;}).length;
  var b=el('planilla-badge');
  if(b){
    b.textContent=cnt>9?'9+':String(cnt);
    b.style.display=cnt>0?'inline-block':'none';
  }
}

function doPrint(){
  var sel=document.querySelector('input[name="pr"]:checked');if(!sel)return;
  var t=sel.value;hideOv('ovprt');
  if(t==='lc')renderCobros();else if(t==='lt')renderTickets();else if(t==='lca')renderCaja();else if(t==='central')refreshCentral();else refreshDashboard();
  var pw=window.open('','_blank','width=900,height=700');
  if(!pw){alert('Habilita los pop-ups para este sitio e intenta de nuevo');return;}
  var pg=el('page-'+t);if(!pg)return;
  pw.document.write('<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>San Nicolás - '+t+'</title><style>');
  pw.document.write('*{box-sizing:border-box;margin:0;padding:0}body{font-family:Arial,sans-serif;font-size:10pt;color:#000;background:#fff;padding:1.5cm}');
  pw.document.write('table{width:100%;border-collapse:collapse;margin-top:12px;font-size:9pt}thead th{background:#2c3e50;color:#fff;padding:7px 9px;text-align:left;border:1px solid #2c3e50}');
  pw.document.write('tbody td{padding:6px 9px;border:1px solid #ddd;color:#000}tbody tr:nth-child(even) td{background:#f9f9f9}tfoot td{padding:6px 9px;border:1px solid #bbb;background:#eee;font-weight:bold}');
  pw.document.write('.kgrid,.cgrid,.ccard,.no-print,.btn,.ab,.cctrl,.alr,.fa,.div,.ov,.sdoverlay{display:none!important}.num{text-align:right}');
  pw.document.write('.badge{display:inline-block;padding:2px 6px;border-radius:3px;font-size:8pt;font-weight:bold;border:1px solid #999;background:#eee;color:#333}');
  pw.document.write('.card{border:1px solid #ccc;border-radius:4px;overflow:hidden;margin-bottom:12px}.ch{background:#f5f5f5;padding:8px 12px;border-bottom:1px solid #ccc}');
  pw.document.write('.ct2{font-size:12pt;font-weight:bold}.cm{font-size:9pt;color:#555;margin-top:2px}.csum{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-bottom:12px}');
  pw.document.write('.cscard{border:1px solid #ccc;border-radius:4px;padding:10px}.kgrid{display:grid!important;grid-template-columns:repeat(3,1fr);gap:10px;margin-bottom:12px}');
  pw.document.write('.kpi{background:#f9f9f9;border:1px solid #ddd;border-radius:4px;padding:10px}.kl,.ks{font-size:9pt;color:#555}.kv{font-size:14pt;font-weight:bold;color:#000}');
  pw.document.write('@page{margin:1.5cm;size:A4}');
  pw.document.write('</style></head><body>');
  pw.document.write('<h2 style="font-size:16pt;margin-bottom:4px">San Nicolás - '+(PGINFO[t]||t)+'</h2>');
  pw.document.write('<p style="font-size:10pt;color:#555;margin-bottom:16px">'+new Date().toLocaleDateString('es-AR',{day:'2-digit',month:'long',year:'numeric'})+' - Usuario: '+(CU?CU.nombre:'-')+'</p>');
  pw.document.write(pg.innerHTML);
  pw.document.write('</body></html>');
  pw.document.close();
  pw.focus();
  setTimeout(function(){pw.print();},600);
}

// ── CARPETA DESTINO: "Archivos Sistema Juan" ────────────────────────────────
var _exportDir = null;
var CARPETA_NOMBRE = 'Archivos Sistema Juan';

async function iniciarCarpeta(){
  // Called on first export — guide user to select or create the target folder
  if(_exportDir) return true;
  if(!window.showDirectoryPicker){
    // No API support — use regular download
    return false;
  }
  showSB('Seleccioná la carpeta "'+CARPETA_NOMBRE+'" en el escritorio para guardar automáticamente','info', 5000);
  try{
    _exportDir = await window.showDirectoryPicker({
      mode: 'readwrite',
      startIn: 'desktop',
      id: 'archivos-sistema-juan'
    });
    localStorage.setItem('sn_carpeta_ok','1');
    localStorage.setItem('sn_carpeta_nombre', _exportDir.name);
    var cnm=el('carpeta-nombre');
    if(cnm)cnm.textContent=_exportDir.name;
    showSB('Carpeta configurada: '+_exportDir.name+' — Los archivos se guardarán aquí automáticamente','success',5000);
    return true;
  } catch(e){
    if(e.name !== 'AbortError'){
      showSB('No se pudo acceder a la carpeta: '+e.message,'error');
    }
    return false;
  }
}

async function seleccionarCarpeta(){
  _exportDir = null; // reset so picker shows again
  var ok = await iniciarCarpeta();
  if(!ok) showSB('Usa Chrome o Edge en escritorio para seleccionar la carpeta "'+CARPETA_NOMBRE+'"','error',6000);
}

async function guardarArchivo(nombre, contenido, tipo){
  // Auto-init folder on first save
  if(!_exportDir && window.showDirectoryPicker){
    var ok = await iniciarCarpeta();
    if(!ok){
      _descargarDirecto(nombre, contenido, tipo);
      return;
    }
  }
  if(_exportDir){
    try{
      var fh = await _exportDir.getFileHandle(nombre, {create:true});
      var wr = await fh.createWritable();
      await wr.write(contenido instanceof Blob ? contenido : new Blob([contenido],{type:tipo||'application/octet-stream'}));
      await wr.close();
      showSB('Guardado en "'+CARPETA_NOMBRE+'": '+nombre,'success',4000);
      return;
    } catch(e){
      console.warn('Error guardando en carpeta:', e.message);
    }
  }
  _descargarDirecto(nombre, contenido, tipo);
}

function _descargarDirecto(nombre, contenido, tipo){
  var b = contenido instanceof Blob ? contenido : new Blob([contenido],{type:tipo||'application/octet-stream'});
  var a = document.createElement('a');
  a.href = URL.createObjectURL(b);
  a.download = nombre;
  a.click();
  URL.revokeObjectURL(a.href);
}

// ── EXPORT AS XLSX ────────────────────────────────────────────────────────────
function exportarComoXLSX(datos, nombre, hoja){
  // Build a minimal XLSX using CSV wrapped in XML (Excel-compatible)
  // For full XLSX we use the SheetJS-style simple XML format
  var fecha = today().replace(/-/g,'');
  var nombreFinal = nombre+'_'+fecha+'.xlsx';

  // Build Excel XML
  var xml = '<?xml version="1.0" encoding="UTF-8"?>';
  xml += '<?mso-application progid="Excel.Sheet"?>';
  xml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"';
  xml += ' xmlns:o="urn:schemas-microsoft-com:office:office"';
  xml += ' xmlns:x="urn:schemas-microsoft-com:office:excel"';
  xml += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">';
  xml += '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">';
  xml += '<Title>'+hoja+'</Title>';
  xml += '<Author>San Nicolás</Author></DocumentProperties>';
  xml += '<Styles><Style ss:ID="Header"><Font ss:Bold="1" ss:Color="#FFFFFF"/>';
  xml += '<Interior ss:Color="#2c3e50" ss:Pattern="Solid"/></Style>';
  xml += '<Style ss:ID="Money"><NumberFormat ss:Format="#,##0.00"/></Style></Styles>';
  xml += '<Worksheet ss:Name="'+hoja+'">';
  xml += '<Table>';

  datos.forEach(function(row, ri){
    xml += '<Row>';
    row.forEach(function(cell){
      var isNum = typeof cell === 'number' || (!isNaN(cell) && cell!=='' && cell!==null);
      var tipo = isNum ? 'Number' : 'String';
      var val = cell == null ? '' : String(cell).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
      var styleAttr = ri===0 ? ' ss:StyleID="Header"' : (isNum ? ' ss:StyleID="Money"' : '');
      xml += '<Cell'+styleAttr+'><Data ss:Type="'+tipo+'">'+val+'</Data></Cell>';
    });
    xml += '</Row>';
  });

  xml += '</Table></Worksheet></Workbook>';

  var blob = new Blob([xml], {type:'application/vnd.ms-excel;charset=utf-8;'});
  guardarArchivo(nombreFinal, blob, 'application/vnd.ms-excel');
}

// ── EXPORT AS PDF ─────────────────────────────────────────────────────────────
function exportarComoPDF(titulo, htmlContent){
  var fecha = today().replace(/-/g,'');
  var nombreFinal = titulo.replace(/\s+/g,'_')+'_'+fecha+'.pdf';

  var pw = window.open('','_blank','width=900,height=700');
  if(!pw){showSB('Habilitá los pop-ups para exportar PDF','error');return;}

  pw.document.write('<!DOCTYPE html><html><head><meta charset="UTF-8"><title>'+titulo+'</title>');
  pw.document.write('<style>');
  pw.document.write('*{box-sizing:border-box;margin:0;padding:0}');
  pw.document.write('body{font-family:Arial,sans-serif;font-size:9pt;color:#000;background:#fff;padding:1.5cm}');
  pw.document.write('h1{font-size:14pt;margin-bottom:6px}p{font-size:10pt;color:#555;margin-bottom:14px}');
  pw.document.write('table{width:100%;border-collapse:collapse;font-size:8pt}');
  pw.document.write('thead th{background:#2c3e50;color:#fff;padding:6px 8px;text-align:left}');
  pw.document.write('tbody td{padding:5px 8px;border-bottom:1px solid #ddd}');
  pw.document.write('tbody tr:nth-child(even) td{background:#f9f9f9}');
  pw.document.write('tfoot td{padding:6px 8px;background:#eee;font-weight:bold}');
  pw.document.write('.no-print,.btn,.ab,.cctrl{display:none!important}');
  pw.document.write('@page{margin:1.5cm;size:A4}');
  pw.document.write('</style></head><body>');
  pw.document.write('<h1>San Nicolás — '+titulo+'</h1>');
  pw.document.write('<p>'+new Date().toLocaleDateString('es-AR',{weekday:'long',day:'2-digit',month:'long',year:'numeric'})+'</p>');
  pw.document.write(htmlContent);
  pw.document.write('</body></html>');
  pw.document.close();
  pw.focus();
  setTimeout(function(){
    pw.print();
    // After print dialog, suggest saving
    setTimeout(function(){
      showSB('En el diálogo de impresión: elegí "Guardar como PDF" y guardá en "'+CARPETA_NOMBRE+'"','info',8000);
    },500);
  },600);
}

function exportCSV(){
  function esc(v){var s=String(v==null?'':v);return(s.indexOf(',')>=0||s.indexOf('"')>=0)?'"'+s.replace(/"/g,'""')+'"':s;}
  var csv='## SAN NICOLAS\n## '+new Date().toLocaleString('es-AR')+'\n\n';
  csv+='[COBROS]\nfecha,localidad,zona,socio,mes,importe,factura,cobrador,empresa,estado,obs,usuario_numero,usuario_nombre\n';
  csv+=dedup(cobros).map(function(r){return[r.fecha,r.localidad,r.zona,r.socio,r.mes,r.importe,r.factura,r.cobrador,r.empresa,r.estado,r.obs,r.usuario_numero,r.usuario_nombre].map(esc).join(',');}).join('\n');
  csv+='\n\n[TICKETS]\nfecha,localidad,zona,socio,mes,importe,ticket,motivo,empresa,usuario_numero,usuario_nombre\n';
  csv+=dedup(tickets).map(function(r){return[r.fecha,r.localidad,r.zona,r.socio,r.mes,r.importe,r.ticket,r.motivo,r.empresa,r.usuario_numero,r.usuario_nombre].map(esc).join(',');}).join('\n');
  csv+='\n\n[CAJA]\nfecha,localidad,zona,empresa,tipo,banco,flujo,importe,obs,usuario_numero,usuario_nombre\n';
  csv+=dedup(cajaMov).map(function(r){return[r.fecha,r.localidad,r.zona,r.empresa,r.tipo,r.banco,r.flujo,r.importe,r.obs,r.usuario_numero,r.usuario_nombre].map(esc).join(',');}).join('\n');
  var nombre='SanNicolas_U'+(CU?CU.numero:'0')+'_'+today().replace(/-/g,'')+'.csv';
  guardarArchivo(nombre, '\ufeff'+csv, 'text/csv;charset=utf-8;');
}


// ═══════════════════════════════════════════════════════════════════════════
// SISTEMA DE APROBACIÓN Y NOTIFICACIONES
// ═══════════════════════════════════════════════════════════════════════════

var notifInterval = null;
var pendingApprovalId = null;
var pendingApprovalTbl = null;

// ── SAVE con estado_revision pendiente (para agencias) ────────────────────
function saveCobroAgencia(){
  var soc=gv('c-soc').trim(), mes=gv('c-mes'), imp=parseImp(gv('c-imp'));
  if(!soc||!mes){showAlr('al-c','error','Completa Socio, Mes e Importe');return;}
  if(isNaN(imp)||imp<=0){showAlr('al-c','error','Importe invalido');return;}
  var saveMode=window._saveMode||'pendiente';
  var row={fecha:gv('c-fec')||today(),localidad:CU.localidad||gv('c-loc')||'',zona:CU.zona||0,
    socio:soc,mes:+mes,importe:imp,factura:gv('c-fac')||null,ticket_num:gv('c-tic')||null,cobrador:CU.nombre,
    empresa:gv('c-emp'),estado:gv('c-est'),obs:gv('c-obs')||null,
    usuario_id:CU.id,usuario_nombre:CU.nombre,usuario_numero:CU.numero,
    estado_revision:saveMode==='directo'?'aprobado':'pendiente'};
  insPendiente('cobros',row,'al-c','btn-sc','Enviar cobro');
}

function saveTicketAgencia(){
  var soc=gv('t-soc').trim(), mes=gv('t-mes'), imp=parseImp(gv('t-imp'));
  if(!soc||!mes){showAlr('al-t','error','Completa Socio, Mes e Importe');return;}
  if(isNaN(imp)||imp<=0){showAlr('al-t','error','Importe invalido');return;}
  var saveMode2=window._saveMode||'pendiente';
  var row={fecha:gv('t-fec')||today(),localidad:CU.localidad||gv('t-loc')||'',zona:CU.zona||0,
    socio:soc,mes:+mes,importe:imp,ticket:gv('t-tic')||null,motivo:gv('t-mot')||null,
    empresa:gv('t-emp'),usuario_id:CU.id,usuario_nombre:CU.nombre,usuario_numero:CU.numero,
    estado_revision:saveMode2==='directo'?'aprobado':'pendiente'};
  insPendiente('tickets',row,'al-t','btn-st','Enviar ticket');
}

function saveCajaAgencia(){
  var imp=parseImp(gv('ca-imp'));
  if(isNaN(imp)||imp<=0){showAlr('al-ca','error','Importe invalido');return;}
  var saveMode3=window._saveMode||'pendiente';
  var row={fecha:gv('ca-fec')||today(),localidad:CU.localidad||gv('ca-loc')||'',zona:CU.zona||0,
    empresa:gv('ca-emp'),tipo:gv('ca-tip'),banco:gv('ca-ban')||null,flujo:gv('ca-flu'),
    importe:imp,obs:gv('ca-obs')||null,
    usuario_id:CU.id,usuario_nombre:CU.nombre,usuario_numero:CU.numero,
    estado_revision:saveMode3==='directo'?'aprobado':'pendiente'};
  insPendiente('caja_movimientos',row,'al-ca','btn-sca','Enviar movimiento');
}

function insPendiente(tbl,row,alId,btnId,lbl){
  if(!SB||!isConn){showAlr(alId,'error','Sin conexion');return;}
  if(_insFlight){showAlr(alId,'error','Espera la operacion anterior');return;}
  var btn=el(btnId);if(btn){btn.disabled=true;btn.textContent='Enviando...';}
  _insFlight=true;
  SB.from(tbl).insert([row]).select().then(function(r){
    _insFlight=false;
    if(btn){btn.disabled=false;btn.textContent=window._saveMode==='pendiente'?'Enviar para ser aprobado':lbl;}
    if(r.error){showAlr(alId,'error','Error: '+diagErr(r.error));return;}
    if(!r.data||!r.data.length){showAlr(alId,'error','Sin respuesta de Supabase');return;}
    var rec=r.data[0];
    var destino=isCobrador()?'Tu agencia recibira el registro para incluirlo en su cierre diario.':'Registrado en el sistema. Recuerda enviar el cierre diario para que el admin lo apruebe.';
    showAlr(alId,'success','Enviado correctamente. '+destino);
    showSB(isCobrador()?'Enviado a tu agencia':'Guardado — pendiente de cierre','success',5000);
    // Notify admins
    crearNotificacionAdmin(tbl, rec);
    if(tbl==='cobros')clearFC();
    else if(tbl==='tickets')clearFT();
    else clearFCA();
    loadAll();
  }).catch(function(e){
    _insFlight=false;
    if(btn){btn.disabled=false;btn.textContent=window._saveMode==='pendiente'?'Enviar para ser aprobado':lbl;}
    showAlr(alId,'error','Error: '+diagErr(e));
  });
}

function crearNotificacionAdmin(tbl,rec){
  var tipoLabel={'cobros':'cobro','tickets':'ticket','caja_movimientos':'movimiento de caja'};
  // Si es cobrador: notificar SOLO a su agencia (no al admin de zona aun)
  // Si es agencia: no genera notif aqui (la notif al admin la crea enviarPlanilla)
  if(isCobrador()&&CU.agencia_numero){
    var msg=CU.nombre+' envio un '+tipoLabel[tbl]+': $'+fmt(rec.importe).replace('$','')+' - '+fmtF(rec.fecha);
    SB.from('notificaciones').insert([{
      para_rol:'agencia',para_zona:CU.zona,para_usuario_id:null,
      tipo:'pendiente',
      titulo:'Nuevo '+tipoLabel[tbl]+' de '+CU.nombre,
      mensaje:msg,tabla_origen:tbl,registro_id:rec.id,leida:false
    }]).then(function(){}).catch(function(){});
  }
}

function isCobrador(){
  return CU&&CU.rol==='cobrador';
}

// ── NOTIFICATION POLLING ─────────────────────────────────────────────────────
function startNotifPolling(){
  if(notifInterval)clearInterval(notifInterval);
  cargarNotificaciones();
  notifInterval=setInterval(cargarNotificaciones, 10000); // cada 15 seg
}

function stopNotifPolling(){
  if(notifInterval){clearInterval(notifInterval);notifInterval=null;}
}

function cargarNotificaciones(){
  if(!SB||!isConn||!CU)return;
  var rol=CU.rol||'agencia';
  var q=SB.from('notificaciones').select('*').order('created_at',{ascending:false}).limit(50);
  // Filter by role
  if(rol==='admin_central'||rol==='admin'){
    q=q.eq('para_rol','admin_central');
  } else if(rol==='admin_zona'){
    q=q.or('para_rol.eq.admin_zona,para_rol.eq.admin_central').eq('para_zona',CU.zona);
  } else if(rol==='agencia'){
    // Agencia: sus propias notificaciones + las de sus cobradores (por zona y localidad)
    q=q.eq('para_rol','agencia').eq('para_zona',CU.zona);
  } else {
    // cobrador: sus propias notificaciones (aprobado/rechazado)
    q=q.eq('para_usuario_id',CU.id);
  }
  q.then(function(r){
    if(r.error)return;
    var notifs=r.data||[];
    var unread=notifs.filter(function(n){return !n.leida;}).length;
    // Update bell badge
    var badge=document.getElementById('notif-badge');
    if(badge){
      badge.textContent=unread>9?'9+':unread;
      badge.style.cssText='display:'+(unread>0?'block':'none')+';position:absolute;top:-4px;right:-4px;background:#f05252;color:#fff;border-radius:99px;font-size:9px;font-weight:700;padding:2px 5px;min-width:16px;text-align:center;pointer-events:none;z-index:99';
    }
    // Update sidebar approval badge
    var aprovBadge=el('aprov-badge');
    if(aprovBadge){
      var pendientes=notifs.filter(function(n){return !n.leida&&n.tipo==='pendiente';}).length;
      aprovBadge.textContent=pendientes>9?'9+':String(pendientes);
      aprovBadge.style.display=pendientes>0?'inline-block':'none';
    }
    // Update list
    renderNotifList(notifs);
    // Show in-screen toast for new notifs
    var newest=notifs.find(function(n){return !n.leida;});
    if(newest&&!window._lastNotifId){
      window._lastNotifId=newest.id;
    } else if(newest&&newest.id!==window._lastNotifId){
      window._lastNotifId=newest.id;
      showToast(newest);
    }
  }).catch(function(){});
}

function showToast(notif){
  var tipo=notif.tipo==='aprobado'?'success':notif.tipo==='rechazado'?'error':'info';
  showSB('🔔 '+notif.titulo+': '+notif.mensaje, tipo, 8000);
  // Browser notification if permission granted
  if(window.Notification&&Notification.permission==='granted'){
    try{
      new Notification(notif.titulo,{body:notif.mensaje,icon:'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><rect width="100" height="100" rx="20" fill="%230f1117"/><text y=".9em" font-size="80" x="10">🏢</text></svg>'});
    }catch(e){}
  }
}

function renderNotifList(notifs){
  var list=el('notif-list');if(!list)return;
  if(!notifs.length){
    list.innerHTML='<div style="padding:1.5rem;text-align:center;color:var(--txt3);font-size:13px">Sin notificaciones</div>';
    return;
  }
  list.innerHTML=notifs.map(function(n){
    var timeAgo=getTimeAgo(n.created_at);
    var tipoClass=n.tipo==='aprobado'?'tipo-aprobado':n.tipo==='rechazado'?'tipo-rechazado':'';
    var icon=n.tipo==='aprobado'?'✓':n.tipo==='rechazado'?'✗':'⏳';
    var color=n.tipo==='aprobado'?'var(--green)':n.tipo==='rechazado'?'var(--red)':'var(--amber)';
    return '<div class="notif-item '+(n.leida?'':'unread')+' '+tipoClass+'" onclick="leerNotif(\''+n.id+'\')">'
      +'<div style="display:flex;align-items:flex-start;gap:8px">'
      +'<span style="font-size:14px;color:'+color+';flex-shrink:0">'+icon+'</span>'
      +'<div><div class="notif-title">'+n.titulo+'</div>'
      +'<div class="notif-msg">'+n.mensaje+'</div>'
      +'<div class="notif-time">'+timeAgo+'</div></div>'
      +'</div>'
      +(n.tabla_origen&&!n.leida&&(CU.rol==='admin_central'||CU.rol==='admin_zona')?
        '<div style="margin-top:6px"><button class="btn bp sm" style="font-size:11px" onclick="irAAprobacion(event)">Ver pendientes</button></div>':'')
      +'</div>';
  }).join('');
}

function getTimeAgo(dateStr){
  if(!dateStr)return '';
  var diff=Date.now()-new Date(dateStr).getTime();
  var mins=Math.floor(diff/60000);
  if(mins<1)return 'Hace un momento';
  if(mins<60)return 'Hace '+mins+' min';
  var hrs=Math.floor(mins/60);
  if(hrs<24)return 'Hace '+hrs+' h';
  return 'Hace '+Math.floor(hrs/24)+' d';
}

function leerNotif(id){
  // Delete notification when read
  SB.from('notificaciones').delete().eq('id',id).then(function(){
    cargarNotificaciones();
  }).catch(function(){});
}

function marcarTodasLeidas(){
  if(!CU)return;
  var rol=CU.rol||'agencia';
  var isCent=rol==='admin_central'||rol==='admin';
  var isZona=rol==='admin_zona';
  var isAg=rol==='agencia';
  // Delete all notifications visible to this user
  var q=SB.from('notificaciones').delete();
  if(isCent) q=q.eq('para_rol','admin_central');
  else if(isZona) q=q.eq('para_zona',CU.zona).neq('para_rol','admin_central');
  else if(isAg) q=q.eq('para_rol','agencia').eq('para_zona',CU.zona);
  else q=q.eq('para_usuario_id',CU.id);
  q.then(function(){ cargarNotificaciones(); }).catch(function(){});
}

function toggleNotifPopup(){
  var p=el('notif-popup');
  if(!p)return;
  if(p.classList.contains('open')){
    p.classList.remove('open');
  } else {
    p.classList.add('open');
    cargarNotificaciones();
  }
}

function irAAprobacion(e){
  e.stopPropagation();
  el('notif-popup').classList.remove('open');
  go('aprobacion');
}

// Close popup on outside click
document.addEventListener('click',function(e){
  var popup=el('notif-popup');
  var bell=el('bell-btn');
  if(popup&&bell&&!popup.contains(e.target)&&!bell.contains(e.target)){
    popup.classList.remove('open');
  }
});

// ── APPROVAL PAGE ─────────────────────────────────────────────────────────────
function renderAprobacion(){
  var zonaFiltro=gv('f-aprov-zona');
  var rol=CU?CU.rol:'';
  var isCent=rol==='admin_central'||rol==='admin';

  // Now we approve CIERRES (not individual records)
  var q=SB.from('cierres_diarios').select('*').eq('estado','enviado').order('created_at',{ascending:true});
  if(!isCent)q=q.eq('zona',CU.zona);
  if(zonaFiltro)q=q.eq('zona',+zonaFiltro);

  q.then(function(rCierres){
    if(rCierres.error){showSB('Error: '+diagErr(rCierres.error),'error');return;}
    var cierres=rCierres.data||[];
    var meta=el('aprov-meta');
    if(meta)meta.textContent=cierres.length+' cierres pendientes de aprobacion';
    var list=el('aprov-list');if(!list)return;
    if(!cierres.length){
      list.innerHTML='<div style="padding:2rem;text-align:center;color:var(--txt3);background:var(--bg2);border:1px solid var(--bord);border-radius:10px">Sin cierres pendientes de aprobacion</div>';
      return;
    }
    list.innerHTML=cierres.map(function(c){
      var resumen='<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(140px,1fr));gap:10px;margin:.6rem 0">'
        +'<div style="background:var(--bg3);border-radius:7px;padding:8px"><div style="font-size:9px;color:var(--txt3);text-transform:uppercase">Cobros</div><div style="font-size:14px;font-weight:700;color:var(--green)">'+fmt(c.cobros_total)+'</div><div style="font-size:10px;color:var(--txt3)">'+c.cobros_cant+' reg.</div></div>'
        +'<div style="background:var(--bg3);border-radius:7px;padding:8px"><div style="font-size:9px;color:var(--txt3);text-transform:uppercase">Tickets</div><div style="font-size:14px;font-weight:700;color:var(--red)">'+fmt(c.tickets_total)+'</div><div style="font-size:10px;color:var(--txt3)">'+c.tickets_cant+' reg.</div></div>'
        +'<div style="background:var(--bg3);border-radius:7px;padding:8px"><div style="font-size:9px;color:var(--txt3);text-transform:uppercase">Caja</div><div style="font-size:14px;font-weight:700;color:var(--amber)">'+fmt(c.caja_total)+'</div><div style="font-size:10px;color:var(--txt3)">'+c.caja_cant+' reg.</div></div>'
        +'<div style="background:var(--bluebg);border-radius:7px;padding:8px;border:1px solid var(--blue)"><div style="font-size:9px;color:var(--blue);text-transform:uppercase">Neto</div><div style="font-size:14px;font-weight:700;color:var(--blue)">'+fmt(c.neto)+'</div></div>'
        +'</div>';
      return '<div class="aprov-item" id="cierre-'+c.id+'">'
        +'<div class="aprov-header">'
        +'<div><span class="badge bbl" style="font-size:11px;padding:4px 10px">CIERRE '+fmtF(c.fecha)+'</span> '
        +'<span style="margin-left:8px;font-weight:700">'+c.localidad+'</span> '
        +'<span class="badge '+(c.zona===1?'bbl':'bpu2')+'" style="font-size:9px">Zona '+c.zona+'</span></div>'
        +'<span style="font-size:10px;color:var(--txt3)">'+getTimeAgo(c.created_at)+'</span>'
        +'</div>'
        +resumen
        +'<div style="font-size:11px;color:var(--txt3);margin-bottom:.6rem">Enviado por: <strong>'+(c.enviado_por||'-')+'</strong></div>'
        +'<div class="aprov-btns">'
        +'<button class="btn bs sm" onclick="aprobarCierre(\''+c.id+'\')">Aprobar cierre</button>'
        +'<button class="btn bd sm" onclick="pedirRechazoCierre(\''+c.id+'\')">Rechazar</button>'
        +'<button class="btn bg sm" onclick="verDetalleCierre(\''+c.id+'\')">Ver detalle</button>'
        +'</div>'
        +'<div class="reject-input" id="ric-'+c.id+'">'
        +'<div class="fg"><label>Motivo del rechazo</label><input type="text" id="ric-input-'+c.id+'" placeholder="Ej: Importe incorrecto..."></div>'
        +'<div class="fa" style="margin-top:6px"><button class="btn bd sm" onclick="rechazarCierre(\''+c.id+'\')">Confirmar rechazo</button>'
        +'<button class="btn bg sm" onclick="cancelarRechazoCierre(\''+c.id+'\')">Cancelar</button></div>'
        +'</div>'
        +'<div id="detalle-cierre-'+c.id+'" style="display:none;margin-top:10px;padding:10px;background:var(--bg3);border-radius:7px;font-size:11px;max-height:280px;overflow-y:auto"></div>'
        +'</div>';
    }).join('');
  }).catch(function(e){
    showSB('Error: '+diagErr(e),'error');
  });
  return;
  Promise.all([]).then(function(results){
    var all=[];
    results.forEach(function(r){
      if(!r.error)r.data.forEach(function(rec){all.push({tabla:r.tabla,rec:rec});});
    });
    all.sort(function(a,b){return new Date(a.rec.created_at)-new Date(b.rec.created_at);});

    var meta=el('aprov-meta');
    if(meta)meta.textContent=all.length+' registros pendientes';

    var list=el('aprov-list');if(!list)return;
    if(!all.length){
      list.innerHTML='<div style="padding:2rem;text-align:center;color:var(--txt3);background:var(--bg2);border:1px solid var(--bord);border-radius:10px">Sin registros pendientes de aprobacion</div>';
      return;
    }

    var tipoLabel={'cobros':'COBRO','tickets':'TICKET','caja_movimientos':'CAJA'};
    var tipoColor={'cobros':'var(--blue)','tickets':'var(--red)','caja_movimientos':'var(--green)'};

    list.innerHTML=all.map(function(item){
      var r=item.rec, t=item.tabla;
      var datos='<span>Fecha:</span> <strong>'+fmtF(r.fecha)+'</strong> &nbsp; '
        +'<span>Localidad:</span> <strong>'+(r.localidad||'-')+'</strong> &nbsp; '
        +'<span>Usuario:</span> <strong>'+(r.usuario_nombre||'-')+'</strong><br>'
        +'<span>Importe:</span> <strong style="color:var(--green)">'+fmt(r.importe)+'</strong> &nbsp; '
        +'<span>Empresa:</span> <strong>'+(r.empresa||'-')+'</strong>';
      if(r.socio)datos+=' &nbsp; <span>Socio:</span> <strong>'+r.socio+'</strong>';
      if(r.mes)datos+=' &nbsp; <span>Mes:</span> <strong>'+fmtM(r.mes)+'</strong>';
      if(r.tipo)datos+=' &nbsp; <span>Tipo:</span> <strong>'+r.tipo+'</strong>';
      if(r.obs)datos+='<br><span>Obs:</span> '+r.obs;
      return '<div class="aprov-item" id="aprov-'+r.id+'">'
        +'<div class="aprov-header">'
        +'<span class="badge bbl aprov-tipo" style="background:none;border:1px solid '+tipoColor[t]+';color:'+tipoColor[t]+'">'+tipoLabel[t]+'</span>'
        +'<span style="font-size:10px;color:var(--txt3)">'+getTimeAgo(r.created_at)+'</span>'
        +'</div>'
        +'<div class="aprov-data">'+datos+'</div>'
        +'<div class="aprov-btns">'
        +'<button class="btn bs sm" onclick="aprobar(\''+t+'\',\''+r.id+'\',\''+r.usuario_id+'\',\''+r.usuario_nombre+'\',\''+t+'\')">&#10003; Aprobar</button>'
        +'<button class="btn bd sm" onclick="pedirRechazo(\''+t+'\',\''+r.id+'\',\''+r.usuario_id+'\',\''+r.usuario_nombre+'\')">&#10007; Rechazar</button>'
        +'</div>'
        +'<div class="reject-input" id="ri-'+r.id+'">'
        +'<div class="fg"><label>Motivo del rechazo</label><input type="text" id="ri-input-'+r.id+'" placeholder="Ej: Importe incorrecto..."></div>'
        +'<div class="fa"><button class="btn bd sm" onclick="rechazar(\''+t+'\',\''+r.id+'\',\''+r.usuario_id+'\',\''+r.usuario_nombre+'\')">Confirmar rechazo</button>'
        +'<button class="btn bg sm" onclick="cancelarRechazo(\''+r.id+'\')">Cancelar</button></div>'
        +'</div>'
        +'</div>';
    }).join('');
  }).catch(function(e){
    showSB('Error al cargar pendientes: '+diagErr(e),'error',5000);
  });
}

function aprobarCierre(cierreId){
  if(!confirm('Aprobar este cierre completo? Todos los registros se aprobaran a la vez.'))return;
  SB.from('cierres_diarios').select('*').eq('id',cierreId).then(function(r){
    if(r.error||!r.data||!r.data.length){showSB('Cierre no encontrado','error');return;}
    var c=r.data[0];
    var ids=c.registros_ids||{};
    // Approve all linked records
    var ops=[];
    if(ids.cobros&&ids.cobros.length){
      ops.push(SB.from('cobros').update({estado_revision:'aprobado',revisado_por:CU.nombre,revisado_at:new Date().toISOString()}).in('id',ids.cobros));
    }
    if(ids.tickets&&ids.tickets.length){
      ops.push(SB.from('tickets').update({estado_revision:'aprobado',revisado_por:CU.nombre,revisado_at:new Date().toISOString()}).in('id',ids.tickets));
    }
    if(ids.caja&&ids.caja.length){
      ops.push(SB.from('caja_movimientos').update({estado_revision:'aprobado',revisado_por:CU.nombre,revisado_at:new Date().toISOString()}).in('id',ids.caja));
    }
    // Mark cierre as approved
    ops.push(SB.from('cierres_diarios').update({estado:'aprobado',revisado_por:CU.nombre,revisado_at:new Date().toISOString()}).eq('id',cierreId));
    // Delete the pending notification
    SB.from('notificaciones').delete().eq('registro_id',cierreId).eq('tipo','pendiente').then(function(){});
    // Notify the agency
    SB.from('notificaciones').insert([{
      para_rol:'agencia',para_zona:c.zona,para_usuario_id:c.agencia_id,
      tipo:'aprobado',
      titulo:'Cierre del '+fmtF(c.fecha)+' aprobado',
      mensaje:CU.nombre+' aprobo tu cierre — Neto: '+fmt(c.neto),
      tabla_origen:'cierres_diarios',registro_id:cierreId,leida:false
    }]).then(function(){});
    Promise.all(ops).then(function(){
      var item=el('cierre-'+cierreId);
      if(item){item.style.transition='opacity .3s';item.style.opacity='0';setTimeout(function(){item.remove();},300);}
      showSB('Cierre aprobado — '+(ids.cobros||[]).concat(ids.tickets||[],ids.caja||[]).length+' registros aprobados','success',5000);
      cargarNotificaciones();
      loadAll();
    }).catch(function(e){showSB('Error: '+diagErr(e),'error');});
  });
}

function pedirRechazoCierre(cierreId){
  var ri=el('ric-'+cierreId);if(ri)ri.style.display='block';
  var inp=el('ric-input-'+cierreId);if(inp)inp.focus();
}

function cancelarRechazoCierre(cierreId){
  var ri=el('ric-'+cierreId);if(ri)ri.style.display='none';
}

function rechazarCierre(cierreId){
  var motivo=((el('ric-input-'+cierreId)||{}).value||'').trim();
  if(!motivo){showSB('Ingresa un motivo','error');return;}
  SB.from('cierres_diarios').select('*').eq('id',cierreId).then(function(r){
    if(r.error||!r.data||!r.data.length)return;
    var c=r.data[0];
    SB.from('cierres_diarios').update({
      estado:'rechazado',revisado_por:CU.nombre,revisado_at:new Date().toISOString(),motivo_rechazo:motivo
    }).eq('id',cierreId).then(function(r2){
      if(r2.error){showSB('Error: '+diagErr(r2.error),'error');return;}
      // Delete pending notif
      SB.from('notificaciones').delete().eq('registro_id',cierreId).eq('tipo','pendiente').then(function(){});
      // Notify agency
      SB.from('notificaciones').insert([{
        para_rol:'agencia',para_zona:c.zona,para_usuario_id:c.agencia_id,
        tipo:'rechazado',
        titulo:'Cierre del '+fmtF(c.fecha)+' rechazado',
        mensaje:CU.nombre+' rechazo tu cierre: '+motivo,
        tabla_origen:'cierres_diarios',registro_id:cierreId,leida:false
      }]).then(function(){});
      var item=el('cierre-'+cierreId);
      if(item){item.style.transition='opacity .3s';item.style.opacity='0';setTimeout(function(){item.remove();},300);}
      showSB('Cierre rechazado','info');
      cargarNotificaciones();
    });
  });
}

function verDetalleCierre(cierreId){
  var det=el('detalle-cierre-'+cierreId);if(!det)return;
  if(det.style.display==='block'){det.style.display='none';return;}
  det.style.display='block';
  det.innerHTML='Cargando detalle...';
  SB.from('cierres_diarios').select('*').eq('id',cierreId).then(function(r){
    if(r.error||!r.data||!r.data.length){det.innerHTML='Error';return;}
    var c=r.data[0];
    var ids=c.registros_ids||{};
    var promises=[];
    if(ids.cobros&&ids.cobros.length)promises.push(SB.from('cobros').select('*').in('id',ids.cobros).then(function(r){return {t:'Cobros',d:r.data||[]};}));
    if(ids.tickets&&ids.tickets.length)promises.push(SB.from('tickets').select('*').in('id',ids.tickets).then(function(r){return {t:'Tickets',d:r.data||[]};}));
    if(ids.caja&&ids.caja.length)promises.push(SB.from('caja_movimientos').select('*').in('id',ids.caja).then(function(r){return {t:'Caja',d:r.data||[]};}));
    Promise.all(promises).then(function(results){
      var h='';
      results.forEach(function(grupo){
        h+='<div style="margin-bottom:10px"><strong style="color:var(--blue)">'+grupo.t+' ('+grupo.d.length+')</strong>';
        h+='<table style="width:100%;font-size:10px;margin-top:4px"><thead><tr><th style="padding:3px;text-align:left">Cobrador</th><th style="padding:3px;text-align:left">Socio/Tipo</th><th style="padding:3px;text-align:right">Importe</th></tr></thead><tbody>';
        grupo.d.forEach(function(rec){
          h+='<tr><td style="padding:3px">'+(rec.usuario_nombre||'-')+'</td><td style="padding:3px">'+(rec.socio||rec.tipo||'-')+'</td><td style="padding:3px;text-align:right;color:var(--green)">'+fmt(rec.importe)+'</td></tr>';
        });
        h+='</tbody></table></div>';
      });
      det.innerHTML=h;
    });
  });
}

function aprobar(tabla,id,usuarioId,usuarioNombre,tipoLabel){
  SB.from(tabla).update({
    estado_revision:'aprobado',
    revisado_por:CU.nombre,
    revisado_at:new Date().toISOString()
  }).eq('id',id).then(function(r){
    if(r.error){showSB('Error: '+diagErr(r.error),'error');return;}
    // Delete the original pending notification(s) for this record
    SB.from('notificaciones').delete().eq('registro_id',id).eq('tipo','pendiente').then(function(){});
    // Notify agency
    SB.from('notificaciones').insert([{
      para_rol:'agencia',
      para_zona:CU.zona,
      para_usuario_id:usuarioId,
      tipo:'aprobado',
      titulo:'Registro aprobado',
      mensaje:CU.nombre+' aprobo tu registro del '+tabla.replace('_movimientos',''),
      tabla_origen:tabla,
      registro_id:id,
      leida:false
    }]).then(function(){});
    // Remove from list
    var item=el('aprov-'+id);
    if(item){
      item.style.transition='opacity .3s';item.style.opacity='0';
      setTimeout(function(){item.remove();},300);
    }
    showSB('Registro aprobado correctamente','success');
    cargarNotificaciones();
    loadAll();
  }).catch(function(e){showSB('Error: '+diagErr(e),'error');});
}

function pedirRechazo(tabla,id,usuarioId,usuarioNombre){
  var ri=el('ri-'+id);
  if(ri)ri.style.display='block';
  var inp=el('ri-input-'+id);
  if(inp)inp.focus();
}

function cancelarRechazo(id){
  var ri=el('ri-'+id);if(ri)ri.style.display='none';
}

function rechazar(tabla,id,usuarioId,usuarioNombre){
  var motivo=((el('ri-input-'+id)||{}).value||'').trim();
  if(!motivo){showSB('Ingresa un motivo para el rechazo','error');return;}
  SB.from(tabla).update({
    estado_revision:'rechazado',
    revisado_por:CU.nombre,
    revisado_at:new Date().toISOString(),
    motivo_rechazo:motivo
  }).eq('id',id).then(function(r){
    if(r.error){showSB('Error: '+diagErr(r.error),'error');return;}
    // Delete the original pending notification(s)
    SB.from('notificaciones').delete().eq('registro_id',id).eq('tipo','pendiente').then(function(){});
    SB.from('notificaciones').insert([{
      para_rol:'agencia',
      para_zona:CU.zona,
      para_usuario_id:usuarioId,
      tipo:'rechazado',
      titulo:'Registro rechazado',
      mensaje:CU.nombre+' rechazo tu registro: '+motivo,
      tabla_origen:tabla,
      registro_id:id,
      leida:false
    }]).then(function(){});
    var item=el('aprov-'+id);
    if(item){item.style.transition='opacity .3s';item.style.opacity='0';setTimeout(function(){item.remove();},300);}
    showSB('Registro rechazado','info');
    cargarNotificaciones();
  }).catch(function(e){showSB('Error: '+diagErr(e),'error');});
}

// ── REQUEST BROWSER NOTIFICATION PERMISSION ───────────────────────────────────
function pedirPermisoNotificacion(){
  if(window.Notification&&Notification.permission==='default'){
    Notification.requestPermission().then(function(p){
      if(p==='granted')showSB('Notificaciones activadas','success');
    });
  }
}



function setTipoCobro(t){var n=el('fc-normal'),a=el('fc-atrasado'),tN=el('tab-cobro-normal'),tA=el('tab-cobro-atrasado');if(t==='normal'){if(n)n.style.display='';if(a)a.style.display='none';if(tN){tN.style.background='var(--blue)';tN.style.color='#fff';tN.style.border='none';}if(tA){tA.style.background='var(--bg3)';tA.style.color='var(--txt2)';tA.style.border='1px solid var(--bord)';}}else{if(n)n.style.display='none';if(a)a.style.display='';if(tA){tA.style.background='var(--amber)';tA.style.color='#000';tA.style.border='none';}if(tN){tN.style.background='var(--bg3)';tN.style.color='var(--txt2)';tN.style.border='1px solid var(--bord)';}var pc=el('pa-cob');if(pc&&CU)pc.value=CU.nombre;var pl=el('pa-loc');if(pl&&CU)pl.value=CU.localidad||'';if(!gv('pa-fec'))sv('pa-fec',today());}}
var _paCuotas=[];var MESESN=['','Enero','Feb.','Mar.','Abr.','May.','Jun.','Jul.','Ago.','Sep.','Oct.','Nov.','Dic.'];
function agregarCuota(){var fec=gv('pa-fec')||today(),mes=gv('pa-mes'),imp=parseImp(gv('pa-imp'));if(!mes){showSB('Mes requerido','error');return;}if(isNaN(imp)||imp<=0){showSB('Importe invalido','error');return;}_paCuotas.push({fec:fec,mes:+mes,imp:imp,fac:gv('pa-fac')||'',tic:gv('pa-tic')||''});sv('pa-mes','');sv('pa-imp','');sv('pa-fec',today());renderCuotasList();}
function quitarCuota(i){_paCuotas.splice(i,1);renderCuotasList();}
function renderCuotasList(){var l=el('pa-cuotas-list');if(!l)return;if(!_paCuotas.length){l.innerHTML='<div style="color:var(--txt3);font-size:12px;padding:12px">Sin cuotas</div>';var rs=el('pa-resumen');if(rs)rs.style.display='none';return;}var tot=_paCuotas.reduce(function(s,c){return s+c.imp;},0);l.innerHTML='<table style="width:100%;font-size:12px"><thead><tr><th style="padding:5px;color:var(--txt3)">Mes</th><th style="padding:5px;text-align:right;color:var(--txt3)">Importe</th><th></th></tr></thead><tbody>'+_paCuotas.map(function(c,i){return '<tr style="border-bottom:1px solid var(--bord)"><td style="padding:5px"><span class="badge bbl">'+MESESN[c.mes]+'</span></td><td style="padding:5px;text-align:right;color:var(--green);font-weight:700">'+fmt(c.imp)+'</td><td><button class="ab ad2" onclick="quitarCuota('+i+')">x</button></td></tr>';}).join('')+'</tbody></table>';var rs=el('pa-resumen');if(rs){rs.style.display='block';el('pa-res-cant').textContent=_paCuotas.length;el('pa-res-total').textContent=fmt(tot);}}
function clearPagoAtrasado(){_paCuotas=[];['pa-soc','pa-obs','pa-fac','pa-tic','pa-imp'].forEach(function(i){sv(i,'');});sv('pa-fec',today());sv('pa-mes','');sv('pa-cob',CU?CU.nombre:'');sv('pa-loc',CU?CU.localidad:'');renderCuotasList();}
function guardarPagoAtrasado(){var soc=gv('pa-soc').trim();if(!soc){showSB('N socio requerido','error');return;}if(!_paCuotas.length){showSB('Agrega cuotas','error');return;}var btn=el('btn-pa');if(btn){btn.disabled=true;btn.textContent='Guardando...';}var rows=_paCuotas.map(function(c){return{fecha:c.fec,localidad:CU.localidad||'',zona:CU.zona||0,socio:soc,mes:c.mes,importe:c.imp,factura:c.fac||null,ticket_num:c.tic||null,cobrador:CU.nombre,empresa:gv('pa-emp'),estado:gv('pa-est'),obs:'PAGO ATRASADO',usuario_id:CU.id,usuario_nombre:CU.nombre,usuario_numero:CU.numero,estado_revision:window._saveMode==='pendiente'?'pendiente':'aprobado'};});var ins=0,err=[];function next(i){if(i>=rows.length){if(btn){btn.disabled=false;btn.textContent='Guardar pago atrasado';}if(!err.length){showSB(ins+' guardadas','success');clearPagoAtrasado();loadAll();}else showSB('Errores','error');return;}SB.from('cobros').insert([rows[i]]).then(function(r){if(r.error)err.push(r.error.message);else ins++;next(i+1);}).catch(function(e){err.push(e.message);next(i+1);});}next(0);}
function actualizarComprobante(){var tipo=gv('c-comp-tipo'),num=gv('c-comp-num');var lbl=el('c-comp-label');if(lbl)lbl.textContent='N de Factura o Ticket';var fac=el('c-fac'),tic=el('c-tic');if(tipo==='factura'){if(fac)fac.value=num;if(tic)tic.value='';}else{if(fac)fac.value='';if(tic)tic.value=num;}var dl=el('c-comp-list');if(!dl)return;var lista=tipo==='factura'?[...new Set(cobros.filter(function(r){return r.factura;}).map(function(r){return r.factura;}))]:[...new Set(cobros.filter(function(r){return r.ticket_num;}).map(function(r){return r.ticket_num;}))];dl.innerHTML='';lista.slice(0,30).forEach(function(v){var o=document.createElement('option');o.value=v;dl.appendChild(o);});}
function cargarNumerosRecientes(){actualizarComprobante();}
function onFacSelChange(){}function syncFacSel(){}function onTicSelChange(){}function syncTicSel(){}
window.onload=function(){
  // Restore sidebar collapsed state
  if(localStorage.getItem('sn_sidebar_collapsed')==='1'&&window.innerWidth>768){
    document.body.classList.add('sidebar-collapsed');
  }

  // Check for personal access link: ?u=cob25 or ?u=laura or ?u=0
  var params=new URLSearchParams(window.location.search);
  var quickUser=params.get('u');
  if(quickUser){
    quickUser=quickUser.toLowerCase().trim();
    // If it starts with 'cob' or is numeric, use cobrador login mode
    var isCobLink=quickUser.indexOf('cob')===0||/^\d+$/.test(quickUser);
    setTimeout(function(){
      if(isCobLink){
        setLoginMode('usuario');
        var prefix=quickUser.indexOf('cob')===0?quickUser:'cob'+quickUser;
        sv('lusername',prefix);
        var lp=el('lpass');if(lp){lp.focus();}
      } else {
        // Try to find user by numero
        var asNum=parseInt(quickUser,10);
        if(!isNaN(asNum)){
          var sel=el('lnum');
          if(sel){
            for(var i=0;i<sel.options.length;i++){
              if(parseInt(sel.options[i].value,10)===asNum){sel.selectedIndex=i;break;}
            }
          }
        }
        setLoginMode('numero');
        var lp2=el('lpin');if(lp2)lp2.focus();
      }
    },300);
  }

  var urlV=localStorage.getItem('sn_url')||'';
  var keyV=localStorage.getItem('sn_key')||'';
  if(urlV){var e=el('cfg-url');if(e)e.value=urlV;}
  if(keyV){var e=el('cfg-key');if(e)e.value=keyV;}
  if(urlV&&keyV){
    try{
      SB=window.supabase.createClient(urlV,keyV);
      isConn=true;setDot('ld');
      var cb=el('connbar');if(cb){cb.className='cbar ok';cb.id='connbar';}
      var ct=el('conntxt');if(ct)ct.textContent='Conectado - ingresa con tu usuario y PIN';
      var su=localStorage.getItem('sn_u');
      if(su){
        try{
          var saved=JSON.parse(su);
          SB.from('usuarios').select('*').eq('id',saved.id).eq('activo',true).then(function(r){
            if(r.error||!r.data||!r.data.length){doLogout();return;}
            CU=r.data[0];localStorage.setItem('sn_u',JSON.stringify(CU));
            el('lw').style.display='none';el('aw').style.display='block';
            if(CU.rol==='cobrador')setLoginMode('usuario');
            buildNav();loadAll();
            var startPg=(CU.rol==='cobrador'||CU.rol==='agencia')?'fc':'dashboard';
            setTimeout(function(){go(startPg);},80);
          }).catch(function(){doLogout();});
        }catch(e2){doLogout();}
      }
    }catch(e){
      var ct=el('conntxt');if(ct)ct.textContent='Error al conectar - verifica credenciales';
    }
  }
  window.addEventListener('beforeunload',function(){if(cobros.length||tickets.length||cajaMov.length)exportCSV();});
};