<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pizza Builder — Seguimiento de pedido</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@500;600;700;800&family=DM+Sans:wght@400;500;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
  :root{
    --masa:#FBF3E4;
    --masa-dark:#EBDCC0;
    --tomate:#D6472A;
    --tomate-dark:#B5381F;
    --albahaca:#4B7A51;
    --queso:#F2A93B;
    --carbon:#2B2118;
    --carbon-soft:#5B4D40;
    --white:#FFFFFF;
    --shadow: 0 10px 30px rgba(43,33,24,0.12);
  }

  *{ box-sizing:border-box; }

  body{
    margin:0;
    min-height:100vh;
    background:
      radial-gradient(circle at 15% 8%, rgba(214,71,42,0.06), transparent 40%),
      radial-gradient(circle at 85% 92%, rgba(75,122,81,0.08), transparent 40%),
      var(--masa);
    font-family:'DM Sans', sans-serif;
    color:var(--carbon);
    display:flex;
    justify-content:center;
    padding:32px 16px;
  }

  .phone{
    width:100%;
    max-width:420px;
    background:var(--white);
    border-radius:32px;
    box-shadow: var(--shadow);
    overflow:hidden;
    border:1px solid rgba(43,33,24,0.06);
    position:relative;
  }

  /* ---------- Top bar ---------- */
  .topbar{
    display:flex;
    align-items:center;
    justify-content:space-between;
    padding:20px 22px 14px;
  }
  .topbar .back{
    width:36px;height:36px;border-radius:50%;
    background:var(--masa);
    display:flex;align-items:center;justify-content:center;
    color:var(--carbon);
    font-size:16px;
    cursor:pointer;
  }
  .brand{
    font-family:'Baloo 2', sans-serif;
    font-weight:800;
    font-size:16px;
    letter-spacing:0.2px;
    color:var(--tomate);
    display:flex;
    align-items:center;
    gap:6px;
  }
  .order-id{
    font-family:'DM Mono', monospace;
    font-size:11px;
    color:var(--carbon-soft);
    background:var(--masa);
    padding:4px 10px;
    border-radius:20px;
  }

  /* ---------- Hero status ---------- */
  .hero{
    padding:6px 24px 18px;
    text-align:left;
  }
  .hero .eyebrow{
    font-family:'DM Mono', monospace;
    font-size:11px;
    text-transform:uppercase;
    letter-spacing:1.5px;
    color:var(--albahaca);
    display:flex;
    align-items:center;
    gap:6px;
    margin-bottom:6px;
  }
  .eyebrow .dot{
    width:7px;height:7px;border-radius:50%;
    background:var(--albahaca);
    animation:pulse 1.4s infinite ease-in-out;
  }
  @keyframes pulse{
    0%,100%{ transform:scale(1); opacity:1; }
    50%{ transform:scale(1.6); opacity:0.4; }
  }
  h1.status{
    font-family:'Baloo 2', sans-serif;
    font-weight:700;
    font-size:24px;
    line-height:1.15;
    margin:0 0 6px;
    transition:opacity 0.3s ease;
  }
  .eta-row{
    display:flex;
    align-items:baseline;
    gap:8px;
    color:var(--carbon-soft);
    font-size:14px;
  }
  .eta-row strong{
    font-family:'DM Mono', monospace;
    font-size:20px;
    color:var(--carbon);
    font-weight:500;
  }

  /* ---------- Stepper ---------- */
  .stepper{
    display:flex;
    align-items:center;
    padding:8px 24px 20px;
    gap:4px;
  }
  .step{
    flex:1;
    display:flex;
    flex-direction:column;
    align-items:center;
    gap:6px;
    position:relative;
  }
  .step .bubble{
    width:30px;height:30px;
    border-radius:50%;
    background:var(--masa);
    border:2px solid var(--masa-dark);
    display:flex;align-items:center;justify-content:center;
    font-size:14px;
    transition:all 0.4s ease;
    z-index:2;
  }
  .step.done .bubble{
    background:var(--albahaca);
    border-color:var(--albahaca);
    color:var(--white);
  }
  .step.active .bubble{
    background:var(--tomate);
    border-color:var(--tomate);
    color:var(--white);
    box-shadow:0 0 0 5px rgba(214,71,42,0.15);
  }
  .step .label{
    font-size:10.5px;
    color:var(--carbon-soft);
    text-align:center;
    font-weight:500;
  }
  .step.active .label, .step.done .label{ color:var(--carbon); font-weight:700; }
  .track-line{
    position:absolute;
    top:15px; left:-50%; right:50%;
    height:2px;
    background:var(--masa-dark);
    z-index:1;
  }
  .step:first-child .track-line{ display:none; }
  .step.done .track-line, .step.active .track-line{ background:var(--albahaca); }

  /* ---------- Courier card ---------- */
  .courier-card{
    margin:0 20px 18px;
    background:var(--masa);
    border-radius:20px;
    padding:14px;
    display:flex;
    align-items:center;
    gap:12px;
  }
  .avatar{
    width:52px;height:52px;
    border-radius:50%;
    flex-shrink:0;
    background:linear-gradient(160deg, var(--queso), var(--tomate));
    display:flex;align-items:center;justify-content:center;
    box-shadow: inset 0 -3px 6px rgba(0,0,0,0.15);
  }
  .courier-info{ flex:1; min-width:0; }
  .courier-info .name{
    font-family:'Baloo 2', sans-serif;
    font-weight:700;
    font-size:15px;
    margin:0 0 2px;
  }
  .courier-info .meta{
    font-size:12px;
    color:var(--carbon-soft);
    display:flex;
    align-items:center;
    gap:6px;
  }
  .courier-info .meta .stars{ color:var(--queso); letter-spacing:1px; }
  .courier-actions{ display:flex; gap:8px; }
  .icon-btn{
    width:38px;height:38px;
    border-radius:50%;
    border:none;
    background:var(--white);
    display:flex;align-items:center;justify-content:center;
    font-size:15px;
    cursor:pointer;
    box-shadow:0 2px 6px rgba(43,33,24,0.08);
    transition:transform 0.15s ease;
  }
  .icon-btn:active{ transform:scale(0.92); }

  /* ---------- Map ---------- */
  .map-wrap{
    margin:0 20px 20px;
    border-radius:20px;
    overflow:hidden;
    background:#DCE9DC;
    position:relative;
    height:230px;
  }
  .map-wrap svg{ width:100%; height:100%; display:block; }
  .map-badge{
    position:absolute;
    top:10px; left:10px;
    background:rgba(255,255,255,0.92);
    padding:5px 10px;
    border-radius:20px;
    font-size:11px;
    font-weight:700;
    color:var(--carbon);
    display:flex;
    align-items:center;
    gap:5px;
  }
  .map-badge .dot{ width:6px;height:6px;border-radius:50%; background:var(--tomate); animation:pulse 1.4s infinite ease-in-out; }

  /* ---------- Delivered state ---------- */
  .delivered-panel{
    margin:0 20px 22px;
    text-align:center;
    padding:26px 18px 22px;
    background:var(--masa);
    border-radius:20px;
    display:none;
  }
  .delivered-panel.show{ display:block; animation:fadeUp 0.5s ease; }
  @keyframes fadeUp{
    from{ opacity:0; transform:translateY(10px); }
    to{ opacity:1; transform:translateY(0); }
  }
  .stamp{
    width:64px;height:64px;
    border-radius:50%;
    background:var(--albahaca);
    color:var(--white);
    display:flex;align-items:center;justify-content:center;
    font-size:30px;
    margin:0 auto 14px;
    box-shadow:0 8px 20px rgba(75,122,81,0.3);
  }
  .delivered-panel h2{
    font-family:'Baloo 2', sans-serif;
    margin:0 0 6px;
    font-size:19px;
  }
  .delivered-panel p{
    margin:0 0 16px;
    font-size:13px;
    color:var(--carbon-soft);
  }
  .rate-row{
    display:flex; justify-content:center; gap:8px; margin-bottom:18px;
  }
  .rate-row span{
    font-size:22px;
    cursor:pointer;
    filter:grayscale(1);
    opacity:0.4;
    transition:all 0.15s ease;
  }
  .rate-row span:hover, .rate-row span.picked{ filter:none; opacity:1; transform:scale(1.15); }
  .cta{
    width:100%;
    border:none;
    background:var(--tomate);
    color:var(--white);
    font-family:'Baloo 2', sans-serif;
    font-weight:700;
    font-size:15px;
    padding:13px;
    border-radius:14px;
    cursor:pointer;
    transition:background 0.15s ease;
  }
  .cta:hover{ background:var(--tomate-dark); }

  /* demo control */
  .demo-note{
    text-align:center;
    padding:0 20px 22px;
  }
  .demo-note button{
    background:none;
    border:1px dashed var(--carbon-soft);
    color:var(--carbon-soft);
    font-size:11.5px;
    padding:7px 14px;
    border-radius:20px;
    cursor:pointer;
    font-family:'DM Sans', sans-serif;
  }
  .demo-note button:hover{ border-color:var(--tomate); color:var(--tomate); }

  #enroute-block.hide{ display:none; }
