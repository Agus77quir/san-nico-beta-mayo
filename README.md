<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0,viewport-fit=cover">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
  <meta name="apple-mobile-web-app-title" content="San Nicolas">
  <meta name="theme-color" content="#0f1117">
  <meta name="description" content="San Nicolas Renacimiento - Sistema de Gestion Central">
  <link rel="manifest" id="pwa-manifest">
  <title>San Nicolas Central</title>
  <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div id="lw">
  <div class="lcard">
    <div class="llogo"><img src="data:image/png;base64,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" style="height:48px;object-fit:contain;margin-bottom:4px;mix-blend-mode:screen"><br>San Nicolás</div>
    <div class="lsub">Renacimiento - Sistema de Gestion Central</div>

    <!-- Estado de conexion -->
    <div id="connbar">
      <span class="cbdot"></span>
      <span id="conntxt">Sin conexion a Supabase</span>
    </div>

    <div class="lerr" id="lerr"></div>

    <!-- Pestanas de modo login -->
    <div style="display:flex;gap:6px;margin-bottom:14px">
      <button id="tab-num" onclick="setLoginMode('numero')"
        style="flex:1;padding:9px;border-radius:8px;font-size:12px;font-weight:700;cursor:pointer;font-family:inherit;background:var(--blue);color:#fff;border:none;transition:all .15s">
        Admin / Agencia
      </button>
      <button id="tab-usr" onclick="setLoginMode('usuario')"
        style="flex:1;padding:9px;border-radius:8px;font-size:12px;font-weight:700;cursor:pointer;font-family:inherit;background:var(--bg3);color:var(--txt2);border:1px solid var(--bord);transition:all .15s">
        Cobrador
      </button>
    </div>

    <!-- Modo 1: Numero + PIN (admins y agencias) -->
    <div id="mode-numero">
      <div class="lfg">
        <label>Usuario</label>
        <select id="lnum">
          <optgroup label="── Administración Central ──">
            <option value="0">0 — Administrador Central</option>
          </optgroup>
          <optgroup label="── Admin Zona 1 ──">
            <option value="1">1 — Laura (Admin Zona 1)</option>
            <option value="3">3 — Sole (Admin Zona 1)</option>
          </optgroup>
          <optgroup label="── Admin Zona 2 ──">
            <option value="2">2 — Juan (Admin Zona 2)</option>
            <option value="4">4 — Ceci (Admin Zona 2)</option>
          </optgroup>
          <optgroup label="── Agencias Zona 1 ──">
            <option value="5">5 — Catuna</option>
            <option value="6">6 — Chamical</option>
            <option value="7">7 — Chepes</option>
            <option value="8">8 — Malanzán</option>
            <option value="9">9 — Milagro</option>
            <option value="10">10 — Olta</option>
            <option value="11">11 — Tama</option>
            <option value="12">12 — Ulapes</option>
            <option value="13">13 — Villa Unión</option>
            <option value="14">14 — Vinchina</option>
          </optgroup>
          <optgroup label="── Agencias Zona 2 ──">
            <option value="15">15 — Aimogasta</option>
            <option value="16">16 — Belén</option>
            <option value="17">17 — Campanas</option>
            <option value="18">18 — Chilecito</option>
            <option value="19">19 — Famatina</option>
            <option value="20">20 — Fiambalá</option>
            <option value="21">21 — La Costa - Anillaco</option>
            <option value="22">22 — Los Sauces</option>
            <option value="23">23 — Sanagasta</option>
            <option value="24">24 — Tinogasta</option>
          </optgroup>
          <optgroup label="── Cobradores Zona 1 ──">
            <option value="27">27 — Cobrador Chepes</option>
            <option value="28">28 — Ruarte, Liliana (Chepes)</option>
            <option value="29">29 — Ruarte, Néstor (Chepes)</option>
            <option value="30">30 — Agüero, Carlos (Chepes)</option>
            <option value="31">31 — Zárate - Ulapes</option>
            <option value="37">37 — Ámbil (Milagro)</option>
            <option value="38">38 — El Quemado (Milagro)</option>
            <option value="39">39 — Oliva, Carlos (Milagro)</option>
            <option value="40">40 — Muni. - Milagro</option>
            <option value="41">41 — Capdevilla Catuna</option>
            <option value="53">53 — Cobrador Chamical</option>
            <option value="54">54 — Toledo, Darío (Chamical)</option>
            <option value="55">55 — Latiff, Jorge (Villa Unión)</option>
            <option value="56">56 — Ormeño W. Pagancillo</option>
            <option value="57">57 — Aicuña (Villa Unión)</option>
            <option value="58">58 — Páez, Raúl (Villa Unión)</option>
            <option value="59">59 — Páez, Luis (Villa Unión)</option>
            <option value="60">60 — Cob. Villa Castelli</option>
            <option value="61">61 — Cobrador Vinchina</option>
            <option value="63">63 — Cobrador Olta</option>
          </optgroup>
          <optgroup label="── Cobradores Zona 2 ──">
            <option value="25">25 — Vega, Yanina (Sanagasta)</option>
            <option value="26">26 — Mercado, Silvia (La Costa)</option>
            <option value="32">32 — Rodríguez, Ariel (Los Sauces)</option>
            <option value="33">33 — Leiva, Nicolás (Los Sauces)</option>
            <option value="34">34 — Córdoba, D. (Aimogasta)</option>
            <option value="35">35 — Ocampo, José Luis (Aimogasta)</option>
            <option value="36">36 — Cobrador Aimogasta</option>
            <option value="42">42 — Palo Blanco (Fiambalá)</option>
            <option value="43">43 — Delgado, Teresa (Fiambalá)</option>
            <option value="44">44 — Medanitos (Fiambalá)</option>
            <option value="45">45 — Bordón, Susana (Fiambalá)</option>
            <option value="46">46 — Nonogasta (Chilecito)</option>
            <option value="47">47 — Sañogasta (Chilecito)</option>
            <option value="48">48 — Guzmán Chilecito</option>
            <option value="49">49 — Cobrador Chilecito</option>
            <option value="50">50 — Cobrador Chilecito 2</option>
            <option value="51">51 — Anguinán (Chilecito)</option>
            <option value="52">52 — Cobrador Famatina</option>
            <option value="62">62 — Giménez, Jorge (Belén)</option>
            <option value="64">64 — González, Eva (Tinogasta)</option>
            <option value="65">65 — Cobrador Tinogasta</option>
            <option value="66">66 — Dábalo, Luis (Tinogasta)</option>
            <option value="67">67 — Castro, Alejandro (Tinogasta)</option>
            <option value="68">68 — Barrionuevo, C. (Tinogasta)</option>
            <option value="69">69 — AG - Campaña</option>
          </optgroup>
        </select>
      </div>
      <div class="lfg">
        <label>PIN</label>
        <div class="pinrow">
          <input type="password" id="lpin" placeholder="Ingresa tu PIN" maxlength="30"
            onkeydown="if(event.key==='Enter')doLogin()">
          <button class="pintgl"
            onclick="var i=document.getElementById('lpin');i.type=i.type==='password'?'text':'password';this.textContent=i.type==='password'?'mostrar':'ocultar'">mostrar</button>
        </div>
      </div>
    </div>

    <!-- Modo 2: Usuario + Contraseña (cobradores) -->
    <div id="mode-usuario" style="display:none">
      <div class="lfg">
        <label>Nombre de usuario</label>
        <input type="text" id="lusername" placeholder="Ej: cob25"
          autocomplete="username"
          onkeydown="if(event.key==='Enter')document.getElementById('lpass').focus()">
      </div>
      <div class="lfg">
        <label>Contraseña</label>
        <div class="pinrow">
          <input type="password" id="lpass" placeholder="Tu contraseña" maxlength="50"
            onkeydown="if(event.key==='Enter')doLogin()"
            autocomplete="current-password">
          <button class="pintgl"
            onclick="var i=document.getElementById('lpass');i.type=i.type==='password'?'text':'password';this.textContent=i.type==='password'?'mostrar':'ocultar'">mostrar</button>
        </div>
      </div>
      <div style="font-size:11px;color:var(--txt3);margin-bottom:8px;line-height:1.5">
        Usuario: <strong style="color:var(--txt)">cob</strong> + tu numero &nbsp;(Ej: <strong style="color:var(--blue)">cob25</strong>)<br>
        Contraseña: tu PIN actual &nbsp;(<strong style="color:var(--txt)">1234</strong> por defecto)
      </div>
    </div>

    <button class="lbtn" id="lbtn" onclick="doLogin()">Ingresar</button>

    <!-- Configuracion Supabase -->
    <div class="lsep">
      <div class="lsep-line"></div>
      <span class="lsep-txt">Base de datos Supabase</span>
      <div class="lsep-line"></div>
    </div>
    <div class="cfgbox">
      <div class="cfgbox-hint">
        Pega las credenciales de <strong>Supabase &rarr; Settings &rarr; API</strong>
      </div>
      <div class="lfg" style="margin:0 0 8px">
        <label>Project URL</label>
        <input type="text" id="cfg-url" placeholder="https://xxxx.supabase.co" style="font-size:12px">
      </div>
      <div class="lfg" style="margin:0">
        <label>Anon / Public Key</label>
        <div class="pinrow">
          <input type="password" id="cfg-key" placeholder="eyJhbGci..." style="font-size:12px;padding-right:70px">
          <button class="pintgl"
            onclick="var i=document.getElementById('cfg-key');i.type=i.type==='password'?'text':'password';this.textContent=i.type==='password'?'mostrar':'ocultar'">mostrar</button>
        </div>
      </div>
      <div id="cfg-result"></div>
      <div class="cfgbtns">
        <button class="btn-test" id="btn-test" onclick="testConn()">Probar</button>
        <button class="btn-connect" id="btn-connect" onclick="saveConn()">Guardar y conectar</button>
      </div>
    </div>
  </div>
</div>

