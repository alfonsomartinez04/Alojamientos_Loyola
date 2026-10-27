
-- -----------------------------------------------------------------------------
-- CONSULTA 1: Búsqueda Inmediata por Radio de Cercanía (ST_DWithin + ST_Distance)
-- Objetivo: Hallar todos los alojamientos a menos de 2.000 metros (2 km)
-- del Campus de la Universidad Loyola, ordenados del más cercano al más lejano.
-- Técnica: ST_DWithin sobre índice funcional GiST geodésico (cálculo en metros).
-- -----------------------------------------------------------------------------
SELECT 
    a.id,
    a.titulo,
    a.tipo,
    a.barrio,
    a.precio_mes AS "Precio (€/mes)",
    a.habitaciones_libres AS "Hab. Libres",
    ROUND(
        ST_Distance(
            a.geom::geography, 
            c.geom::geography
        )::numeric, 
        1
    ) AS "Distancia a Loyola (m)"
FROM alojamientos a
CROSS JOIN campus_universitario c
WHERE c.nombre LIKE '%Loyola%'
  AND ST_DWithin(a.geom::geography, c.geom::geography, 2000)
ORDER BY "Distancia a Loyola (m)" ASC;


-- -----------------------------------------------------------------------------
-- CONSULTA 2: Ranking Top 5 Alojamientos Más Económicos a menos de 3.5 km
-- Objetivo: Un alumno que busca el precio más bajo posible sin alejarse demasiado.
-- Técnica: Combinación de filtro espacial geodésico con ordenación por coste B-Tree.
-- -----------------------------------------------------------------------------
SELECT 
    a.id,
    a.titulo,
    a.tipo,
    a.direccion,
    a.precio_mes AS "Precio (€/mes)",
    a.habitaciones_libres AS "Hab. Libres",
    ROUND(
        ST_Distance(a.geom::geography, c.geom::geography)::numeric, 
        1
    ) AS "Distancia (m)"
FROM alojamientos a
CROSS JOIN campus_universitario c
WHERE c.nombre LIKE '%Loyola%'
  AND ST_DWithin(a.geom::geography, c.geom::geography, 3500)
  AND a.habitaciones_libres > 0
ORDER BY a.precio_mes ASC, "Distancia (m)" ASC
LIMIT 5;


-- -----------------------------------------------------------------------------
-- CONSULTA 3: Contención Espacial en Polígono de Transporte (ST_Contains)
-- Objetivo: Encontrar qué alojamientos caen estrictamente dentro del polígono
-- del barrio de 'Montequinto' (conectado por Metro Línea 1 y Bus lanzadera).
-- Técnica: ST_Contains sobre geometrías 2D utilizando el índice GiST.
-- -----------------------------------------------------------------------------
SELECT 
    a.id,
    a.titulo,
    a.tipo,
    a.direccion,
    a.precio_mes AS "Precio (€/mes)",
    z.nombre_barrio AS "Barrio Cobertura",
    z.transporte_directo AS "Conexión Transporte",
    z.tiempo_estimado_min AS "Tiempo Estimado (min)"
FROM alojamientos a
JOIN zonas_cobertura z 
  ON ST_Contains(z.geom, a.geom)
WHERE z.nombre_barrio LIKE '%Montequinto%'
ORDER BY a.precio_mes ASC;


-- -----------------------------------------------------------------------------
-- CONSULTA 4: La Consulta Estrella - Convivencia y Perfil de Compañeros
-- Objetivo: Filtrar pisos a menos de 3.000m de Loyola con precio <= 360€/mes,
-- y obtener la biografía de los compañeros que ya conviven en las habitaciones ocupadas.
-- -----------------------------------------------------------------------------
SELECT 
    a.titulo AS "Piso",
    ROUND(ST_Distance(a.geom::geography, c.geom::geography)::numeric, 0) AS "Distancia Loyola (m)",
    h.numero_habitacion AS "Hab.",
    h.estado AS "Estado",
    h.precio_habitacion AS "Precio Hab (€)",
    COALESCE(h.nombre_estudiante, '--- DISPONIBLE ---') AS "Compañero",
    COALESCE(h.grado, '-') AS "Grado Universitario",
    h.biografia_convivencia AS "Perfil Convivencia"
FROM alojamientos a
CROSS JOIN campus_universitario c
JOIN habitaciones_convivencia h ON a.id = h.alojamiento_id
WHERE c.nombre LIKE '%Loyola%'
  AND ST_DWithin(a.geom::geography, c.geom::geography, 3000)
  AND a.habitaciones_libres > 0
  AND h.precio_habitacion <= 360.00
ORDER BY "Distancia Loyola (m)" ASC, a.id, h.numero_habitacion;


-- -----------------------------------------------------------------------------
-- CONSULTA 5: Estadísticas Espaciales de Mercado por Zona (Agregación Espacial)
-- Objetivo: Analizar el precio medio, mínimo y máximo según la zona de cobertura.
-- -----------------------------------------------------------------------------
SELECT 
    z.nombre_barrio AS "Zona Universitaria",
    COUNT(a.id) AS "Total Ofertas",
    SUM(a.habitaciones_libres) AS "Habitaciones Libres",
    MIN(a.precio_mes) AS "Precio Mínimo (€)",
    ROUND(AVG(a.precio_mes), 2) AS "Precio Medio (€)",
    MAX(a.precio_mes) AS "Precio Máximo (€)"
FROM zonas_cobertura z
LEFT JOIN alojamientos a ON ST_Contains(z.geom, a.geom)
GROUP BY z.id, z.nombre_barrio
ORDER BY "Precio Medio (€)" ASC;


-- -----------------------------------------------------------------------------
-- CONSULTA 6: Exportación GeoJSON para Integración en Mapa Web (Leaflet / QGIS)
-- Objetivo: Demostrar interoperabilidad cartográfica devolviendo una FeatureCollection.
-- -----------------------------------------------------------------------------
SELECT 
    json_build_object(
        'type', 'FeatureCollection',
        'features', json_agg(
            json_build_object(
                'type', 'Feature',
                'geometry', ST_AsGeoJSON(a.geom)::json,
                'properties', json_build_object(
                    'id', a.id,
                    'titulo', a.titulo,
                    'tipo', a.tipo,
                    'barrio', a.barrio,
                    'precio_mes', a.precio_mes,
                    'habitaciones_libres', a.habitaciones_libres,
                    'contacto', a.contacto_casero
                )
            )
        )
    ) AS geojson_dataset
FROM alojamientos a;


-- -----------------------------------------------------------------------------
-- CONSULTA 7: Demostración del Plan de Ejecución (EXPLAIN ANALYZE)
-- Objetivo: Justificar técnicamente ante el profesor el uso del índice espacial GiST
-- funcional frente a un escaneo secuencial (Full Table Scan).
-- -----------------------------------------------------------------------------
EXPLAIN ANALYZE
SELECT 
    a.id, 
    a.titulo, 
    a.precio_mes,
    ROUND(ST_Distance(a.geom::geography, c.geom::geography)::numeric, 1) AS dist_m
FROM alojamientos a
CROSS JOIN campus_universitario c
WHERE c.nombre LIKE '%Loyola%'
  AND ST_DWithin(a.geom::geography, c.geom::geography, 2500)
ORDER BY a.precio_mes ASC;
