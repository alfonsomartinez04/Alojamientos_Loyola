# Generador de la nueva interfaz web moderna para Alojamientos Loyola
$jsonPath = "c:\Users\alfon\Documents\UNI\TERCERO\1er CUATRI\ADBBDD\TPI\alojamientos-loyola\scratch_20_alojamientos.json"
$htmlPath = "c:\Users\alfon\Documents\UNI\TERCERO\1er CUATRI\ADBBDD\TPI\alojamientos-loyola\mapa_alojamientos.html"

$jsonData = Get-Content -Path $jsonPath -Raw -Encoding UTF8

$htmlContent = @'
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Loyola Living · Buscador Geoespacial de Alojamientos (PostGIS)</title>
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <style>
    :root {
      --primary: #0a2540;
      --primary-light: #16426d;
      --accent: #0284c7;
      --accent-hover: #0369a1;
      --success: #059669;
      --warning: #d97706;
      --bg: #f8fafc;
      --surface: #ffffff;
      --border: #e2e8f0;
      --text-main: #0f172a;
      --text-muted: #64748b;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      background-color: var(--bg);
      color: var(--text-main);
      display: flex;
      flex-direction: column;
      height: 100vh;
      overflow: hidden;
    }

    /* TOP BAR NAVEGACIÓN UNIVERSITARIA */
    header {
      background: var(--primary);
      color: #ffffff;
      padding: 12px 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 2px 10px rgba(0,0,0,0.15);
      z-index: 1100;
    }

    .brand-section {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .brand-icon {
      font-size: 1.8rem;
      background: rgba(255,255,255,0.12);
      width: 44px;
      height: 44px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 10px;
    }
    .brand-text h1 {
      font-size: 1.25rem;
      font-weight: 800;
      letter-spacing: -0.3px;
      color: #ffffff;
    }
    .brand-text p {
      font-size: 0.75rem;
      color: #93c5fd;
    }

    .postgis-tag {
      background: rgba(2, 132, 199, 0.25);
      border: 1px solid #38bdf8;
      color: #7dd3fc;
      font-size: 0.7rem;
      font-weight: 700;
      padding: 4px 10px;
      border-radius: 20px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    /* LAYOUT PRINCIPAL: PANEL IZQUIERDO + MAPA */
    .main-container {
      display: flex;
      flex: 1;
      height: calc(100vh - 68px);
      position: relative;
    }

    /* PANEL LATERAL DE ALOJAMIENTOS */
    .sidebar {
      width: 480px;
      min-width: 420px;
      background: var(--surface);
      border-right: 1px solid var(--border);
      display: flex;
      flex-direction: column;
      height: 100%;
      box-shadow: 2px 0 15px rgba(0,0,0,0.04);
      z-index: 1000;
    }

    /* BARRA DE FILTROS */
    .filter-bar {
      padding: 16px 20px;
      background: #ffffff;
      border-bottom: 1px solid var(--border);
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .filter-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .filter-title {
      font-size: 0.85rem;
      font-weight: 700;
      color: var(--primary);
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .radius-pills {
      display: flex;
      gap: 6px;
    }
    .radius-pill {
      border: 1px solid var(--border);
      background: #f1f5f9;
      color: var(--text-main);
      padding: 4px 10px;
      border-radius: 16px;
      font-size: 0.75rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
    }
    .radius-pill:hover, .radius-pill.active {
      background: var(--accent);
      color: #ffffff;
      border-color: var(--accent);
    }

    .slider-row {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .slider-labels {
      display: flex;
      justify-content: space-between;
      font-size: 0.75rem;
      color: var(--text-muted);
    }
    .slider-labels strong {
      color: var(--accent);
      font-size: 0.85rem;
    }
    input[type="range"] {
      width: 100%;
      accent-color: var(--accent);
      cursor: pointer;
    }

    .secondary-filters {
      display: flex;
      gap: 10px;
    }
    .form-group {
      flex: 1;
    }
    .form-group label {
      display: block;
      font-size: 0.72rem;
      color: var(--text-muted);
      margin-bottom: 4px;
      font-weight: 600;
    }
    .form-group select, .form-group input {
      width: 100%;
      padding: 7px 10px;
      border: 1px solid var(--border);
      border-radius: 8px;
      font-size: 0.8rem;
      background: #f8fafc;
      color: var(--text-main);
    }

    /* LISTADO DE RESULTADOS */
    .listing-header {
      padding: 12px 20px 8px;
      background: var(--bg);
      font-size: 0.8rem;
      font-weight: 700;
      color: var(--text-muted);
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid var(--border);
    }
    .listing-count {
      background: #e0f2fe;
      color: #0369a1;
      padding: 2px 8px;
      border-radius: 12px;
      font-weight: 800;
      font-size: 0.75rem;
    }

    .cards-scroll {
      flex: 1;
      overflow-y: auto;
      padding: 16px 20px;
      display: flex;
      flex-direction: column;
      gap: 14px;
      background: var(--bg);
    }

    /* TARJETA DE ALOJAMIENTO */
    .aloj-card {
      background: var(--surface);
      border-radius: 12px;
      border: 1px solid var(--border);
      padding: 16px;
      transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 1px 3px rgba(0,0,0,0.05);
      position: relative;
    }
    .aloj-card:hover {
      border-color: var(--accent);
      box-shadow: 0 8px 24px rgba(2, 132, 199, 0.12);
      transform: translateY(-2px);
    }

    .card-top {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 8px;
    }
    .card-title {
      font-size: 0.95rem;
      font-weight: 700;
      color: var(--primary);
      line-height: 1.3;
      flex: 1;
      padding-right: 10px;
    }
    .card-price {
      text-align: right;
    }
    .card-price .amount {
      font-size: 1.15rem;
      font-weight: 800;
      color: var(--success);
    }
    .card-price .period {
      font-size: 0.7rem;
      color: var(--text-muted);
      display: block;
    }

    .card-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      margin-bottom: 10px;
    }
    .tag {
      font-size: 0.7rem;
      font-weight: 600;
      padding: 3px 8px;
      border-radius: 6px;
      background: #f1f5f9;
      color: #475569;
    }
    .tag-distance {
      background: #e0f2fe;
      color: #0369a1;
      font-weight: 700;
    }
    .tag-free {
      background: #dcfce7;
      color: #15803d;
      font-weight: 700;
    }

    .card-address {
      font-size: 0.78rem;
      color: var(--text-muted);
      margin-bottom: 12px;
      display: flex;
      align-items: center;
      gap: 4px;
    }

    /* BOTÓN CONVIVENCIA */
    .card-actions {
      display: flex;
      gap: 8px;
      border-top: 1px solid #f1f5f9;
      padding-top: 10px;
    }
    .btn-roommates {
      flex: 1;
      background: #f8fafc;
      border: 1px solid var(--border);
      color: var(--primary);
      padding: 7px 12px;
      border-radius: 8px;
      font-size: 0.76rem;
      font-weight: 600;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      transition: all 0.2s;
    }
    .btn-roommates:hover {
      background: #f0f9ff;
      border-color: var(--accent);
      color: var(--accent);
    }
    .btn-locate {
      background: #f8fafc;
      border: 1px solid var(--border);
      color: var(--text-muted);
      padding: 7px 12px;
      border-radius: 8px;
      font-size: 0.76rem;
      cursor: pointer;
      transition: all 0.2s;
    }
    .btn-locate:hover {
      background: #f1f5f9;
      color: var(--text-main);
    }

    /* EL MAPA */
    #map {
      flex: 1;
      height: 100%;
      background: #e5e7eb;
    }

    /* MARCADORES PERSONALIZADOS EN MAPA */
    .pin-accommodation {
      background: #ffffff;
      color: var(--primary);
      font-weight: 800;
      font-size: 0.72rem;
      padding: 4px 8px;
      border-radius: 20px;
      border: 2px solid var(--accent);
      box-shadow: 0 3px 12px rgba(0,0,0,0.2);
      text-align: center;
      white-space: nowrap;
      transition: all 0.2s;
      cursor: pointer;
    }
    .pin-accommodation:hover, .pin-accommodation.active {
      background: var(--primary);
      color: #ffffff;
      border-color: #38bdf8;
      transform: scale(1.15);
      z-index: 1000 !important;
    }
    .pin-campus {
      background: #ef4444;
      color: #ffffff;
      font-size: 1.2rem;
      width: 40px;
      height: 40px;
      border-radius: 50%;
      border: 3px solid #ffffff;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 0 18px rgba(239,68,68,0.7);
    }

    /* MODAL DE COMPAÑEROS Y CONVIVENCIA */
    .modal-overlay {
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(15, 23, 42, 0.6);
      backdrop-filter: blur(4px);
      display: none;
      align-items: center;
      justify-content: center;
      z-index: 2000;
    }
    .modal-box {
      background: #ffffff;
      width: 90%;
      max-width: 600px;
      border-radius: 16px;
      box-shadow: 0 20px 40px rgba(0,0,0,0.25);
      overflow: hidden;
      display: flex;
      flex-direction: column;
      max-height: 85vh;
      animation: modalIn 0.25s ease-out;
    }
    @keyframes modalIn {
      from { opacity: 0; transform: scale(0.95); }
      to { opacity: 1; transform: scale(1); }
    }
    .modal-header {
      background: var(--primary);
      color: #ffffff;
      padding: 16px 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .modal-header h2 {
      font-size: 1.05rem;
      font-weight: 700;
    }
    .modal-close {
      background: none;
      border: none;
      color: #94a3b8;
      font-size: 1.5rem;
      cursor: pointer;
    }
    .modal-close:hover { color: #ffffff; }

    .modal-body {
      padding: 20px 24px;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      gap: 14px;
    }
    .landlord-info {
      background: #f8fafc;
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 12px 16px;
      font-size: 0.8rem;
    }
    .landlord-info strong { color: var(--primary); }

    .roommate-card {
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 12px 14px;
      background: #ffffff;
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .roommate-card.available {
      background: #f0fdf4;
      border-color: #86efac;
    }
    .roommate-card-header {
      display: flex;
      justify-content: space-between;
      font-size: 0.85rem;
    }
    .roommate-card-header strong {
      color: var(--primary);
    }
    .status-badge {
      font-size: 0.7rem;
      font-weight: 700;
      padding: 2px 7px;
      border-radius: 6px;
    }
    .status-badge.occupied { background: #fee2e2; color: #991b1b; }
    .status-badge.free { background: #dcfce7; color: #166534; }

    .roommate-career {
      font-size: 0.75rem;
      color: var(--accent);
      font-weight: 600;
    }
    .roommate-quote {
      font-size: 0.78rem;
      color: #475569;
      font-style: italic;
      line-height: 1.4;
      background: #f8fafc;
      padding: 8px 10px;
      border-radius: 6px;
      border-left: 3px solid var(--accent);
    }
  </style>
</head>
<body>

  <!-- HEADER NAVEGACIÓN -->
  <header>
    <div class="brand-section">
      <div class="brand-icon">🎓</div>
      <div class="brand-text">
        <h1>Loyola Living</h1>
        <p>Portal Geoespacial de Alojamiento Estudiantil · Universidad Loyola</p>
      </div>
    </div>
    <div class="postgis-tag">PostGIS WGS 84 · ST_DWithin</div>
  </header>

  <!-- CONTENEDOR PRINCIPAL -->
  <div class="main-container">
    
    <!-- PANEL LATERAL -->
    <div class="sidebar">
      
      <!-- FILTROS -->
      <div class="filter-bar">
        <div class="filter-header">
          <span class="filter-title">📍 Radio desde Campus Loyola</span>
          <div class="radius-pills">
            <span class="radius-pill" onclick="setRadius(1000)">1 km</span>
            <span class="radius-pill" onclick="setRadius(2000)">2 km</span>
            <span class="radius-pill active" id="pill3km" onclick="setRadius(3000)">3 km</span>
            <span class="radius-pill" onclick="setRadius(5000)">5 km</span>
          </div>
        </div>

        <div class="slider-row">
          <div class="slider-labels">
            <span>Ajuste fino (PostGIS):</span>
            <strong id="labelRadius">3.0 km (3.000 m)</strong>
          </div>
          <input type="range" id="sliderRadius" min="500" max="5000" step="100" value="3000" oninput="onSliderChange(this.value)" />
        </div>

        <div class="secondary-filters">
          <div class="form-group">
            <label>Tipo de Vivienda</label>
            <select id="filterTipo" onchange="applyFilters()">
              <option value="Todos">Todos los tipos</option>
              <option value="Piso Compartido">Piso Compartido</option>
              <option value="Residencia Universitaria">Residencia Universitaria</option>
              <option value="Chalet Adosado">Chalet Adosado</option>
              <option value="Estudio / Ático">Estudio / Ático</option>
            </select>
          </div>
          <div class="form-group">
            <label>Presupuesto Máximo</label>
            <select id="filterPrecio" onchange="applyFilters()">
              <option value="9999">Cualquier precio</option>
              <option value="300">Hasta 300 €/mes</option>
              <option value="400">Hasta 400 €/mes</option>
              <option value="500">Hasta 500 €/mes</option>
            </select>
          </div>
        </div>
      </div>

      <!-- LISTADO DE TARJETAS -->
      <div class="listing-header">
        <span>OFERTAS EN ZONA DE INFLUENCIA</span>
        <span class="listing-count" id="badgeCount">0 alojamientos</span>
      </div>

      <div class="cards-scroll" id="cardsContainer"></div>
    </div>

    <!-- MAPA LEAFLET -->
    <div id="map"></div>
  </div>

  <!-- MODAL DE CONVIVENCIA Y COMPAÑEROS -->
  <div class="modal-overlay" id="roommateModal" onclick="closeModalOnBg(event)">
    <div class="modal-box">
      <div class="modal-header">
        <div>
          <h2 id="modalTitle">Perfil de Convivencia</h2>
          <span style="font-size:0.75rem; color:#93c5fd;" id="modalSubtitle">-</span>
        </div>
        <button class="modal-close" onclick="closeModal()">&times;</button>
      </div>
      <div class="modal-body" id="modalBody"></div>
    </div>
  </div>

  <script>
    // 1. DATASET DE LOS 20 ALOJAMIENTOS REALES (EMBEBIDO)
    const alojamientos = DATASET_PLACEHOLDER;

    // 2. COORDENADAS OFICIALES CAMPUS LOYOLA (DOS HERMANAS)
    const LOYOLA_LAT = 37.3069;
    const LOYOLA_LON = -5.9418;
    let currentCenter = [LOYOLA_LAT, LOYOLA_LON];
    let currentRadius = 3000;

    // 3. INICIALIZACIÓN DEL MAPA CON OPENSTREETMAP (100% LIBRE Y SIN API KEY)
    const map = L.map('map').setView(currentCenter, 14);

    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    // 4. MARCADOR DEL CAMPUS DE LOYOLA (CHINCHETA ACADÉMICA ROJA)
    const campusIcon = L.divIcon({
      className: 'pin-campus',
      html: '🎓',
      iconSize: [42, 42],
      iconAnchor: [21, 21]
    });
    const campusMarker = L.marker(currentCenter, {
      icon: campusIcon,
      draggable: true
    }).addTo(map);
    campusMarker.bindPopup('<strong>Campus Universidad Loyola Andalucía</strong><br>Av. de las Universidades, 2 (Dos Hermanas)<br><em>Arrastra el icono para recalcular distancias</em>');

    // 5. CÍRCULO GEOESPACIAL (ST_DWithin)
    const radiusCircle = L.circle(currentCenter, {
      radius: currentRadius,
      color: '#0284c7',
      fillColor: '#0284c7',
      fillOpacity: 0.10,
      weight: 2,
      dashArray: '6, 8'
    }).addTo(map);

    // 6. POLÍGONOS DE COBERTURA DE TRANSPORTE Y BARRIOS (ST_Contains)
    const poligonosBarrios = [
      {
        nombre: 'Entrenúcleos (Área Campus)',
        color: '#059669',
        coords: [[37.3000, -5.9550], [37.3000, -5.9300], [37.3280, -5.9300], [37.3280, -5.9550]]
      },
      {
        nombre: 'Montequinto (Zona Metro L1)',
        color: '#7c3aed',
        coords: [[37.3300, -5.9450], [37.3300, -5.9150], [37.3600, -5.9150], [37.3600, -5.9450]]
      },
      {
        nombre: 'Bellavista (Lanzadera Sur)',
        color: '#d97706',
        coords: [[37.3200, -5.9850], [37.3200, -5.9600], [37.3480, -5.9600], [37.3480, -5.9850]]
      }
    ];

    poligonosBarrios.forEach(b => {
      L.polygon(b.coords, {
        color: b.color,
        fillColor: b.color,
        fillOpacity: 0.08,
        weight: 1.5
      }).addTo(map).bindPopup('<strong>Zona de Transporte: ' + b.nombre + '</strong><br>Polígono espacial analizado con PostGIS');
    });

    // 7. CÁLCULO DE DISTANCIA HAVERSINE (DISTANCIA EN METROS)
    function getDistanceMeters(lat1, lon1, lat2, lon2) {
      const R = 6371000;
      const dLat = (lat2 - lat1) * Math.PI / 180;
      const dLon = (lon2 - lon1) * Math.PI / 180;
      const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
                Math.sin(dLon/2) * Math.sin(dLon/2);
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
      return Math.round(R * c);
    }

    // 8. CREACIÓN DE MARCADORES EN EL MAPA
    const markersMap = new Map();

    alojamientos.forEach(item => {
      const pinIcon = L.divIcon({
        className: 'pin-accommodation',
        html: `<strong>${item.precio_mes}€</strong>`,
        iconSize: [52, 26],
        iconAnchor: [26, 13]
      });

      const marker = L.marker([item.lat, item.lon], { icon: pinIcon }).addTo(map);

      marker.bindPopup(`
        <div style="font-size:12px; line-height:1.4;">
          <strong style="font-size:14px; color:#0a2540;">${item.titulo}</strong><br>
          <span style="color:#0284c7; font-weight:700;">${item.tipo}</span> · <em>${item.barrio}</em><br>
          📍 ${item.direccion}<br>
          💰 <strong>${item.precio_mes} €/mes</strong> | 🛏️ ${item.habitaciones_libres} libres<br>
          <button onclick="openModalById(${item.id})" style="margin-top:8px; width:100%; padding:6px; background:#0284c7; color:#fff; border:none; border-radius:6px; font-weight:600; cursor:pointer;">
            Ver compañeros y convivencia
          </button>
        </div>
      `);

      markersMap.set(item.id, marker);
    });

    // 9. FUNCIÓN DE RENDERIZADO Y FILTRO ESPACIAL
    function applyFilters() {
      const tipoSelected = document.getElementById('filterTipo').value;
      const maxPrecio = parseFloat(document.getElementById('filterPrecio').value);
      const container = document.getElementById('cardsContainer');
      container.innerHTML = '';

      let matches = [];

      alojamientos.forEach(item => {
        const dist = getDistanceMeters(currentCenter[0], currentCenter[1], item.lat, item.lon);
        const inRadius = dist <= currentRadius;
        const matchesTipo = (tipoSelected === 'Todos') || (item.tipo === tipoSelected);
        const matchesPrecio = item.precio_mes <= maxPrecio;

        const marker = markersMap.get(item.id);

        if (inRadius && matchesTipo && matchesPrecio) {
          matches.push({ ...item, distance: dist });
          if (marker) {
            marker.setOpacity(1.0);
            marker.getElement()?.classList.remove('dimmed');
          }
        } else {
          if (marker) {
            marker.setOpacity(0.25);
            marker.getElement()?.classList.add('dimmed');
          }
        }
      });

      // Ordenar del más cercano al más lejano (ORDER BY distancia ASC)
      matches.sort((a, b) => a.distance - b.distance);

      document.getElementById('badgeCount').innerText = `${matches.length} alojamientos`;

      if (matches.length === 0) {
        container.innerHTML = `
          <div style="text-align:center; padding:30px 10px; color:#64748b; font-size:0.85rem;">
            No se han encontrado alojamientos a menos de ${(currentRadius/1000).toFixed(1)} km con estos filtros.<br><br>
            <em>Prueba a ampliar el radio o aumentar el presupuesto.</em>
          </div>
        `;
        return;
      }

      matches.forEach(item => {
        const card = document.createElement('div');
        card.className = 'aloj-card';
        card.id = `card-${item.id}`;

        const distText = item.distance < 1000 ? `${item.distance} m` : `${(item.distance/1000).toFixed(2)} km`;

        card.innerHTML = `
          <div class="card-top">
            <h3 class="card-title">${item.titulo}</h3>
            <div class="card-price">
              <span class="amount">${item.precio_mes}€</span>
              <span class="period">al mes</span>
            </div>
          </div>
          <div class="card-tags">
            <span class="tag tag-distance">🚶 a ${distText} de Loyola</span>
            <span class="tag tag-free">🛏️ ${item.habitaciones_libres} habs libres</span>
            <span class="tag">${item.tipo}</span>
            <span class="tag">${item.barrio}</span>
          </div>
          <div class="card-address">
            📍 ${item.direccion}
          </div>
          <div class="card-actions">
            <button class="btn-roommates" onclick="openModalById(${item.id})">
              👥 Convivencia & Compañeros
            </button>
            <button class="btn-locate" onclick="focusOnMap(${item.id}, ${item.lat}, ${item.lon})">
              Ver mapa
            </button>
          </div>
        `;

        container.appendChild(card);
      });
    }

    // 10. INTERACCIÓN CON EL MAPA Y CENTRADO
    function focusOnMap(id, lat, lon) {
      map.flyTo([lat, lon], 16, { animate: true, duration: 0.8 });
      const marker = markersMap.get(id);
      if (marker) {
        marker.openPopup();
      }
    }

    // 11. CONTROLES DE RADIO (PILLS Y SLIDER)
    function setRadius(m) {
      document.querySelectorAll('.radius-pill').forEach(p => p.classList.remove('active'));
      currentRadius = m;
      document.getElementById('sliderRadius').value = m;
      updateRadiusVisuals();
    }

    function onSliderChange(val) {
      document.querySelectorAll('.radius-pill').forEach(p => p.classList.remove('active'));
      currentRadius = parseInt(val);
      updateRadiusVisuals();
    }

    function updateRadiusVisuals() {
      const km = (currentRadius / 1000).toFixed(1);
      document.getElementById('labelRadius').innerText = `${km} km (${currentRadius.toLocaleString()} m)`;
      radiusCircle.setRadius(currentRadius);
      applyFilters();
    }

    // 12. EVENTOS DE ARRASTRE Y CLIC EN EL MAPA
    campusMarker.on('drag', function(e) {
      const pos = e.target.getLatLng();
      currentCenter = [pos.lat, pos.lng];
      radiusCircle.setLatLng(currentCenter);
      applyFilters();
    });

    map.on('click', function(e) {
      currentCenter = [e.latlng.lat, e.latlng.lng];
      campusMarker.setLatLng(currentCenter);
      radiusCircle.setLatLng(currentCenter);
      applyFilters();
    });

    // 13. MODAL DE CONVIVENCIA Y COMPAÑEROS
    function openModalById(id) {
      const item = alojamientos.find(a => a.id === id);
      if (!item) return;

      document.getElementById('modalTitle').innerText = item.titulo;
      document.getElementById('modalSubtitle').innerText = `${item.direccion} · ${item.barrio}`;

      const body = document.getElementById('modalBody');
      body.innerHTML = `
        <div class="landlord-info">
          <strong>👤 Casero:</strong> ${item.nombre_casero} (${item.contacto_casero})<br>
          <em>"${item.biografia_casero}"</em>
        </div>
        <h4 style="font-size:0.85rem; color:#0a2540; margin-top:6px;">Habitaciones y Estudiantes Actuales:</h4>
      `;

      item.habitaciones.forEach(h => {
        const isFree = h.estado === 'Disponible';
        const card = document.createElement('div');
        card.className = `roommate-card ${isFree ? 'available' : ''}`;

        if (isFree) {
          card.innerHTML = `
            <div class="roommate-card-header">
              <strong>Habitación ${h.numero}</strong>
              <span class="status-badge free">✨ DISPONIBLE</span>
            </div>
            <div style="font-size:0.8rem; font-weight:700; color:#15803d;">
              Precio: ${h.precio} €/mes
            </div>
            <div class="roommate-quote" style="border-left-color:#10b981;">
              "${h.biografia}"
            </div>
          `;
        } else {
          card.innerHTML = `
            <div class="roommate-card-header">
              <strong>Habitación ${h.numero}: ${h.inquilino}</strong>
              <span class="status-badge occupied">OCUPADA</span>
            </div>
            <div class="roommate-career">
              🎓 ${h.grado} (${h.curso}º curso)
            </div>
            <div class="roommate-quote">
              "${h.biografia}"
            </div>
          `;
        }

        body.appendChild(card);
      });

      document.getElementById('roommateModal').style.display = 'flex';
    }

    function closeModal() {
      document.getElementById('roommateModal').style.display = 'none';
    }

    function closeModalOnBg(e) {
      if (e.target.id === 'roommateModal') closeModal();
    }

    // Inicialización al cargar la página
    applyFilters();
  </script>
</body>
</html>
'@

$finalHtml = $htmlContent.Replace("DATASET_PLACEHOLDER", $jsonData)
Set-Content -Path $htmlPath -Value $finalHtml -Encoding UTF8

Write-Host "¡Nueva interfaz creada con OpenStreetMap y diseño único!" -ForegroundColor Green