<div id="aw">
  <div class="sdoverlay" id="sdov" onclick="closeSidebar()"></div>
  <aside class="sidebar" id="sidebar">
    <div class="sdhead" style="position:relative">
      <div class="sdbrand" style="display:flex;align-items:center;gap:8px"><img src="data:image/png;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/4gHYSUNDX1BST0ZJTEUAAQEAAAHIAAAAAAQwAABtbnRyUkdCIFhZWiAH4AABAAEAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAACRyWFlaAAABFAAAABRnWFlaAAABKAAAABRiWFlaAAABPAAAABR3dHB0AAABUAAAABRyVFJDAAABZAAAAChnVFJDAAABZAAAAChiVFJDAAABZAAAAChjcHJ0AAABjAAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAAgAAAAcAHMAUgBHAEJYWVogAAAAAAAAb6IAADj1AAADkFhZWiAAAAAAAABimQAAt4UAABjaWFlaIAAAAAAAACSgAAAPhAAAts9YWVogAAAAAAAA9tYAAQAAAADTLXBhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABtbHVjAAAAAAAAAAEAAAAMZW5VUwAAACAAAAAcAEcAbwBvAGcAbABlACAASQBuAGMALgAgADIAMAAxADb/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7/2wBDAQUFBQcGBw4ICA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh7/wAARCAI0AVADASIAAhEBAxEB/8QAHAAAAwACAwEAAAAAAAAAAAAAAAECBgcEBQgD/8QARBAAAgEDAgMFBQUECAYCAwAAAAECAwQFETEGEiEHQWFxgRMiUZGhFEJDscEjMlJyU2KCkqKywtEIMzZz4fAVJDRUdP/EABsBAAIDAQEBAAAAAAAAAAAAAAACAQMFBgQH/8QAMhEAAgIBAgIGCgIDAQAAAAAAAAECAwQFERIhIjFRYZGhBhMyQXGBscHR8DPxFCPhQv/aAAwDAQACEQMRAD8A8ZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALq9EAABkWF4OzWS5ZyofZKL+/X6NrwjuzN8LwRh7DlncQd9WXfVXuekdvnqe/H02+7ntsu88lubVXy33fca3xGEymVklZWk5w161H0gvV9DNsN2f21JRqZW4dxP+ipaxh6vd/QzeMYwiowioxS0SS0SBm3j6TTVzn0n5eBm259k+UeSOovMBiquMq2VOwtqalBqLjTSaenR676mmDfkjRF3FwuqsGtHGclp6nh1muMeBxW3X9j1adNviTZ8gADDNMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7LDYLK5eSVjZ1KkNdHUa5YL+0+g0ISm9ordiylGC3k9kdafaztbm8rqha0Kleo9owi2zYuE7Obaly1MvdOvL+io6xj6y3fpoZpYWNnj6HsbK2pW9P4Qjpr5/E1sfRrZ87HwrzM67VK48oc/oa3wnZ7f3HLVyleNpB/hw96b/RfUzfC8OYjEJO0tIuqvxqnvT+fd6aHcMT2NvHwKKOcVz7WZluXbb7T5EvuJe5T7iXuesoRLExsTAZEyNH5uHs8zfU9NOW4qLTykzeEjS3FUeTiTIrTT/7E383qYetroRfeammvpNHWAAHOmuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH3srS6va6oWdvVr1X92nFyZmmC7OL6vy1ctcRtId9KnpKb9dl9T0UYt172rjuUXZVVC6ctjBUm2kk23skZLg+Cc5ktKk6H2Kg/v1+jflHf8AI2fhOHMPh0nZWcFVX40/em/V7emh2zNzH0NLndL5L8mNfrLfKpfNmKYPgXC47lqXEHfVl15qy91eUdvnqZRGMYQUIRUYpaJJaJIoT2NmqiulbVrYy53WWveb3EJjExyYiYnsNiexBYiX3Evcp9xL3IGRLExsTAZEyNNcZf8AVGQ/7v6I3LI0xxdLn4myD00/byXy6GLrX8Ufiaem+2/gdUAAc2bAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4pykoxTbb0SXeACAynA8CZ3J8tSrRVjQf366ak14R3+ehn2B4DweN5alek7+uvvV17qfhHb56mljaVkX89tl2szcnVcejlvu+xGrcJw9l8zJfYbKpOnro6svdgvV/p1M8wfZtaUeWrl7mVzPvpUtYw9Xu/oZ+oxilGKUYpaJJdEJm9j6NRVzn0n39XgYV+s328odFeficaxsbOwt1Qsralb0192nFLXz+J9xvYRqJKK2Rm7uT3ZIMAYFkRCewxPYVlsRCYxMUtiJiew2J7EFiJfcS9yn3EvcgZEsTGxMBkTI0zxhFR4nyCX9M38+puaRprjL/qjIf91/kjF1r+KPxNPTfbfwOoAAObNgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7bBcOZnNTSsLKpOnro6svdpr+0+nouo8K5WS4YLdiWWQrjxTeyOpORYWV3f3Ct7K2q3FV/dpxcmbPwHZjZ0OWrmbqVzPd0aOsYer3f0M5x9hZY+3VvY2tK3pL7tOKWvn8WbWNoVs+dr4V4sw8rX6a+VS4n4I1dgezS+r8tXMXMbSHfSp6Sqer2X1M+wfDeGwsU7GyhGqt60/em/V7emh3MiWdBjadj43OEefa+s57J1LIyeU5cuxckJiGxHsZ5UJ7ksp7ksVlkRPYQ3sIVlkSQYAyC2IhPYYnsKy2IhMYmKWxExPYbE9iCxEvuJe5T7iXuQMiWJjYmAyJkaV4okpcR5Fr/8AZmvlJo3VI0blqntsrd1ddeevOWuvxkzD1t9CC7zU01dKTOKAAc6a4AAAAAAAAAAAAAAAAAAAAAfexs7q+uI29nbVbitLaFODk/oZ5w72XZK65a2ZuI2NPf2UNJ1H+i+vkenHxLsh7Vx3+nieXJzKMZb2y2+vga9inJpJNt9El3mVcP8AAOfyvLUqUPsNu+vtLjo2vCO79dF4m3cBwrg8Gk7Gyh7ZLrXqe/Ufq9vTQ7dnQY3o/Fc75b9y/JzuV6RSfKiO3e/wYfgOz3A4vlqXFN5CuvvV17ifhDb56mWKMYRUIRUYpaJJaJFsmRu049VC4a47HP3ZFt8uKyTbJe5JT3JLSpEyJZUiWA6ExDYhWWIT3JZT3JYrLIiewhvYQrLIkgwBkFsRCewxPYVlsRCYxMUtiJiew2J7EFiJfcS9yn3EvcgZEsTGxMBkfC8qqha1a72pwlN+i1NEttttvVvdm4uN7n7LwtfT16zp+zX9pqP5M04c5rU95xj2L6/0bOmx6LkAABiGkAAAAAAAAAAAAAGU8NcB8Q5xRq07X7JbP8e41gmvilu/RaeJsvhzsxwON5at/wA2Trrr+1XLTT/kW/q2aWLpWTkc0tl2sy8vV8XG5OW77FzNP4Hh/MZyryYywq11rpKpppCPnJ9DY/DvZRQpctbPXjrS39hbvSPrJ9X6aeZs6jSpUKUaVGnCnTitIwhFJJeCQS3OhxtDoq52dJ+Xgc3la/kXcq+ivPx/BwsXjMfirZW+Os6NtT71Tjo35vdvzOSy2QzYjFRWyWyMSUnJ7ye7IZDLZDGIEyZFMmRAyJe5JT3JIJRMiWVIlgOhMQ2IVliE9yWU9yWKyyInsIb2EKyyJIMAZBbEQnsMT2FZbEQmMTFLYiYnsNiexBYiX3Evcp9xL3IGRLExsTAZGEdrN3yY60sk+tWo6kl4RWn5v6GuDIu0O/8AtvEtaEZa07ZKjHzX731b+Rjpx2oW+tyJNe7l4HRYkOCpIAADxHpAAAAAANudlvZ7QlbUc3n6CquolO3tZr3VHulNd+vctvj4erDw7Muzgh/R483Oqw6/WWfJdphnCHA2b4jca1KkrWye9zWWif8AKt5fl4m3uFuAsBgYwqRt1eXa3uLhKTT/AKsdo/n4mV6KPuxSSS0SXcJnZYekUY2z24pdr+yOIzdayMvdb8Mexfd+8l7Esp7Es0jLQmRLctkS3AkTIZbIZBJDIZbIYEiZMimTIgZEvckp7kkEomRLKkSwHQmIbEKyxCe5LKe5LFZZET2EN7CFZZEkGAMgtiIT2GJ7CstiITGJilsRMT2GxPYgsRL7iXuU+4l7kDIlnX8RZGGKw9xey01hH3E++T6JfM7Bmsu0/Mq7yEcXQnrStnrU02dT4ei/NnkzslY9Ll7/AHfE9WLT62xL3GH1JyqTlOcnKUm22+9kgBxh0YAAAAAB3GL4cyWRxdxkaMIwoUYuSc206mm6j8R4Vyse0VuLKcYLeTPv2eYqnmeMsdY1oqVF1PaVU9nGCcmvXTT1PSvwPPvYzcwt+P7JTaSrQqU038XFtflp6noJ9x13o9GKx5SXW39kcR6TTk8qMX1JfdiluSypbks3znkS9iWU9iWKOhMiW5bIluBImQy2QyCSGQy2QwJEyZFMmRAyJe5JT3JIJRMiWVIlgOhMQ2IVliE9yWU9yWKyyInsIb2EKyyJIMAZBbEQnsMT2FZbEQmMTFLYiYnsNiexBYiX3Evcp9x1ufy1rhsfO7upbdIQT6zl8ELOcYRcpPkh4Rcmkjr+Ns9HCYx+yad5WTjRj8PjJ+C/M0/KUpScpNyk3q23q2zmZrJXOWyFS9upazn0SW0Y9yXgcI4/Oy3k2brqXUdHi46pht731gAAeI9IAByMbZ18hfUbO2jzVasuVeHxb8FuSk5PZENpLdnb8GcP1M5f/tOaNnRadaa7/hFeL+i9DbtGhRpW0belSjCjGPKoJdEvgcXCY23xONpWVuvdgvel3zl3tnOWx1+DhrGr2ftPrOeysh3T7l1GlchRuuHOJmqLcKtpXVShJ96T1i/loeiuFs3acQYW3ydpJaVFpUhrq6c++L8vqtGa34/4deYs1d2kdb23i9F/SR35fP4f+TC+BOKr3hTLOpGM6lpUfLc27emq+K+El/4PFj3PTMlwn7Ev3y95GfiLU8dTh7cfPu/B6PluSziYfJ2OYx9O/wAfXjWoVF0a3T7013NfA5bOrjJSSafI4lxcW4yWzRL2JZT2JYDITIluWyJbgSJkMtkMgkhkMtkMCRMmRTJkQMiXuSU9ySCUTIllSJYDoTENiFZYhPcllPclissiJ7CG9hCssiSDAGQWxEJ7DE9hWWxEJjExS2ImJ7DZiHFfG1njVO1x/Jd3a6N6606b8X3vwRTdfXTHim9keiqqdr4Yo7jiPOWWEtPb3U9ZtP2dKL96b8PDxNQ5/MXmavndXcl06Qpx/dgvgjjZG9ushdzurytKtWnvKX5L4LwOOcrnahPJey5R7Pyb+LiRoW75sAADPPYAAAABsTssxKp29XL1Y+9U1p0de6K/efq+nozX1ClOvXp0aS5p1JKMV8W3ojeWNtadjj6FnS/co01BeOi3NfR6OO12P/z9TP1C3hhwr3nKGthDWx05iMcdzFeMeD6GXc7yycKF7u+6NXz+D8TKo7lLvKrqIXR4JrdE12yqlxRZqHh/N53gnMTiqc4Jte3tqv7lRfHz+Ekbv4S4qxPE1oqljV5K8VrVt5vScP8AdeK/8HQ5jE2GXtvYX9vGol+7LaUH8U+41zm+EsxgLpZDEVq1anTfNGpR1VWn5pfmvoZ9bydNfR6dfZ70WZONj6it30bO33P4m/3sSzU/CPatKEYWvEdFz06K6ox6/wBqP6r5GzsbkbHJ2yucfd0bmk/vU5J6eD+D8GbWLnU5S3rfPs95zWVp9+JLayPLt9xyWRLctkS3PWeQTIZbIZBJDIZbIYEiZMimTIgZEvckp7kkEomRLKkSwHQmIbEKyxCe5LKe5LFZZET2EN7CFZZEkGAMgtiIT2Gddms1jMRR9pf3UKTa1jDecvJLqVznGC4pPZF1cXJ7RW7OedRn+IcXhabd5cJ1d40Ye9OXp3eb0MD4h7QL+75qGLh9jovp7R9ajX5R9OviYZVqTq1JVKs5TnJ6ylJ6tvxZh5Wsxj0aVu+33G1jaXJ87eXcZJxNxlk8upUKT+x2j6ezpy96S/rS7/JaIxkAOftundLim92bVdcK1wxWwAAFY4AAAAAAABkXZ3Zq74noSktYW8XWfp0X1aNtmB9ktrpRvr1r96UaUX5dX+aM8Or0mvgx0+3mYWfPit27ChrYQ1saZ4WOO5S7yY7lLvJFGhrcSGtwFZj/ABFwficxzVeT7LdPr7akt3/WWz/PxMGu+H+KOF7l3uPq1nGP49pJ7f1o76eeqNtrcZ4b9OqtfEujLtR6a82ytcL5rsZgfD3axe0OWlnLKN1FdHWoaQn6x2fpobCwXFmAzfLGxyFN1n+DU9ypr5Pf01OgzXDGFy7crq0jGs/xaXuT9Wt/XUwvMdnN9R1qYu7hcxXVU6nuT9Hs/oVxt1DF6/8AZHz/AHxKbMTAyea/1y8v3wN2shmiLXiLjThapGjXqXMaUeipXUXOm/BN938rMswvavaVOWnl8dUoS2dW3fPHz5X1XzZ6adZx5vhs3i+8z79DyYLir2mu79+m5shkM63EcR4PL6LH5K3qzf4blyz/ALr0Z2TNSFkZreL3RlTrnW+Ga2feJkyKZMhiES9ySnuSQSiZEsqRLAdCYhsQrLEJ7ksp7ksVlkRPYQ5NKLbaSW7ZjGd43weM5qcKzvK66clDqk/GW35lN11dK4pvY9NNNlstoLcyQ6nO8RYjDRavbuKq6dKMPem/Tu9dDWed46zWR5qdCorCg/u0X7z85b/LQxeTcpOUm229W33mFk65FcqVv3v8G5jaNLrte3cjNM/2g5G75qOMpqyovpzv3qjX5L0+ZhtarUrVZVa1SdSpJ6ylOWrb8WyAMK/Jtve9j3NunHrpW0FsAABQXAAAAAAAAAAAAAAAAG1+zeh7HhajPTR1qk5v58v+kyY6nhGn7LhrHx001t4y+a1/U7Y7bFjw0wXcjm75cVkn3lDWwhrY9BQxx3KXeTHcpd5Io0NbiQ1uArKW4xLcYIRgiiUUMVSJqQhVpunUhGcJdHGS1TMeynBPD9/q1aO1qPrz275f8O30MjGhbKa7VtOKYQusqe8HsawynZtfUm5429pXEe6FRckvn1T+hwYZLjnhjpVqXtOjHurL2tLyTeqXozbpT6rRmfLSa0+KmTg+5/v1PWtTnJcN0VNd6NfYntVqLlhlsZGXxqW0tH/dl/uZdiuNeG8lyxp5GFCo/uXH7N/N9H6M+GU4UwGS5nXx1KFR/iUvclr8em/rqYplezJe9PF5Hyp3Ef8AVH/YFLUqOya8/t9yt1abf2wfl9/sbRjKM4qUZKUWtU09UxGkniuNOGpudrG8p009dbafPTfi4rX6o7LE9puWt2qeStKN3FPrKP7Of06fRDw1mtPhvi4P9/eopnodjXFRJTX7+9ZtmRLMUxvaFw5eJKtWq2c392tTenzjqvnodxHiLATipLN47R/G5gn8mzRhl0WLeM14mfPDvre0oNfI7JiMdyvG3DlhTb+3xupraFv77frt9TB852j5S65qeNowsaT6c79+p830Xy9TzZGp41C5y3fYuZ7MbTMm/qjsu18jZ+Rv7LH0XWvrqlb0/jUklr5fEwnOdpNnS5qeItZXM+6rV1jD0W7+hrS7urm8ryr3VerXqy3nUk5P6nxMDI1y2fKpcK8Wb+NolVfOx8T8Edtm+I8xmG1e3s5Un+FD3YfJb+up1IAY87JWPim92bEK41rhitkAAAg4AAAAAAAAAAAAAAAAAAAAAAABu/BxUcLYxS0Stqa0+Huo5xxcY08dbNNNOjDRr+VHKO7r5RRzE+tlDWwhrYcrY47lLvJjuUu8kUaGtxIa3AVlLcYluMEIwRRKKGKpANCGhipgUSUMIxoYkMkqYzgZPCYnKRav8fQrt/fcdJf3l1+pzxoiUIzW0luiFOUHvF7MwTK9mmNrayx15XtZPaM17SH6P6sxPLcA8Q2OsqVvC9pr71CWr/uvR/LU3Qhmfdo+LbzS4X3Hvp1nKq63xLvPOFxQr21V0rijUo1FvCpFxa9GfM9G3lnaXtH2V5a0bin/AA1YKS+pi+V7OsBeaytlWsaj/o5c0dfFS1+jRk3aBbHnXJPyNaj0gqlyti15mmgM3y/Zrm7XWVjVoX0Fsk/Zz+T6fUxPI42/x1T2d9Z17aXd7SDSfk+8yLsS6j+SLX72mvRl0X/xyT/ew4gAB5z0gAAAAAAAAAAAAAAAAAAAAAAAAAAAG7sDJTwdhJbO2ptf3Uc86fg+p7XhjHy110oRj8un6HcHc0PeuL7kczYtptFDWwhrYtKmOO5S7yY7lLvJFGhrcSGtwFZS3GJbjBCMEUSihiqQDQhoYqYFElDCMaGJDJKmMaENEoRjQxIYxWylsOIlsOIwjKFVpU61J061OFSEujjKOqfoMa2DrF32MYy/AXDeQ1lGzdnUf3raXKv7vWP0MPy/ZdkqOs8ZfUbuP8FRezl+qf0NslGffpeLd1x2fdyPfRq2XR1T3XfzPOeWweXxUmshjrigl99x1g/KS6P5nXHp5pSi4ySaa0afeY9l+CeG8om6uOhQqP8AEt/2b89F0fqjIv8AR6S51S8fybWP6SRfK6G3evx/00EBsvM9lNzDWeIyMKq7qdwuV/3l0fyRhma4ZzuH5nf42vTpr8WK54f3lqjHvwMij24PbxRtY+oY2R/HNb9nUzpwADxntAAAAAAAAAAAAAAAANr9m1b2vCtGGuvsqk4f4tf1MmMF7JblO0vrRvrCpGovVaP/ACozo7LT58ePB9305HPZceG6SKGthDWx7Dyscdyl3kx3KXeSKNDW4kNbgKyluMS3GCEYIolFDFUgGhDQxUwKJKGEY0MSGSVMY0IaJQjGhiQxitlLYcRLYcRhGUNbCGtgEZRRJQEDRUSUVEkgtFEookhnR5rg7hzLpyusZShVf4tFeznr8dVv66mE5vslklKeFyfN8KV0tP8AFH/Y2qthx3PFfp2Nf7cOfauR7sfU8rH9ib27HzR5rz3DuawdTlydhVox10VTTmhLykunpudUeqatOnVpyp1YRnCS0lGS1TXijAuLezHF5GM7nDOOOumtfZ/gzfl9306eBg5egTguKh79z6/3wOhw/SKE3w3rbvXV++JpMDsM9hclg712mTtZ0Km8W+sZr4xezR15z8oSg3GS2Z0cJxnFSi90wAAFGAAAAMl7OL37JxLTpyekLmDpPz3X1WnqbYNDW9WpQr069KXLUpyU4v4NPVG78Te08jjbe9pactaClp8H3r0eqOj0W7eEq37uZkajXtJT7TmDWwhrY2zLY47lLvJjuUu8kUaGtxIa3AVlLcYluMEIwRRKKGKpANCGhipgUSUMIxoYkMkqYxoQ0ShGNDEhjFbKWw4iWw4jCMoa2ENbAIyiiSgIGiokoqJJBaKJRRJDLWw47iWw47gQUUiSkSQcLN4jH5uwlZZK2hXpS213i/jF7pmi+P8Agm94YuHWpuVzjZy0p19Osf6s/g/HZ/Q9BxPnd29C7tqltc0oVqNWLjOE1qpJ9zM/P06vMjz5S9zNHT9Utwpcucfevx3nlQDMO0rg2twzfqvbKVTGV5P2M31dN/wSf5PvXkzDzhr6J0Tdc1s0d/j315Fasre6YAAFRcBnnZbmFCpUw9efSbdShr8fvR/X0ZgZ9LetVt69OvRm4VKclKMlumj0YuQ8e1TRVfUrYOLN9jWx1HC2Zo5vFwuYuMa0fdrU192X+z7jt1sdnXONkVKPUzm5xcJcLHHcpd5Mdyl3lhWNDW4kNbgKyluMS3GCEYIolFDFUgGhDQxUwKJKGEY0MSGSVMY0IaJQjGhiQxitlLYcRLYcRhGUNbCGtgEZRRJQEDRUSUVEkgtFEookhlrYcdxLYcdwIKKRJSJIKiMURkis4uXx1plsZWx99SVShWjyyXevg18Gt0zzhxbgrrh3OVsbc6yUfepVNNFUg9pL/wB3TPTaMN7WOGln+HZXFvT5r+yTqUtF1nH70PVLVeK8TH1jAWTVxxXSj5rs/Bs6JqLxbvVyfQl5Pt/J5/AAOIO/AAAAOy4czFzhcjG6oPmi+lWm30nH4efwZuPD5G1yljC8s6nPTluu+L7013M0Udpw5nL3B3nt7aXNTloqtKT92a/R+Jp6fnvHfDL2X5Hiy8RXLij1m7Y7lLvOr4ezdjmrb21pU99f8ylL96D8V+p2i7zqYTjNKUXujAlFxbTXMaGtxIa3HEZS3GJbjBCMEUSihiqQDQhoYqYFElDCMaGJDJKmMaENEoRjQxIYxWylsOIlsOIwjKGthDWwCMookoCBoqJKKiSQWiiUUSQy1sOO4lsOO4EFFIkpEkFRGKIyRWUhx7xIce8lCs88dqmBWC4srxow5bS6/b0NF0Wr96Po9fTQxM3j2741XPCtHIxj+0sq61fwhP3X9eQ0ccBquMsfKlFdT5r5n0bR8p5OJGUutcn8v+AAAZxqAAAAH3sbu5sbmNzaVp0a0NpRf/uqNjcM8eWtyo2+XUbatsqy/wCXLz/h/LyNZAerGzLcZ7wfLs9xRfjV3LpI9B0pwqQU4SjKMlqpReqaKW5o7B5/K4aadlcyVPXV0p+9B+nd5rRmfYPtBx1zy08lSlZ1P41rKm/1X/vU6LH1Wm3lLovv6vExr9Ptr5x5ozVbjPjaXNvdUo1ravTrU3tOnJSXzR9jTTTW6M6S26wRRKKGKZANCGhipgUSUMIxoYkMkqYxoQ0ShGNDEhjFbKWw4iWw4jCMoa2ENbAIyiiSgIGiokoqJJBaKJRRJDLWw47iWw47gQUUiSkSQVEYojJFZSHHvEhx7yUKzou0O2+18D5ilprpayqJeMPe/wBJ5pPVmRt/teNubX+mozp/NNHlM5P0jhtZCXan5f2dj6Lz3rsh2NPx/oAADmzqQAAAAAAAAAAADk2F9eWFb21ldVbefxhJrXz+Jl2H7RcjQ0hkrendw75x9yf+z+SMIAvpyrafYlsU249dvtrc3PieM8BkOWKu/s1R/cuFyfXb6mRQlGcVKElKL6pp6pnnY5uNy2SxstbG+r0OuvLGfuvzWzNenXJLlbHf4GZdpEX/ABy2+Jv0aNV4vtGydHSN/a0buPfKP7OX06fQyrF8e4C8ajWq1bOb7q0OmvmtV89DWp1PGt6pbPv5GVdp2RX/AOd/hzMqKOPaXVrd0va2txSrw/ipzUl9DkGgmmt0Z7TXJjQxIYxSxjQholCMaGJDGK2UthxEthxGEZQ1sIa2ARlFElAQNFRJRUSSC0USiiSGWthx3Ethx3AgopElIkgqIxRGSKykOPeJDj3koVjR5a4jofZeIclbaaexu6tPT4aTaPUqPM/H0VHjbMqKSX22q/nJnOekcf8AVB97Om9F5f7rI9yOjAAOSO0AAAAAAAAAAAAAAAAAAAAAAAAPpb169vUVW3rVKNRbShJxa9UZHjOOeIbLSMrqN3Bfdrx5n81o/qYwBbVfZU94SaKrKK7VtOKZtDF9pdlPSORsK1CXfOlJTj56PRr6mU4viPCZNqNnkqE5vaEnyS+T0ZoYDUp1vIhyntLy/fAzLtFon7G8T0gNGhMVxHm8ZyqzyNeMFtTk+eHyeqMsxPabcw0hk8fTqrvnQlyv5PVP5o1qNbx58p7xMm/RMiHOG0jaCGY3iuNeHchpFXytqj+5cLk+v7v1MjpzhUgp05xnCS1UovVM1qrq7VvCSZj3U2VPacWviWthxEthxLjzsoa2ENbAIyiiSgIGiokoqJJBaKJRRJDLWw47iWw47gQUUiSkSQVEYojJFZSHHvEhx7yUKxo80doH/W+Z/wD7Kn+Y9Lo8z8ftPjfM6PX/AO5U/wAzOd9I/wCGHx+x0nov/PP4fc6MAA5E7YAAAAAAAAAAAAAAAAAAAAAAAAAA5GPsbzIV1QsrarcVX92nFv5/AlJyeyIclFbs44GfYLs0v7jlq5a5haQfV0qfv1PV7L6md4PhXB4flla2UJVo/jVffnr8dXt6aGtj6LkW85dFd/X4GRk63jVco9J93V4/2amwnB+ey3LOlZuhRf4tf3I+i3fojLLTsvoqmnd5acp96pUkkvVvqbGe4mbdOi41a6S4n3/8MW7Wsmx9F8K7v+mt73swXs27LKvnS/drUuj9U+nyZ0c+H+MuHpupZq55F1crSo5RfnFdfmjcbEFmj475w3i+5jV6veltPaS70aoxvaPnLKXssjb0btRekuaPs6nzXT6GW4jtFwF3yxunWsaj/pI80fnHX6pHe5HG4/IR5L6yoXC2TqQTa8nujF8p2d4W41lZ1K9lN7KMuePyfX6iKrUKPYmprv6/35jOWn5HtwcH3fv2M3sb2zvqPtrO6o3FP+KlNSX0OQtjTl1wJxFja32jF3MK0o/uyo1HSqfXT8x2/GPGOBmqWTpTrQT0Ubuk035SWjf1HWrSr5ZFbj39a/fEpnoys549il3dT/fA3IUYDiO07D3LjDI21exm95L9pBeq6/QzLGZTHZOn7TH3tC5jpq/ZzTa81uvU0aMui/8Ajkn+9hlZGHfj/wAkWvp4nNRUSUVE9J5S0USiiSGWthx3Ethx3AgopElIkgqIxRGSKykOPeJDj3koVjR5f4vmqnFmYqJaKV9Xlp51JHqDVKLbaSW7Z5Rva32i8r3Gmntakp/N6nNekkuhXH4/Y6n0Wj07Jdy+58QADlDsQAAAAAAAAAAAAAAAAADJOG+Cs7m1GrTt/s1rL8ev7qa+KW8vTp4llVNl0uGC3ZVbdXTHiseyMbO3wPDWZzck7CynKlr1rT92mvV7+S1Ztbh7s9weLUat1B5G4X3qy9xPwht89TLVFRgoxSUV0SS6I38XQJPne9u5fk57K9IYro0R373+P6NfYHsysLflq5i5ld1O+lTbhTXru/oZvY2VpYW6t7K2pW9JfdpxUUcliZv0YlOOtq47fU57IzL8l72S3+ngQSUSegpQnuJje4mKWITENiFLUSxMbEyCxCIqwhVhKnUhGcJdHGS1TLExSxGO5Tgvh+/1l9j+zVH9+3fJ9P3foYtf9nmQtant8PklOUXrFT1pzXlJdPyNlks8N2n49vNx2fdyNCrNvrWyluu/ma0o8Ucb8NtU8nQqXNCPTW5hzL0qR3fm2ZVg+03CXfLTyFKtj6j7379P5rr80ZBJKScZJNPo0+8x7McHYHI80naK2qv79v7n02+hSqsvH/is4l2S/I04YeR/JXwvtj+DNrG8tL6gq9nc0bik9p0pqS+hyTSl1wbxBha7u8Ffzqaf0U3TqaeWuj+focvEdpWcxlb7JnrL7TyvSTcfZVV59NH8l5lsNWUHw5MHF9vWjxW6JOS4seSkuzqZuNbDjuY7w5xlgM5y07W8VK4f4Ff3J6/Bdz9GzIo7mrXbC2PFB7oxbabKpcNi2feUUiSkWlRURiiMkVlIce8SHHvJQrOt4qu/sPDGTu9dHStako/zcr0+uh5ePQHbRffY+A7ikpJSu6sKK+fM/pFnn84/0is4r4w7F9TtfRmrhx5z7X9P7AAA586UAAAAAAAAAA77hfhLNcQ1E7K35LfXSVxV92mvJ978FqPXVO2XDBbsrtthVHim9kdCZRwvwPm86o1lS+yWj/HrJrmX9WO8vy8TZ/CvAGFwnJXrQV/eR6+1rR92L/qx2Xm9WZZI6PD0D/1kP5L7v8eJzWb6RL2cdfN/ZfnwMU4b4FweFUansftt0vxq6T0f9WOy/PxMmZUiWdFVTXTHhrWyOauvsvlxWS3YnsS9insS9hysliY2JgMQSUSQOhPcTG9xMUsQmIbEKWoliY2JkFiEJjExSxASyiWKy1AJjExWXIk4WVxdhk6LpX1rTrx7nJe9Hye69DmiZEoqS2a3Q8W4vdGteIeAK9BSuMPVdeC6+xqNKa8ns/p6nG4c474h4dr/AGW7dS7oU3yyt7ltTh4KT6ryeq8DaL2Oo4gwGOzVHluqXLVS0hWh0nH1714MyrdPlXL1mLLhfZ7v3yPcsmF0fV5EeJeZkXCfFmI4ko62VbkuIrWdvU6Tj4+K8UZAjzdm8LleGr6FeM5qMZa0bqk2uvn3PwNndm3aBDLuniczKNO/fu0qumka/g/hL6P6HqwtW45+pyFwz8mZGoaN6qLux3xR80bFiMURm4c8ykOPeJDj3koVmoP+IHIqd7jcVCX/AC4Sr1F4yfLH/LL5mqzvePsr/wDM8XZC+jLmpOq6dJ93JH3U/VLX1OiPnmoX+vyZzXVv9OR9M0zH/wAfFhW+vbn8XzAAA8R7gAAAAOVisde5S9hZ4+2qXFee0YL6v4LxZ3XBPB+R4nutaSdCyhLSrcyj0XhH+KXh8zefDfD+M4esVa423UNUvaVJdZ1H8ZPv8tl3Gvp+k2ZXTlyj9fh+TG1LWK8ToR5z7Oz4/gwzg/sws7KMLvPSjeXG6t4/8qHn/E/p5mwqcIUqcadOEYQitIxitEl8Ej6y2IOux8WrGjw1rY4zJy7sqfFbLf6EsiRbIkeg8xEiWVIlkDCexL2KexL2IJJYmNiYDEElEkDoT3ExvcTFLEJiGxClqJYmNiZBYhCYxMUsQEsolistQCYxMVlyJExiYDEvYkp7EkDI+N1b0bq3nb3FKNWlNaSjJapo1bxjwxWwlb7bZuc7Ny1Ul+9RevRN/k//AF7XPlWpU61KdKrCM6c04yjJapp9x48zDhkx2fX7merHyJUy5dQuyjix8QYx2V7U1yNpFc7e9WGyn59z9PiZuefaqr8D8bW97b87tlLniv46T6Sh56a/Rm/7etTuKFOvRmp06kVOEls01qmejSsmdsHVb7UOT+zMLWcONFisr9mXNdz96PqjGe0zORwXCN1VhPlubhewt1380k9X6LV+ehkspKMXKTSilq230R587UuJlxHxA1bTbsLTWnQ+E396frovRIbVcxY2O9vafJfn5Fej4Ly8hbrox5v8fMxEAA4M+iAAAAAZh2c8F3HE12ri4U6OMpS/aVNnUf8ABHx+L7jgcB8M3HE+ajax5qdrT0nc1Uv3Y/BeL2Xz7j0Rj7O2x9lRsrOjGjb0Y8sIR2SNzSNL/wAl+ts9lef/AAwNZ1b/ABV6qr235f8ASbK0trG0pWlnRhQoUo8sIQWiSPqymSzskklsjiG23uxS2ILlsQBJLIkWyJEARIllSJZAwnsS9insS9iCSWJjYmAxBJRJA6E9xMb3ExSxCYhsQpaiWJjYmQWIQmMTFLEBLKJYrLUAmMTFZciRMYmAxL2JKexJAyESUSA6MM7VreM8Nb3Oi56VflT8JJ6/kjMOyLN0L3gyjQrXNNV7DWlUUpJOME/db8NGlr4GF9q95GGPtbFNc9Sp7Rr4Rimvzf0NcmDdnf4ebKcVvy2Z756es3EVcntz3TNo9qnH1O8pVMHg6zlQfu3NzF9Ki/gi/h8X3+W+rgAyMrKsyrOOf9Gjh4deJWq61/0AADzHqA+ltQq3NzTt6FOVSrVmoQhHeUm9Ej5mzOwvh9XeRrZ+5hrStH7OhqujqNdX6J/4vA9OJjSybo1r3/Q8ublRxaJWy9319xsjgbh6hw1gKVjBRlXl79xUX35vf0Wy8jvCmSfQ6641QUIrZI+aWWytm5ze7ZLJZTJYxApbEFy2IAklkSLZEiAIkSypEsgYT2JexT2JexBJLExsTAYgkokgdCe4mN7iYpYhMQ2IUtRLExsTILEITGJiliAllEsVlqATGJisuRImMTAYl7ElPYkgZCODl8laYqynd3lRQhHZd8n8Eu9nXcTcU4/CwlT5lcXenSjB7fzPu/M1dm8ve5i7dxeVebT9yC6RgvgkZmbqUKE4x5y+nxPfjYcrecuSDPZOvl8nVva/Ry6Qgn0hFbI4AActKTnJyl1s3YxUVsgAAFJAAAAHCMpzUIJylJ6JLds9N8H4iGC4ZscaklOlTTqv41H1k/m2aM7KsWsrxxY05x5qVvJ3FTp3Q6r/ABcq9T0VLZHVejuPtGVz+C+5x/pPk7yhQvi/t9xMkpknSs5ZEsllMlkDilsQXLYgCSWRItkSIAiRLKkSyBhPYl7FPYl7EEksTGxMBiCSiSB0J7iY3uJiliExDYhS1EsTGxMgsQhMYmKWICWUSxWWoBMYmKy5EiZ0Oc4uwuK5oTuPtFdfhUfeafi9kYJnOOsvf81O1asaL7qb1m14y/20PDkajRRyb3fYj204dtvNLZd5sTNZ3F4im3e3UI1NNVSj7036fq+hr7iHjm/vlKhj4uyoPpzJ61Jevd6fMxOc51Juc5SlKT1cm9W2SYOTqt13KPRX77zWowK6+b5scm5ScpNtt6tvvEAGYe4AAAAAAAAAAAA2z/w+WC5srk5R6pQoQfzlL/SbalsjCuxK0+zcB0aumjua9Sq/HR8n+gzWWyPoGlVerxILtW/jzPm2sW+tzbH2Pbw5CZJTJPezPRLJZTJZA4pbEFy2IAklkSLZEiAIkSypEsgYT2JexT2JexBJLExsTAYgkokgdCe4mN7iYpYhMQ2IUtRLExsTILEITGcPJ5KwxtH21/d0reHdzy6vyW79BJSUVu3si2EXJpI5Z861SnRpyq1akKcIrWUpPRJeLMBznaPTjzUsPaOb29tX6L0it/VryMGy+YyeWq89/eVa3XVRb0jHyiuiMjI1imvlDpPyNfH0u2fOfJeZsrO8fYmy5qdipX9Zd8HpTX9rv9EYHnOK8zl+aFa5dGhL8Gj7sdPHvfqzogMLI1G+/k3suxGzThVU80t33gAAeE9YAAAAAAAAAAAAAAAAAAAB6X7PKH2fgbD09NNbSFT+8ub9TvJbI4XD1NUeH8dSWmkLSlFaLTaCObLZH0umPDVGPYkfKb5cdspdrYmSUySxiIlkspksgcUtiC5bEASSyJFsiRAESJZUiWQMJ7EvYp7EvYgkliY2JgMQSUSQOhPcTG9xMUsQmImtVp0aUqtapCnTitZSm9El4tmIZ3tBw9jzU7FSv6y/g92mv7T39Ezz3ZFVC3slseujHtue1cdzL2dHneKsLiOaFxdqpWX4NH3p+T7l6tGr87xjnMrzQnc/ZqD/AAqHurTxe7+ZjxhZOurqpj83+DdxtEfXc/kvyZrnO0PJ3XNSxtKFlSf3371R+uy+XqYfc3Fe6rSrXNapWqy3nOTk36s+QGHdk23veyW5t049VK2gtgAAKC4AAAAAAAAAAAAAAAAAAAAAAAAAAAA9X2SSsqCS0Xso/kfSWyFQUFb01TbcFBcrfetOg5bI+nrqPkj62JklMkGMiWSymSyBxS2ILlsQBJLIkWyJEARIllSJZAwnsS9insS9iCSWJjYmAxBJ0We4vwWH5oV7tVq6/Boe/LXx7l6tGv8APdo2WvOanjqcLCk+nMvfqP1fRei9TOydTx8flKW77EaeLpeRkbOMdl2s2flsrjsVR9rkLylbx7lJ+9LyW79DBc92lxXNSw1nzd3trjovSK/V+hri5r1rmtKtcVqlarL96c5OTfqz5nP5Ot3Wcq+ivM6LG0OmvnZ0n5HPy+ZyeWq+0yF5Vr9dVFvSMfKK6I4AAY8pym95PdmzGEYLaK2QAACjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHq+z/wDw6P8A24/kfSWyPhi5upi7Wo0k5UISenjFH3lsj6dF7pHyWS2kxMkpkkslEsllMlkDilsQXLYgCSWRItkSIAiRLKkddmc1i8PR9pkr6jbprVRk9ZS8orq/QWc4wXFJ7IshCU5cMVuznPY+NzXo29GVa4rU6NOPWU5yUYrzbNbcQdqLfNSwllp3e3uP0iv1foYBl8xk8vW9rkb2rcPXVKT92PlFdF6GJk65RXyr6T8jcxdAvt529FeZtTiDtHw9lzUsdCeQrLprH3aaf8z6v0Xqa9z/ABlnsxzQq3bt6D/Boe5HTxe79WY8Bz+TqmRkcnLZdiOkxdKxsbnGO77XzAAAzzRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPU3DspT4exs5dZStKTfnyI5stkdXwdFx4Pw0ZJprH0E0+79nE7SWyPplT3ri+5Hyi5bWSXexMkpkjsVEsllMlkDilsQTeXNvaW8q91XpUKUesp1JqMV5tmB8RdqGHsualiqU8jWXTn/cpL1fV+i9Tz5GVTjreyWx6cfEuyZbVR3/e0zxmMcRcb8P4bmhUu1dXC/Bt9JvXxey9Xqah4i4yz+c5oXN5Kjby/Aoe5DT4Pvfq2Y8c/k+kHuoj83+Do8X0c/8AV8vkvyZxxD2lZrIc1LHxhjqD6awfNUa/me3ol5mF161a4rSrV6s6tST1lOcnKT82z5gYF+Tbe97JbnRUYtOOtqopAAAUHoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPUfC7UuGcXKLTTsqLTXf7iOwlsjoezq5jd8C4erFpqNrGl0+MPcf8AlO+lsj6XRJSqi170j5TkRcbpxfub+omSY1xLx1w7g1KnWvFc3MensLfSctfF7L1ZrHiXtRzmR5qONjHGUH01g+aq1/M9vRLzPFlarjY/Jy3fYjQxNIysnnGOy7XyNv53O4jC0vaZO/o2+q1UW9Zy8orq/ka24j7WZy5qOBseRbe3uer81Ffq/Q1hcVq1xWlWuKtSrVm9ZTnJyk34tnzOdytdvt5V9FefidRiej+PTzt6T8vA5+YzGUzFf22Tvq1zPu55e7HyS6L0OAAGLKUpPeT3ZuRhGC4YrZAAAKMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbR7HuIchbYm/x8fZToW6dakpxbcW910e3TX1Zi/FPHHEeZqVaFe+dvbauPsbZckWvHvfq2AG5kW2R0+tKT8TnsamuWpWtxXgYsAAYZ0IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB//9k=" style="height:28px;width:auto;object-fit:contain;flex-shrink:0;mix-blend-mode:screen">San Nicolás <span class="dot ld" id="dot"></span></div>
      <div class="sdsub">Renacimiento - Gestión</div>
      <button id="sd-collapse" onclick="toggleSidebarCollapse()" title="Ocultar menú"
        style="position:absolute;top:50%;right:8px;transform:translateY(-50%);background:var(--bg3);border:1px solid var(--bord);color:var(--txt2);width:26px;height:26px;border-radius:50%;cursor:pointer;font-family:inherit;font-size:14px;display:flex;align-items:center;justify-content:center;padding:0;line-height:1">
        &#x2B05;
      </button>
    </div>
    <div class="ubadge">
      <div class="uav" id="uav">?</div>
      <div style="flex:1;min-width:0">
        <div class="unm" id="unm">--</div>
        <div class="url2" id="url2">--</div>
      </div>
    </div>
    <nav class="nav" id="nav"></nav>
    <div class="sdfoot">
      <button class="logoutb" onclick="doLogout()">
        <svg width="13" height="13" viewBox="0 0 16 16" fill="currentColor"><path d="M6 2H3a1 1 0 00-1 1v10a1 1 0 001 1h3v-1.5H3.5v-9H6V2zm8.7 5.3l-3-3-.7.7 2 2H6v1h7l-2 2 .7.7 3-3a.5.5 0 000-.7z"/></svg>
        Cerrar sesion
      </button>
    </div>
  </aside>
  <div class="main" id="main">
    <div id="sb"></div>
    <div class="topbar">
      <div class="tbl"><img id="topbar-logo" src="data:image/png;base64,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" style="height:30px;width:auto;object-fit:contain;flex-shrink:0;mix-blend-mode:screen">
        <button class="hambtn" id="hambtn" onclick="openSidebar()"><span></span><span></span><span></span></button>
        <button id="sd-expand" onclick="toggleSidebarCollapse()" title="Mostrar menú"
          style="display:none;background:var(--bg3);border:1px solid var(--bord);color:var(--txt2);width:34px;height:34px;border-radius:8px;cursor:pointer;font-family:inherit;font-size:14px;align-items:center;justify-content:center;padding:0">
          &#x27A1;
        </button>
        <div><div class="ttl" id="ttl">Dashboard</div><div class="tmeta" id="tmeta">&nbsp;</div></div>
      </div>
      <div class="tbr no-print">
        <span class="synbadge ok" id="syn">Sync</span>
        <div style="position:relative;display:inline-flex;align-items:center;flex-shrink:0;margin-right:2px">
          <button class="btn bg" onclick="toggleNotifPopup()" id="bell-btn" style="font-size:17px;padding:7px 11px;line-height:1;display:inline-flex;align-items:center;justify-content:center;min-height:36px;min-width:40px">&#128276;</button>
          <span id="notif-badge" style="display:none;position:absolute;top:-6px;right:-6px;background:var(--red);color:#fff;border-radius:99px;font-size:10px;font-weight:800;padding:0;min-width:20px;height:20px;text-align:center;line-height:20px;pointer-events:none;box-sizing:border-box;border:2px solid var(--bg2)">0</span>
        </div>
        <button class="btn bt sm" id="btn-ref" onclick="loadAll()">Actualizar</button>
        <button class="btn bs sm" id="btn-csv" onclick="exportCSV()">CSV</button>
        <button class="btn bpu sm" id="btn-prt" onclick="showOv('ovprt')">Imprimir</button>
        <button class="btn bg sm" id="btn-cfg-top" onclick="showCfg()" style="display:none">Config DB</button>
        <button class="btn bg sm" id="btn-carpeta" onclick="seleccionarCarpeta()" title="Seleccionar carpeta de destino" style="display:none">
          📁 <span id="carpeta-nombre">Carpeta</span>
        </button>
      </div>
    </div>

    <div id="page-dashboard" class="page active">
      <!-- Header del dashboard con fecha y bienvenida -->
      <div style="background:linear-gradient(135deg,var(--bg2),var(--bg3));border:1px solid var(--bord);border-radius:12px;padding:1.25rem 1.5rem;margin-bottom:1.25rem;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px">
        <div>
          <div style="font-size:11px;color:var(--txt3);text-transform:uppercase;letter-spacing:.08em;margin-bottom:4px">Bienvenido</div>
          <div id="dash-user" style="font-size:18px;font-weight:700;color:var(--txt);margin-bottom:4px">--</div>
          <div id="dash-fecha" style="font-size:14px;color:var(--blue);font-weight:600">--</div>
        </div>
        <div style="text-align:right">
          <div style="font-size:10px;color:var(--txt3);text-transform:uppercase;letter-spacing:.08em;margin-bottom:4px">San Nicolás</div>
          <div style="font-size:13px;color:var(--txt2)">Renacimiento</div>
        </div>
      </div>
      <div class="kgrid">
        <div class="kpi blue"><div class="kl">Ingresos SN</div><div class="kv" id="k-sn">--</div><div class="ks">caja</div><div class="kbar"><div class="kfill" id="kf-sn" style="background:var(--blue);width:0%"></div></div></div>
        <div class="kpi red"><div class="kl">Egresos Renac.</div><div class="kv" id="k-ren">--</div><div class="ks">caja</div><div class="kbar"><div class="kfill" id="kf-ren" style="background:var(--red);width:0%"></div></div></div>
        <div class="kpi green"><div class="kl">Neto</div><div class="kv" id="k-net">--</div><div class="ks">cierre</div><div class="kbar"><div class="kfill" id="kf-net" style="background:var(--green);width:0%"></div></div></div>
        <div class="kpi amber"><div class="kl">Total cobros</div><div class="kv" id="k-cob">--</div><div class="ks" id="k-cobs">0 facturas</div><div class="kbar"><div class="kfill" id="kf-cob" style="background:var(--amber);width:100%"></div></div></div>
        <div class="kpi red"><div class="kl">Tickets</div><div class="kv" id="k-tick">--</div><div class="ks" id="k-ticks">0 tickets</div><div class="kbar"><div class="kfill" id="kf-tick" style="background:var(--red);width:100%"></div></div></div>
        <div class="kpi purple"><div class="kl">Neto cobros</div><div class="kv" id="k-neto">--</div><div class="ks">cobros-tickets</div></div>
      </div>
      <div class="cgrid no-print">
        <div class="cc"><div class="ctit">Por importe</div><div style="height:185px"><canvas id="ch-dist"></canvas></div></div>
        <div class="cc"><div class="ctit">Por mes</div><div style="height:185px"><canvas id="ch-mes"></canvas></div></div>
        <div class="cc full"><div class="ctit">Acumulado</div><div style="height:140px"><canvas id="ch-line"></canvas></div></div>
      </div>
      <div class="card">
        <div class="ch"><div><div class="ct2">Ultimos cobros</div><div class="cm">10 mas recientes</div></div><button class="btn bg sm no-print" onclick="go('lc')">Ver todos</button></div>
        <div class="tscroll"><table><thead><tr><th>Socio</th><th>Mes</th><th>Localidad</th><th class="uh">Usuario</th><th>Cobrador</th><th class="num">Importe</th><th>Fac.</th><th>Estado</th></tr></thead><tbody id="tb-rec"></tbody></table></div>
      </div>
    </div>

    <div id="page-central" class="page">
      <div class="card" style="margin-bottom:1rem">
        <div class="ch"><div class="ct2">Filtros</div><button class="btn bg sm" onclick="clearFiltros()">Limpiar</button></div>
        <div style="padding:.9rem 1.1rem;display:grid;grid-template-columns:repeat(auto-fit,minmax(145px,1fr));gap:10px">
          <div class="fg"><label>Desde</label><input type="date" id="f-desde" class="fi" style="font-size:12px" onchange="refreshCentral()"></div>
          <div class="fg"><label>Hasta</label><input type="date" id="f-hasta" class="fi" style="font-size:12px" onchange="refreshCentral()"></div>
          <div class="fg"><label>Agencia</label><select id="f-agencia" class="fi" style="font-size:12px" onchange="refreshCentral()"><option value="">Todas</option></select></div>
          <div class="fg"><label>Servicio</label><select id="f-servicio" class="fi" style="font-size:12px" onchange="refreshCentral()"><option value="">Todos</option><option value="San Nicolás">San Nicolás</option><option value="Renacimiento">Renacimiento</option><option value="Cocheria">Cocheria</option></select></div>
          <div class="fg"><label>Socio</label><input type="text" id="f-socio-c" class="fi" style="font-size:12px" placeholder="Numero o nombre..." oninput="refreshCentral()"></div>
          <div class="fg"><label>Estado</label><select id="f-estado-c" class="fi" style="font-size:12px" onchange="refreshCentral()"><option value="">Todos</option><option value="cobrado">Cobrado</option><option value="pendiente">Pendiente</option><option value="anulado">Anulado</option></select></div>
        </div>
      </div>
      <div class="kgrid">
        <div class="kpi blue"><div class="kl">Total cobrado</div><div class="kv" id="ct-tc">--</div><div class="ks" id="ct-tcs">0 facturas</div></div>
        <div class="kpi red"><div class="kl">Total tickets</div><div class="kv" id="ct-tt">--</div><div class="ks" id="ct-tts">0 devueltos</div></div>
        <div class="kpi green"><div class="kl">Neto cobros</div><div class="kv" id="ct-nt">--</div><div class="ks">cobros-tickets</div></div>
        <div class="kpi amber"><div class="kl">Agencias activas</div><div class="kv" id="ct-ua">--</div><div class="ks">en el periodo</div></div>
        <div class="kpi teal"><div class="kl">Ingresos caja</div><div class="kv" id="ct-ci">--</div><div class="ks">mov. ingreso</div></div>
        <div class="kpi purple"><div class="kl">Egresos caja</div><div class="kv" id="ct-ce">--</div><div class="ks">mov. egreso</div></div>
      </div>
      <div class="cgrid no-print"><div class="cc full"><div class="ctit">Cobrado por agencia</div><div style="height:200px"><canvas id="ch-ct"></canvas></div></div></div>
      <div class="card">
        <div class="ch"><div><div class="ct2">Resumen por agencia</div><div class="cm" id="ct-meta">--</div></div><button class="btn bs sm no-print" onclick="exportCentralXLSX()">XLSX</button>
          <button class="btn bg sm no-print" onclick="exportCentralCSV()">CSV</button></div>
        <div class="tscroll"><table><thead><tr><th>#</th><th>Agencia</th><th>Zona</th><th>Cobros</th><th class="num">Total cobrado</th><th>Tickets</th><th class="num">Total tickets</th><th class="num">Neto</th></tr></thead><tbody id="tb-ct"></tbody><tfoot><tr><td colspan="3">TOTAL</td><td id="cf-c">--</td><td class="num" id="cf-tc">--</td><td id="cf-t">--</td><td class="num" id="cf-tt">--</td><td class="num" id="cf-n">--</td></tr></tfoot></table></div>
      </div>
      <div class="card">
        <div class="ch"><div><div class="ct2">Cobros detallados</div><div class="cm" id="ct-det-meta">--</div></div></div>
        <div class="tscroll"><table><thead><tr><th>Fecha</th><th>Agencia</th><th>Socio</th><th>Mes</th><th>Cobrador</th><th>Empresa</th><th class="num">Importe</th><th>Fac.</th><th>Estado</th></tr></thead><tbody id="tb-ct-det"></tbody></table></div>
      </div>
    </div>

    <div id="page-fc" class="page"><div class="fp">
      <div class="alr" id="al-c"></div>

      <!-- TIPO DE COBRO SELECTOR -->
      <div style="display:flex;gap:8px;margin-bottom:1rem">
        <button id="tab-cobro-normal" onclick="setTipoCobro('normal')"
          style="flex:1;padding:10px;border-radius:8px;font-size:12px;font-weight:700;cursor:pointer;font-family:inherit;background:var(--blue);color:#fff;border:none;transition:all .15s">
          Cobro normal
        </button>
        <button id="tab-cobro-atrasado" onclick="setTipoCobro('atrasado')"
          style="flex:1;padding:10px;border-radius:8px;font-size:12px;font-weight:700;cursor:pointer;font-family:inherit;background:var(--bg3);color:var(--txt2);border:1px solid var(--bord);transition:all .15s">
          Pago atrasado
        </button>
      </div>

      <!-- COBRO NORMAL -->
      <div id="fc-normal">
      <div class="fc2"><div class="fct">Nuevo cobro</div>
        <div class="fgrid">
          <div class="fg"><label>Fecha</label><input type="date" id="c-fec"></div>
          <div class="fg"><label>Localidad</label><input type="text" id="c-loc"></div>
          <div class="fg"><label>N° Socio</label><input type="text" id="c-soc" placeholder="Ej: 893206"></div>
          <div class="fg"><label>Mes</label><select id="c-mes"><option value="">--</option><option value="1">Enero</option><option value="2">Febrero</option><option value="3">Marzo</option><option value="4">Abril</option><option value="5">Mayo</option><option value="6">Junio</option><option value="7">Julio</option><option value="8">Agosto</option><option value="9">Septiembre</option><option value="10">Octubre</option><option value="11">Noviembre</option><option value="12">Diciembre</option></select></div>
          <div class="fg"><label>Importe</label><input type="text" id="c-imp" placeholder="Ej: 33.000" oninput="cleanN(this)"></div>

          <!-- N° FACTURA: select + custom input -->
          <div class="fg">
            <label>N° Factura</label>
            <div style="display:flex;gap:6px">
              <select id="c-fac-sel" style="background:var(--bg3);border:1px solid var(--bord2);color:var(--txt);border-radius:7px;padding:8px 10px;font-size:13px;font-family:inherit;outline:none;flex:1" onchange="onFacSelChange()">
                <option value="">-- Escribir número --</option>
              </select>
              <input type="text" id="c-fac" placeholder="N° factura" style="flex:1" oninput="syncFacSel()">
            </div>
          </div>

          <!-- N° TICKET: select + custom input -->
          <div class="fg">
            <label>N° Ticket</label>
            <div style="display:flex;gap:6px">
              <select id="c-tic-sel" style="background:var(--bg3);border:1px solid var(--bord2);color:var(--txt);border-radius:7px;padding:8px 10px;font-size:13px;font-family:inherit;outline:none;flex:1" onchange="onTicSelChange()">
                <option value="">-- Escribir número --</option>
              </select>
              <input type="text" id="c-tic" placeholder="N° ticket" style="flex:1" oninput="syncTicSel()">
            </div>
          </div>

          <div class="fg"><label>Cobrador</label><input type="text" id="c-cob"></div>
          <div class="fg"><label>Empresa</label><select id="c-emp"><option value="San Nicolás">San Nicolás</option><option value="Renacimiento">Renacimiento</option></select></div>
          <div class="fg"><label>Estado</label><select id="c-est"><option value="cobrado">Cobrado</option><option value="pendiente">Pendiente</option><option value="anulado">Anulado</option></select></div>
          <div class="fg"><label>Obs</label><input type="text" id="c-obs" placeholder="Opcional"></div>
        </div>
        <div class="div"></div>
        <div class="fa"><button class="btn bp" id="btn-sc" onclick="saveCobro()">Guardar cobro</button><button class="btn bg" onclick="clearFC()">Limpiar</button></div>
      </div>
    </div>
    </div><!-- /fc-normal -->

    <!-- PAGO ATRASADO -->
    <div id="fc-atrasado" style="display:none">
      <div class="fc2">
        <div class="fct" style="color:var(--amber)">Pago atrasado — múltiples meses</div>
        <div style="font-size:11px;color:var(--txt2);margin-bottom:1rem">
          Ingresá los datos comunes del socio y luego agregá cada mes atrasado con su fecha e importe.
        </div>

        <!-- Datos comunes -->
        <div class="fgrid">
          <div class="fg"><label>N° Socio</label><input type="text" id="pa-soc" placeholder="Ej: 893206"></div>
          <div class="fg"><label>Cobrador</label><input type="text" id="pa-cob"></div>
          <div class="fg"><label>Empresa</label><select id="pa-emp"><option value="San Nicolás">San Nicolás</option><option value="Renacimiento">Renacimiento</option></select></div>
          <div class="fg"><label>Localidad</label><input type="text" id="pa-loc"></div>
          <div class="fg"><label>Estado</label><select id="pa-est"><option value="cobrado">Cobrado</option><option value="pendiente">Pendiente</option></select></div>
          <div class="fg"><label>Obs general</label><input type="text" id="pa-obs" placeholder="Ej: Pago de deuda"></div>
        </div>

        <div class="div"></div>

        <!-- Lista de cuotas atrasadas -->
        <div style="font-size:11px;font-weight:700;color:var(--txt3);text-transform:uppercase;letter-spacing:.06em;margin-bottom:8px">
          Cuotas a cobrar
        </div>
        <div id="pa-cuotas-list"></div>

        <!-- Agregar cuota -->
        <div style="background:var(--bg3);border:1px dashed var(--bord2);border-radius:8px;padding:1rem;margin-bottom:1rem">
          <div class="fgrid">
            <div class="fg"><label>Fecha de pago</label><input type="date" id="pa-fec"></div>
            <div class="fg"><label>Mes que paga</label><select id="pa-mes"><option value="">--</option><option value="1">Enero</option><option value="2">Febrero</option><option value="3">Marzo</option><option value="4">Abril</option><option value="5">Mayo</option><option value="6">Junio</option><option value="7">Julio</option><option value="8">Agosto</option><option value="9">Septiembre</option><option value="10">Octubre</option><option value="11">Noviembre</option><option value="12">Diciembre</option></select></div>
            <div class="fg"><label>Importe</label><input type="text" id="pa-imp" placeholder="Ej: 33.000" oninput="cleanN(this)"></div>
            <div class="fg"><label>N° Factura</label><input type="text" id="pa-fac" placeholder="Opcional"></div>
            <div class="fg"><label>N° Ticket</label><input type="text" id="pa-tic" placeholder="Opcional"></div>
          </div>
          <button class="btn bt sm" style="margin-top:8px" onclick="agregarCuota()">+ Agregar cuota</button>
        </div>

        <!-- Resumen -->
        <div id="pa-resumen" style="display:none;background:var(--greenbg);border:1px solid #155c36;border-radius:8px;padding:10px 14px;margin-bottom:1rem;font-size:13px;color:var(--green)">
          <strong id="pa-res-cant">0</strong> cuotas — Total: <strong id="pa-res-total">$0</strong>
        </div>

        <div class="div"></div>
        <div class="fa">
          <button class="btn bp" id="btn-pa" onclick="guardarPagoAtrasado()">Guardar pago atrasado</button>
          <button class="btn bg" onclick="clearPagoAtrasado()">Limpiar</button>
        </div>
      </div>
    </div><!-- /fc-atrasado -->

  </div></div>

    <div id="page-ft" class="page"><div class="fp">
      <div class="alr" id="al-t"></div>
      <div class="fc2"><div class="fct">Ticket devuelto</div>
        <div class="fgrid">
          <div class="fg"><label>Fecha</label><input type="date" id="t-fec"></div>
          <div class="fg"><label>Localidad</label><input type="text" id="t-loc"></div>
          <div class="fg"><label>N Socio</label><input type="text" id="t-soc" placeholder="Ej: 889932"></div>
          <div class="fg"><label>Mes</label><select id="t-mes"><option value="">--</option><option value="1">Enero</option><option value="2">Febrero</option><option value="3">Marzo</option><option value="4">Abril</option><option value="5">Mayo</option><option value="6">Junio</option><option value="7">Julio</option><option value="8">Agosto</option><option value="9">Septiembre</option><option value="10">Octubre</option><option value="11">Noviembre</option><option value="12">Diciembre</option></select></div>
          <div class="fg"><label>Importe</label><input type="text" id="t-imp" placeholder="Ej: 28.000" oninput="cleanN(this)"></div>
          <div class="fg"><label>N Ticket</label><input type="text" id="t-tic"></div>
          <div class="fg"><label>Motivo</label><input type="text" id="t-mot" placeholder="Ej: Socio ausente"></div>
          <div class="fg"><label>Empresa</label><select id="t-emp"><option value="San Nicolás">San Nicolás</option><option value="Renacimiento">Renacimiento</option></select></div>
        </div>
        <div class="div"></div>
        <div class="fa"><button class="btn bp" id="btn-st" onclick="saveTicket()">Guardar ticket</button><button class="btn bg" onclick="clearFT()">Limpiar</button></div>
      </div>
    </div></div>

    <div id="page-fca" class="page"><div class="fp">
      <div class="alr" id="al-ca"></div>
      <div class="fc2"><div class="fct">Movimiento caja</div>
        <div class="fgrid">
          <div class="fg"><label>Fecha</label><input type="date" id="ca-fec"></div>
          <div class="fg"><label>Localidad</label><input type="text" id="ca-loc"></div>
          <div class="fg"><label>Empresa</label><select id="ca-emp"><option value="San Nicolás">San Nicolás</option><option value="Renacimiento">Renacimiento</option><option value="Cocheria">Cocheria</option></select></div>
          <div class="fg"><label>Tipo</label><select id="ca-tip"><option value="ING. FACTURAS">Ing. Facturas</option><option value="ING. POSNET">Ing. Posnet</option><option value="ING. TRANSFERENCIA">Ing. Transferencia</option><option value="ING. TICKET">Ing. Ticket</option><option value="DEPOSITO">Deposito</option><option value="EGRESO">Egreso</option><option value="CIERRE DIA">Cierre del dia</option></select></div>
          <div class="fg"><label>Importe</label><input type="text" id="ca-imp" placeholder="Ej: 1.078.500" oninput="cleanN(this)"></div>
          <div class="fg"><label>Banco</label><input type="text" id="ca-ban"></div>
          <div class="fg"><label>Flujo</label><select id="ca-flu"><option value="ingreso">Ingreso</option><option value="egreso">Egreso</option></select></div>
          <div class="fg"><label>Obs</label><input type="text" id="ca-obs" placeholder="Opcional"></div>
        </div>
        <div class="div"></div>
        <div class="fa"><button class="btn bp" id="btn-sca" onclick="saveCaja()">Guardar movimiento</button><button class="btn bg" onclick="clearFCA()">Limpiar</button></div>
      </div>
    </div></div>

    <div id="page-lc" class="page">
      <div class="card">
        <div class="ch">
          <div><div class="ct2">Cobros registrados</div><div class="cm" id="lc-meta">--</div></div>
          <div class="cctrl no-print">
            <input class="fi" type="text" id="sc" placeholder="Buscar..." oninput="renderCobros()" style="width:110px">
            <select class="fi" id="fm" onchange="renderCobros()"><option value="">Todos los meses</option><option value="1">Ene</option><option value="2">Feb</option><option value="3">Mar</option><option value="4">Abr</option><option value="5">May</option><option value="6">Jun</option><option value="7">Jul</option><option value="8">Ago</option><option value="9">Sep</option><option value="10">Oct</option><option value="11">Nov</option><option value="12">Dic</option></select>
            <select class="fi" id="fe" onchange="renderCobros()"><option value="">Todos</option><option value="cobrado">Cobrado</option><option value="pendiente">Pendiente</option><option value="anulado">Anulado</option></select>
          </div>
        </div>
        <div class="tscroll"><table><thead><tr><th>#</th><th>Fecha</th><th>Socio</th><th>Mes</th><th class="uh">Usuario</th><th>Cobrador</th><th>Empresa</th><th class="num">Importe</th><th>Fac.</th><th>Estado</th><th class="no-print">Acc.</th></tr></thead><tbody id="tb-cobros"></tbody><tfoot><tr><td colspan="7">TOTAL</td><td class="num" id="lc-total">--</td><td colspan="3"></td></tr></tfoot></table></div>
      </div>
    </div>

    <div id="page-lt" class="page">
      <div class="card">
        <div class="ch"><div><div class="ct2">Tickets devueltos</div><div class="cm" id="lt-meta">--</div></div></div>
        <div class="tscroll"><table><thead><tr><th>Fecha</th><th>Socio</th><th>Mes</th><th class="uh">Usuario</th><th>Empresa</th><th class="num">Importe</th><th>Ticket</th><th>Motivo</th><th class="no-print">Acc.</th></tr></thead><tbody id="tb-tickets"></tbody><tfoot><tr><td colspan="5">TOTAL</td><td class="num" id="lt-total">--</td><td colspan="3"></td></tr></tfoot></table></div>
      </div>
    </div>

    <div id="page-lca" class="page">
      <div class="csum" id="csum"></div>
      <div class="card">
        <div class="ch">
          <div><div class="ct2">Movimientos de caja</div><div class="cm" id="lca-meta">--</div></div>
          <div class="cctrl no-print">
            <select class="fi" id="fce" onchange="renderCaja()"><option value="">Todas</option><option value="San Nicolás">San Nicolás</option><option value="Renacimiento">Renacimiento</option><option value="Cocheria">Cocheria</option></select>
            <select class="fi" id="fcf" onchange="renderCaja()"><option value="">Ing.+Eg.</option><option value="ingreso">Ingresos</option><option value="egreso">Egresos</option></select>
          </div>
        </div>
        <div class="tscroll"><table><thead><tr><th>Fecha</th><th>Empresa</th><th>Localidad</th><th class="uh">Usuario</th><th>Tipo</th><th>Banco</th><th>Flujo</th><th class="num">Importe</th><th class="no-print">Acc.</th></tr></thead><tbody id="tb-caja"></tbody><tfoot><tr><td colspan="6"></td><td>NETO</td><td class="num" id="lca-neto">--</td><td></td></tr></tfoot></table></div>
      </div>
    </div>

    <div id="page-aprobacion" class="page">
      <div class="card" style="margin-bottom:1rem">
        <div class="ch">
          <div><div class="ct2" id="aprov-title">Pendientes de aprobacion</div><div class="cm" id="aprov-meta">--</div></div>
          <div class="cctrl no-print">
            <select class="fi" id="f-aprov-tipo" onchange="renderAprobacion()"><option value="">Todos los tipos</option><option value="cobros">Cobros</option><option value="tickets">Tickets</option><option value="caja">Caja</option></select>
            <select class="fi" id="f-aprov-zona" onchange="renderAprobacion()"><option value="">Todas las zonas</option><option value="1">Zona 1</option><option value="2">Zona 2</option></select>
          </div>
        </div>
      </div>
      <div id="aprov-list"><div style="padding:2rem;text-align:center;color:var(--txt3)">Sin registros pendientes</div></div>
    </div>

    <div id="page-planilla" class="page">

      <!-- HEADER cierre diario -->
      <div class="card" style="margin-bottom:1rem">
        <div class="ch" style="flex-wrap:wrap;gap:10px">
          <div>
            <div class="ct2">📋 Cierre Diario</div>
            <div class="cm" id="pl-meta">Selecciona la fecha y envia el cierre al administrador de zona</div>
          </div>
          <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap">
            <input type="date" id="pl-fecha" class="fi" style="font-size:13px" onchange="renderPlanilla()">
            <button class="btn bp" id="pl-enviar-btn" onclick="enviarPlanilla()" style="font-weight:700">
              Enviar cierre del día
            </button>
          </div>
        </div>
      </div>

      <!-- KPIs de la planilla -->
      <div class="kgrid">
        <div class="kpi blue"><div class="kl">Total pendiente</div><div class="kv" id="pl-total">--</div><div class="ks" id="pl-cant">0 registros</div></div>
        <div class="kpi green"><div class="kl">Cobros</div><div class="kv" id="pl-cobros-total">--</div><div class="ks" id="pl-cobros-cant">0 registros</div></div>
        <div class="kpi red"><div class="kl">Tickets</div><div class="kv" id="pl-tickets-total">--</div><div class="ks" id="pl-tickets-cant">0 registros</div></div>
        <div class="kpi amber"><div class="kl">Caja</div><div class="kv" id="pl-caja-total">--</div><div class="ks" id="pl-caja-cant">0 registros</div></div>
      </div>

      <!-- Tabla unica con todos los registros -->
      <div class="card">
        <div class="ch">
          <div><div class="ct2">Detalle de registros</div><div class="cm" id="pl-detalle-meta">Cobros, tickets y caja agrupados</div></div>
          <button class="btn bs sm no-print" onclick="exportPlanillaCSV()">CSV</button>
        </div>
        <div class="tscroll"><table>
          <thead><tr><th>Fecha</th><th>Tipo</th><th>Cobrador</th><th>Socio / Detalle</th><th>Mes</th><th>Empresa</th><th class="num">Importe</th><th>Estado</th></tr></thead>
          <tbody id="tb-planilla"></tbody>
          <tfoot><tr><td colspan="6">TOTAL PLANILLA</td><td class="num" id="pl-total-foot">--</td><td></td></tr></tfoot>
        </table></div>
      </div>

    </div>

    <div id="page-cierres" class="page">

      <div class="card" style="margin-bottom:1rem">
        <div class="ch" style="flex-wrap:wrap;gap:10px">
          <div>
            <div class="ct2">📚 Historial de cierres</div>
            <div class="cm" id="ci-meta">Todos los cierres enviados al administrador de zona</div>
          </div>
          <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap">
            <select id="ci-filtro-estado" class="fi" style="font-size:12px" onchange="renderCierres()">
              <option value="">Todos los estados</option>
              <option value="enviado">Enviado</option>
              <option value="aprobado">Aprobado</option>
              <option value="rechazado">Rechazado</option>
            </select>
            <input type="date" id="ci-desde" class="fi" style="font-size:12px" onchange="renderCierres()">
            <input type="date" id="ci-hasta" class="fi" style="font-size:12px" onchange="renderCierres()">
            <button class="btn bg sm" onclick="clearFiltrosCierres()">Limpiar</button>
          </div>
        </div>
      </div>

      <!-- KPIs acumulados -->
      <div class="kgrid">
        <div class="kpi blue"><div class="kl">Cierres enviados</div><div class="kv" id="ci-cant">--</div><div class="ks" id="ci-cant-sub">total</div></div>
        <div class="kpi green"><div class="kl">Total cobrado</div><div class="kv" id="ci-cobros">--</div><div class="ks">acumulado</div></div>
        <div class="kpi red"><div class="kl">Total tickets</div><div class="kv" id="ci-tickets">--</div><div class="ks">acumulado</div></div>
        <div class="kpi purple"><div class="kl">Neto acumulado</div><div class="kv" id="ci-neto">--</div><div class="ks">cobros - tickets</div></div>
      </div>

      <!-- Lista de cierres -->
      <div class="card">
        <div class="ch">
          <div><div class="ct2">Cierres detallados</div><div class="cm" id="ci-tabla-meta">--</div></div>
          <button class="btn bs sm no-print" onclick="exportCierresCSV()">CSV</button>
        </div>
        <div class="tscroll"><table>
          <thead><tr><th>Fecha</th><th>Estado</th><th>Cobros</th><th class="num">Total cobros</th><th>Tickets</th><th class="num">Total tickets</th><th>Caja</th><th class="num">Total caja</th><th class="num">Neto</th><th>Enviado</th><th>Revisado por</th></tr></thead>
          <tbody id="tb-ci"></tbody>
          <tfoot><tr><td colspan="3">TOTAL</td><td class="num" id="cif-cobros">--</td><td></td><td class="num" id="cif-tickets">--</td><td></td><td class="num" id="cif-caja">--</td><td class="num" id="cif-neto">--</td><td colspan="2"></td></tr></tfoot>
        </table></div>
      </div>

    </div>

    <div id="page-mis-cobradores" class="page">

      <!-- LISTA DE COBRADORES DE LA AGENCIA -->
      <div class="card" style="margin-bottom:1rem">
        <div class="ch"><div><div class="ct2">Mis Cobradores</div><div class="cm" id="mc-meta">--</div></div></div>
        <div class="tscroll"><table>
          <thead><tr><th>#</th><th>Nombre</th><th>Zona</th><th>Activo</th><th class="no-print">Acciones</th></tr></thead>
          <tbody id="tb-mc"></tbody>
        </table></div>
      </div>

      <!-- FILTROS PARA VER COBROS POR COBRADOR -->
      <div class="card" style="margin-bottom:1rem">
        <div class="ch"><div class="ct2">Ver cobros por cobrador</div><button class="btn bg sm" onclick="clearFiltrosCob()">Limpiar</button></div>
        <div style="padding:.9rem 1.1rem;display:grid;grid-template-columns:repeat(auto-fit,minmax(140px,1fr));gap:10px">
          <div class="fg"><label>Desde</label><input type="date" id="fc-desde" class="fi" style="font-size:12px" onchange="renderCobrosAgencia()"></div>
          <div class="fg"><label>Hasta</label><input type="date" id="fc-hasta" class="fi" style="font-size:12px" onchange="renderCobrosAgencia()"></div>
          <div class="fg"><label>Cobrador</label><select id="fc-cobrador" class="fi" style="font-size:12px" onchange="renderCobrosAgencia()"><option value="">Todos</option></select></div>
          <div class="fg"><label>Socio</label><input type="text" id="fc-socio" class="fi" style="font-size:12px" placeholder="N° o nombre..." oninput="renderCobrosAgencia()"></div>
          <div class="fg"><label>Mes</label><select id="fc-mes" class="fi" style="font-size:12px" onchange="renderCobrosAgencia()"><option value="">Todos</option><option value="1">Ene</option><option value="2">Feb</option><option value="3">Mar</option><option value="4">Abr</option><option value="5">May</option><option value="6">Jun</option><option value="7">Jul</option><option value="8">Ago</option><option value="9">Sep</option><option value="10">Oct</option><option value="11">Nov</option><option value="12">Dic</option></select></div>
          <div class="fg"><label>Empresa</label><select id="fc-empresa" class="fi" style="font-size:12px" onchange="renderCobrosAgencia()"><option value="">Todas</option><option value="San Nicolás">San Nicolás</option><option value="Renacimiento">Renacimiento</option></select></div>
        </div>
      </div>

      <!-- KPIs -->
      <div class="kgrid" id="mc-kgrid">
        <div class="kpi blue"><div class="kl">Total cobrado</div><div class="kv" id="mc-tc">--</div><div class="ks" id="mc-tcs">0 facturas</div></div>
        <div class="kpi red"><div class="kl">Tickets</div><div class="kv" id="mc-tt">--</div><div class="ks" id="mc-tts">devueltos</div></div>
        <div class="kpi green"><div class="kl">Neto</div><div class="kv" id="mc-nt">--</div><div class="ks">cobros-tickets</div></div>
        <div class="kpi amber"><div class="kl">Socios</div><div class="kv" id="mc-soc">--</div><div class="ks">en el periodo</div></div>
      </div>

      <!-- TABLA COBROS FILTRADOS -->
      <div class="card">
        <div class="ch">
          <div><div class="ct2">Cobros del periodo</div><div class="cm" id="mc-cobros-meta">--</div></div>
          <button class="btn bs sm no-print" onclick="exportCobrosAgenciaXLSX()">XLSX</button>
            <button class="btn bg sm no-print" onclick="exportCobrosAgenciaCSV()">CSV</button>
        </div>
        <div class="tscroll"><table>
          <thead><tr><th>Fecha</th><th>Cobrador</th><th>Socio</th><th>Mes</th><th>Empresa</th><th class="num">Importe</th><th>Factura</th><th>Estado</th></tr></thead>
          <tbody id="tb-mc-cobros"></tbody>
          <tfoot><tr><td colspan="5">TOTAL</td><td class="num" id="mc-total">--</td><td colspan="2"></td></tr></tfoot>
        </table></div>
      </div>

      <!-- RESUMEN POR COBRADOR -->
      <div class="card">
        <div class="ch"><div class="ct2">Resumen por cobrador</div></div>
        <div class="tscroll"><table>
          <thead><tr><th>Cobrador</th><th>Cobros</th><th>Socios</th><th class="num">Total cobrado</th><th>Tickets</th><th class="num">Total tickets</th><th class="num">Neto</th></tr></thead>
          <tbody id="tb-mc-resumen"></tbody>
        </table></div>
      </div>
    </div>

    <div id="page-enlaces" class="page">
      <div class="card" style="margin-bottom:1rem">
        <div class="ch">
          <div>
            <div class="ct2">🔗 Enlaces de acceso personalizados</div>
            <div class="cm">Generá un enlace único para cada usuario. Al abrirlo desde cualquier dispositivo, el usuario queda preseleccionado y solo necesita ingresar su PIN o contraseña.</div>
          </div>
        </div>
        <div style="padding:1rem 1.25rem;background:var(--bg3);border-top:1px solid var(--bord)">
          <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap">
            <label style="font-size:11px;color:var(--txt3);text-transform:uppercase;font-weight:700">Filtrar:</label>
            <select class="fi" id="enl-rol-filter" style="font-size:12px" onchange="renderEnlaces()">
              <option value="">Todos los roles</option>
              <option value="admin_central">Admin Central</option>
              <option value="admin_zona">Admin Zona</option>
              <option value="agencia">Agencias</option>
              <option value="cobrador">Cobradores</option>
            </select>
            <select class="fi" id="enl-zona-filter" style="font-size:12px" onchange="renderEnlaces()">
              <option value="">Todas las zonas</option>
              <option value="1">Zona 1</option>
              <option value="2">Zona 2</option>
            </select>
            <input type="text" id="enl-busq" class="fi" style="font-size:12px;width:160px" placeholder="Buscar por nombre..." oninput="renderEnlaces()">
            <button class="btn bs sm" onclick="exportEnlacesCSV()">Exportar lista CSV</button>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="ch">
          <div><div class="ct2">Usuarios y sus enlaces</div><div class="cm" id="enl-meta">--</div></div>
        </div>
        <div class="tscroll"><table>
          <thead><tr><th>#</th><th>Nombre</th><th>Rol</th><th>Localidad</th><th>Enlace personalizado</th><th class="no-print">Acción</th></tr></thead>
          <tbody id="tb-enlaces"></tbody>
        </table></div>
      </div>
    </div>

    <div id="page-usuarios" class="page">
      <div class="card">
        <div class="ch"><div><div class="ct2">Gestion de usuarios</div><div class="cm">Modifica nombre, localidad y PIN</div></div></div>
        <div class="tscroll"><table><thead><tr><th>#</th><th>Nombre</th><th>Localidad</th><th>Rol</th><th>Activo</th><th class="no-print">Acciones</th></tr></thead><tbody id="tb-us"></tbody></table></div>
      </div>
    </div>

  </div>