</style>
</head>
<body>

<div class="phone">

  <div class="topbar">
    <div class="back">←</div>
    <div class="brand">🍕 Pizza Builder</div>
    <div class="order-id">#PB-4821</div>
  </div>

  <div class="hero">
    <div class="eyebrow"><span class="dot"></span> <span id="eyebrow-text">EN VIVO</span></div>
    <h1 class="status" id="status-text">Tu pizza va en camino</h1>
    <div class="eta-row" id="eta-row">
      Llega en <strong id="eta-count">08:00</strong> min
    </div>
  </div>

  <div class="stepper">
    <div class="step done" id="step-1">
      <div class="track-line"></div>
      <div class="bubble">✓</div>
      <div class="label">Confirmado</div>
    </div>
    <div class="step done" id="step-2">
      <div class="track-line"></div>
      <div class="bubble">✓</div>
      <div class="label">Preparando</div>
    </div>
    <div class="step active" id="step-3">
      <div class="track-line"></div>
      <div class="bubble">🛵</div>
      <div class="label">En camino</div>
    </div>
    <div class="step" id="step-4">
      <div class="track-line"></div>
      <div class="bubble">🏠</div>
      <div class="label">Entregado</div>
    </div>
  </div>

  <div id="enroute-block">
    <div class="courier-card">
      <div class="avatar">
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="8" r="4" fill="white" opacity="0.95"/>
          <path d="M4 20c0-4.4 3.6-7 8-7s8 2.6 8 7" fill="white" opacity="0.95"/>
        </svg>
      </div>
      <div class="courier-info">
        <p class="name">Rodrigo Márquez</p>
        <div class="meta"><span class="stars">★★★★★</span> 4.9 · Moto</div>
      </div>
      <div class="courier-actions">
        <button class="icon-btn" title="Llamar">📞</button>
        <button class="icon-btn" title="Mensaje">💬</button>
      </div>
    </div>

    <div class="map-wrap">
      <div class="map-badge"><span class="dot"></span> Rodrigo se está moviendo</div>
      <svg viewBox="0 0 400 240" xmlns="http://www.w3.org/2000/svg">
        <rect width="400" height="240" fill="#DCE9DC"/>
        <!-- manzanas / bloques -->
        <g fill="#C9DEC8">
          <rect x="15" y="15" width="60" height="45" rx="6"/>
          <rect x="120" y="20" width="45" height="35" rx="6"/>
          <rect x="250" y="10" width="55" height="50" rx="6"/>
          <rect x="20" y="170" width="55" height="45" rx="6"/>
          <rect x="150" y="185" width="45" height="40" rx="6"/>
          <rect x="300" y="150" width="60" height="55" rx="6"/>
          <rect x="330" y="30" width="45" height="40" rx="6"/>
        </g>
        <!-- calles -->
        <path d="M40,90 L40,220 M0,90 L400,90 M200,0 L200,240 M0,150 L400,150" stroke="#F3F0E4" stroke-width="10" stroke-linecap="round"/>
        <!-- ruta punteada -->
        <path id="route" d="M55,45 L55,90 L200,90 L200,150 L345,150 L345,190"
              fill="none" stroke="#D6472A" stroke-width="4" stroke-dasharray="2 9" stroke-linecap="round"/>
        <!-- pizzería -->
        <g transform="translate(45,35)">
          <circle r="13" fill="#D6472A"/>
          <text x="0" y="5" font-size="14" text-anchor="middle">🍕</text>
        </g>
        <!-- casa destino -->
        <g transform="translate(345,190)">
          <circle r="13" fill="#4B7A51"/>
          <text x="0" y="5" font-size="13" text-anchor="middle">🏠</text>
        </g>
        <!-- repartidor -->
        <g id="courier-marker">
          <circle r="12" fill="#2B2118"/>
          <text x="0" y="5" font-size="13" text-anchor="middle">🛵</text>
          <animateMotion id="motion" dur="26s" repeatCount="1" fill="freeze"
            path="M55,45 L55,90 L200,90 L200,150 L345,150 L345,190" />
        </g>
      </svg>
    </div>
  </div>

  <div class="delivered-panel" id="delivered-panel">
    <div class="stamp">✓</div>
    <h2>¡Tu pizza fue entregada!</h2>
    <p>Rodrigo la dejó justo a tiempo. Buen provecho 🍕</p>
    <div class="rate-row" id="rate-row">
      <span data-v="1">★</span><span data-v="2">★</span><span data-v="3">★</span><span data-v="4">★</span><span data-v="5">★</span>
    </div>
    <button class="cta">Volver a pedir</button>
  </div>

  <div class="demo-note">
    <button id="skip-btn">Simular entrega ahora (demo)</button>
  </div>

