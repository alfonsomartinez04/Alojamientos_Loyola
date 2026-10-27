-- ====================================================================
-- CONSULTAS GEOESPACIALES CLAVE PARA LA MEMORIA Y DEFENSA DEL TPI 1
-- ====================================================================

-- --------------------------------------------------------------------
-- CONSULTA 1: BÚSQUEDA POR RADIO DE CERCANÍA (ST_DWithin + ST_Distance)
-- Objetivo: Hallar todos los alojamientos a menos de 3.000 metros (3 km)
-- del Campus de la Universidad Loyola, ordenados del más cercano al más lejano.
-- --------------------------------------------------------------------
SELECT 
    a.id,
    a.titulo,
    a.tipo,
    a.precio_mes,
    a.habitaciones_libres,
    -- ST_Distance calcula la distancia esferoidal exacta en metros
    ROUND(ST_Distance(a.geom::geography, c.geom::geography)::numeric, 1) AS distancia_metros,
    a.nombre_casero,
    a.contacto_casero
FROM alojamientos a
CROSS JOIN campus_universitario c
WHERE c.nombre LIKE '%Loyola%'
  -- ST_DWithin usa el índice GiST para descartar alojamientos fuera del radio de 3 km al instante
  AND ST_DWithin(a.geom::geography, c.geom::geography, 3000)
ORDER BY distancia_metros ASC;


-- --------------------------------------------------------------------
-- CONSULTA 2: CONTENCIÓN EN POLÍGONO DE BARRIO / TRANSPORTE (ST_Contains)
-- Objetivo: Encontrar qué alojamientos caen exactamente dentro de la
-- zona universitaria de 'Montequinto' (conectada con Metro y Bus lanzadera).
-- --------------------------------------------------------------------
SELECT 
    a.id,
    a.titulo,
    a.direccion,
    a.precio_mes,
    z.nombre_barrio,
    z.transporte_directo,
    z.tiempo_estimado_min
FROM alojamientos a
JOIN zonas_cobertura z 
  -- ST_Contains evalúa si el punto GPS del piso está dentro del polígono del barrio
  ON ST_Contains(z.geom, a.geom)
WHERE z.nombre_barrio = 'Montequinto'
ORDER BY a.precio_mes ASC;


-- --------------------------------------------------------------------
-- CONSULTA 3: LA CONSULTA ESTRELLA (Cercanía + Presupuesto + Convivencia)
-- Objetivo: Un estudiante de Loyola busca piso a menos de 3.5 km, con precio
-- menor a 360 €/mes, con al menos 1 habitación libre, y solicita ver
-- el perfil y biografía de los compañeros con los que va a convivir.
-- --------------------------------------------------------------------
SELECT 
    a.titulo AS piso,
    a.tipo,
    ROUND(ST_Distance(a.geom::geography, c.geom::geography)::numeric, 0) AS distancia_a_loyola_m,
    h.numero_habitacion,
    h.estado AS estado_habitacion,
    h.precio_habitacion,
    COALESCE(h.nombre_estudiante, '--- HABITACIÓN LIBRE ---') AS companero,
    COALESCE(h.grado, 'Disponible para ti') AS carrera_companero,
    h.biografia_convivencia
FROM alojamientos a
CROSS JOIN campus_universitario c
JOIN habitaciones_convivencia h ON a.id = h.alojamiento_id
WHERE c.nombre LIKE '%Loyola%'
  AND ST_DWithin(a.geom::geography, c.geom::geography, 3500)
  AND a.habitaciones_libres > 0
  AND h.precio_habitacion <= 360.00
ORDER BY distancia_a_loyola_m ASC, a.id, h.numero_habitacion;


-- --------------------------------------------------------------------
-- CONSULTA 4: DEMOSTRACIÓN TÉCNICA PARA LA DEFENSA (EXPLAIN ANALYZE)
-- Objetivo: Demostrarle al profesor que PostGIS utiliza el índice GiST
-- (Index Scan) en lugar de un escaneo secuencial (Seq Scan).
-- --------------------------------------------------------------------
EXPLAIN ANALYZE
SELECT a.id, a.titulo
FROM alojamientos a
CROSS JOIN campus_universitario c
WHERE ST_DWithin(a.geom::geography, c.geom::geography, 3000);