</div>

<!-- NOTIFICATION POPUP -->
<div id="notif-popup">
  <div class="notif-header">
    <span style="font-size:13px;font-weight:700;color:var(--txt)">Notificaciones</span>
    <button onclick="marcarTodasLeidas()" style="font-size:11px;color:var(--red);background:none;border:none;cursor:pointer;font-family:inherit">Borrar todas</button>
  </div>
  <div id="notif-list"><div style="padding:1.5rem;text-align:center;color:var(--txt3);font-size:13px">Sin notificaciones</div></div>
</div>

<!-- REJECTION MODAL -->
<div class="ov" id="ov-rechazo">
  <div class="modal msm">
    <div class="mtitle">Rechazar registro</div>
    <div style="margin:1rem 0">
      <div class="fg"><label>Motivo del rechazo</label><input type="text" id="motivo-rechazo" placeholder="Ej: Importe incorrecto, falta factura..."></div>
    </div>
    <div class="mact">
      <button class="btn bg" onclick="hideOv('ov-rechazo')">Cancelar</button>
      <button class="btn bd" onclick="confirmarRechazo()">Rechazar</button>
    </div>
  </div>
</div>

<div class="ov" id="ovedit">
  <div class="modal"><div class="mtitle" id="etit">Editar</div><div style="margin-bottom:1rem"></div><div id="efields"></div>
  <div class="mact"><button class="btn bg" onclick="hideOv('ovedit')">Cancelar</button><button class="btn bp" id="e-sav" onclick="saveEdit()">Guardar</button></div></div>