</div>

<script>
  const totalSeconds = 26; // duración del recorrido simulado
  let remaining = totalSeconds;
  const etaEl = document.getElementById('eta-count');
  const statusText = document.getElementById('status-text');
  const eyebrowText = document.getElementById('eyebrow-text');
  const enrouteBlock = document.getElementById('enroute-block');
  const deliveredPanel = document.getElementById('delivered-panel');
  const step3 = document.getElementById('step-3');
  const step4 = document.getElementById('step-4');

  function formatTime(s){
    const m = Math.floor(s/60).toString().padStart(2,'0');
    const sec = (s%60).toString().padStart(2,'0');
    return m+':'+sec;
  }

  let timer = setInterval(()=>{
    remaining--;
    if(remaining <= 0){
      remaining = 0;
      clearInterval(timer);
      markDelivered();
    }
    etaEl.textContent = formatTime(remaining);
  }, 1000);

  function markDelivered(){
    statusText.textContent = '¡Pizza entregada!';
    eyebrowText.textContent = 'COMPLETADO';
    document.querySelector('.eyebrow .dot').style.background = 'var(--albahaca)';
    document.querySelector('.eta-row').style.display = 'none';

    step3.classList.remove('active');
    step3.classList.add('done');
    step3.querySelector('.bubble').textContent = '✓';
    step4.classList.add('done');
    step4.querySelector('.bubble').textContent = '✓';

    enrouteBlock.classList.add('hide');
    deliveredPanel.classList.add('show');
  }

  document.getElementById('skip-btn').addEventListener('click', ()=>{
    clearInterval(timer);
    document.getElementById('motion').setAttribute('dur','0.3s');
    markDelivered();
  });

  document.querySelectorAll('#rate-row span').forEach(star=>{
    star.addEventListener('click', function(){
      const v = parseInt(this.dataset.v);
      document.querySelectorAll('#rate-row span').forEach(s=>{
        s.classList.toggle('picked', parseInt(s.dataset.v) <= v);
      });
    });
  });
</script>

</body>
</html>