</div>
<div class="ov" id="oveu">
  <div class="modal msm"><div class="mtitle" id="eu-tit">Editar usuario</div>
  <div style="margin:1rem 0;display:flex;flex-direction:column;gap:12px">
    <div class="fg"><label>Nombre</label><input type="text" id="eu-nom"></div>
    <div class="fg"><label>Localidad</label><input type="text" id="eu-loc"></div>
    <div class="fg"><label>Nuevo PIN (vacio = no cambiar)</label><input type="password" id="eu-pin"></div>
    <div class="fg"><label>Activo</label><select id="eu-act"><option value="true">Si</option><option value="false">No</option></select></div>
  </div>
  <div class="mact"><button class="btn bg" onclick="hideOv('oveu')">Cancelar</button><button class="btn bp" onclick="saveUser()">Guardar</button></div></div>
</div>
<div class="ov" id="ovdel">
  <div class="modal msm"><div class="mtitle">Eliminar registro?</div>
  <div class="msub">Se borrara de Supabase. No se puede deshacer.</div>
  <div class="mact"><button class="btn bg" onclick="hideOv('ovdel')">Cancelar</button><button class="btn bd" onclick="confirmDel()">Eliminar</button></div></div>
</div>
<div class="ov" id="ovprt">
  <div class="modal msm">
    <div class="mtitle">Imprimir reporte</div>
    <div style="margin:1rem 0;display:flex;flex-direction:column;gap:4px">
      <label style="display:flex;align-items:center;gap:12px;padding:.6rem .75rem;border-radius:8px;cursor:pointer;font-size:13px;color:var(--txt);background:var(--bg3);border:1px solid transparent;transition:border-color .12s" onmouseover="this.style.borderColor='var(--bord2)'" onmouseout="this.style.borderColor='transparent'">
        <input type="radio" name="pr" value="dashboard" checked style="width:16px;height:16px;accent-color:var(--blue);flex-shrink:0;cursor:pointer"> Dashboard general
      </label>
      <label style="display:flex;align-items:center;gap:12px;padding:.6rem .75rem;border-radius:8px;cursor:pointer;font-size:13px;color:var(--txt);background:var(--bg3);border:1px solid transparent;transition:border-color .12s" onmouseover="this.style.borderColor='var(--bord2)'" onmouseout="this.style.borderColor='transparent'">
        <input type="radio" name="pr" value="lc" style="width:16px;height:16px;accent-color:var(--blue);flex-shrink:0;cursor:pointer"> Cobros registrados
      </label>
      <label style="display:flex;align-items:center;gap:12px;padding:.6rem .75rem;border-radius:8px;cursor:pointer;font-size:13px;color:var(--txt);background:var(--bg3);border:1px solid transparent;transition:border-color .12s" onmouseover="this.style.borderColor='var(--bord2)'" onmouseout="this.style.borderColor='transparent'">
        <input type="radio" name="pr" value="lt" style="width:16px;height:16px;accent-color:var(--blue);flex-shrink:0;cursor:pointer"> Tickets devueltos
      </label>
      <label style="display:flex;align-items:center;gap:12px;padding:.6rem .75rem;border-radius:8px;cursor:pointer;font-size:13px;color:var(--txt);background:var(--bg3);border:1px solid transparent;transition:border-color .12s" onmouseover="this.style.borderColor='var(--bord2)'" onmouseout="this.style.borderColor='transparent'">
        <input type="radio" name="pr" value="lca" style="width:16px;height:16px;accent-color:var(--blue);flex-shrink:0;cursor:pointer"> Movimiento de caja
      </label>
      <label id="po-ct" style="display:flex;align-items:center;gap:12px;padding:.6rem .75rem;border-radius:8px;cursor:pointer;font-size:13px;color:var(--txt);background:var(--bg3);border:1px solid transparent;transition:border-color .12s" onmouseover="this.style.borderColor='var(--bord2)'" onmouseout="this.style.borderColor='transparent'">
        <input type="radio" name="pr" value="central" style="width:16px;height:16px;accent-color:var(--blue);flex-shrink:0;cursor:pointer"> Vista Central / Zona
      </label>
    </div>
    <div class="mact">
      <button class="btn bg" onclick="hideOv('ovprt')">Cancelar</button>
      <button class="btn bp" onclick="doPrint()">Imprimir</button>
    </div>
  </div>
</div>

<script>

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
  pw.document.write('

<div id="pwa-banner">
  <div class="pwa-inner">
    <div class="pwa-icon">SN</div>
    <div class="pwa-text">
      <div class="pwa-title">Instalar San Nicolás</div>
      <div class="pwa-sub" id="pwa-sub-txt">Agrega la app a tu pantalla de inicio</div>
    </div>

  <script src="js/app.js"></script>
  <script src="js/pwa.js"></script>
</body>
</html>