-- ====================================================================
-- TPI 1: SISTEMA GEOESPACIAL DE ALOJAMIENTOS - UNIVERSIDAD LOYOLA
-- Asignatura: Ampliación de Bases de Datos (3º Grado Ing. Software)
-- Tecnología: PostgreSQL 16 + Extensión PostGIS 3.4
-- ====================================================================

-- 1. Habilitamos la extensión PostGIS en la base de datos
CREATE EXTENSION IF NOT EXISTS postgis;

-- --------------------------------------------------------------------
-- 2. TABLA DE CAMPUS UNIVERSITARIO (Puntos GPS de Referencia)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS campus_universitario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    direccion VARCHAR(150),
    geom GEOMETRY(Point, 4326) NOT NULL -- SRID 4326: Coordenadas GPS mundiales (WGS 84)
);

-- --------------------------------------------------------------------
-- 3. TABLA DE ZONAS Y BARRIOS DE COBERTURA (Polígonos)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS zonas_cobertura (
    id SERIAL PRIMARY KEY,
    nombre_barrio VARCHAR(100) NOT NULL,
    transporte_directo VARCHAR(100), -- ej. 'Línea 1 Metro + Bus', 'Lanzadera Loyola'
    tiempo_estimado_min INT,
    geom GEOMETRY(Polygon, 4326) NOT NULL -- Polígonos que delimitan el perímetro del barrio
);

-- --------------------------------------------------------------------
-- 4. TABLA DE ALOJAMIENTOS (Pisos y Residencias con Puntos GPS)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS alojamientos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    tipo VARCHAR(40) NOT NULL CHECK (tipo IN ('Piso Compartido', 'Residencia Universitaria')),
    direccion VARCHAR(150) NOT NULL,
    precio_mes NUMERIC(7,2) NOT NULL,
    habitaciones_totales INT NOT NULL,
    habitaciones_libres INT NOT NULL,
    nombre_casero VARCHAR(80),
    contacto_casero VARCHAR(80),
    biografia_casero TEXT,
    geom GEOMETRY(Point, 4326) NOT NULL -- Coordenada GPS exacta del portal del alojamiento
);

-- ÍNDICE ESPACIAL GIST:
-- Este índice es el núcleo técnico evaluado en el TPI 1.
-- Permite búsquedas por proximidad y zonas en milisegundos evitando el Full Table Scan.
CREATE INDEX idx_alojamientos_geom ON alojamientos USING GIST(geom);
CREATE INDEX idx_zonas_geom ON zonas_cobertura USING GIST(geom);

-- --------------------------------------------------------------------
-- 5. TABLA DE CONVIVENCIA Y HABITACIONES (La funcionalidad diferencial)
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS habitaciones_convivencia (
    id SERIAL PRIMARY KEY,
    alojamiento_id INT NOT NULL REFERENCES alojamientos(id) ON DELETE CASCADE,
    numero_habitacion INT NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Disponible', 'Ocupada')),
    precio_habitacion NUMERIC(6,2) NOT NULL,
    nombre_estudiante VARCHAR(80), -- NULL si está disponible
    grado VARCHAR(80),             -- NULL si está disponible
    curso INT,                     -- NULL si está disponible
    biografia_convivencia TEXT     -- Descripción de personalidad, rutinas y estilo de vida
);

-- ====================================================================
-- CARGA DE DATOS DE PRUEBA REALES (ÁREA METROPOLITANA SEVILLA - DOS HERMANAS)
-- ====================================================================

-- 1. Insertamos el Campus de Loyola (Avenida de las Universidades s/n)
-- Coordenadas: Longitud -5.932800, Latitud 37.319700
INSERT INTO campus_universitario (nombre, ciudad, direccion, geom)
VALUES (
    'Universidad Loyola Andalucía - Campus Sevilla',
    'Dos Hermanas',
    'Avenida de las Universidades, s/n, 41704 Dos Hermanas',
    ST_SetSRID(ST_MakePoint(-5.932800, 37.319700), 4326)
);

-- 2. Insertamos Polígonos de Zonas de Estudiantes
-- Zona A: Entrenúcleos (Área contigua al campus, distancia a pie)
INSERT INTO zonas_cobertura (nombre_barrio, transporte_directo, tiempo_estimado_min, geom)
VALUES (
    'Entrenúcleos - Campus Direct',
    'Carril bici / A pie / Bus urbano',
    5,
    ST_SetSRID(ST_GeomFromText('POLYGON((
        -5.9400 37.3150,
        -5.9250 37.3150,
        -5.9250 37.3300,
        -5.9400 37.3300,
        -5.9400 37.3150
    ))'), 4326)
);

-- Zona B: Montequinto (Barrio universitario tradicional, Línea 1 de Metro)
INSERT INTO zonas_cobertura (nombre_barrio, transporte_directo, tiempo_estimado_min, geom)
VALUES (
    'Montequinto',
    'Línea 1 Metro + Bus Lanzadera Loyola',
    12,
    ST_SetSRID(ST_GeomFromText('POLYGON((
        -5.9420 37.3400,
        -5.9180 37.3400,
        -5.9180 37.3620,
        -5.9420 37.3620,
        -5.9420 37.3400
    ))'), 4326)
);

-- Zona C: Bellavista - Los Bermejales (Sevilla Sur)
INSERT INTO zonas_cobertura (nombre_barrio, transporte_directo, tiempo_estimado_min, geom)
VALUES (
    'Bellavista - Bermejales',
    'Lanzadera interurbana Loyola / Tren C1 Cercanías',
    15,
    ST_SetSRID(ST_GeomFromText('POLYGON((
        -5.9850 37.3300,
        -5.9650 37.3300,
        -5.9650 37.3550,
        -5.9850 37.3550,
        -5.9850 37.3300
    ))'), 4326)
);

-- 3. Insertamos Alojamientos con distintas distancias al campus
-- Alojamiento 1: Muy cerca (Entrenúcleos, a ~650m)
INSERT INTO alojamientos (titulo, tipo, direccion, precio_mes, habitaciones_totales, habitaciones_libres, nombre_casero, contacto_casero, biografia_casero, geom)
VALUES (
    'Piso Moderno en Av. Plácido Fernández Viagas',
    'Piso Compartido',
    'Av. Plácido Fernández Viagas, 12, Entrenúcleos',
    350.00, 3, 1,
    'Carmen Domínguez', 'carmen.d@alojaloyola.es',
    'Casera atenta. Exalumna de Loyola, tengo el piso acondicionado para estudio y wifi de alta velocidad.',
    ST_SetSRID(ST_MakePoint(-5.935500, 37.324200), 4326)
);

-- Alojamiento 2: Residencia Universitaria cerca (Entrenúcleos, a ~1.1 km)
INSERT INTO alojamientos (titulo, tipo, direccion, precio_mes, habitaciones_totales, habitaciones_libres, nombre_casero, contacto_casero, biografia_casero, geom)
VALUES (
    'Residencia Loyola Campus Living',
    'Residencia Universitaria',
    'Calle José Rodríguez de la Borbolla, 5, Entrenúcleos',
    650.00, 40, 6,
    'Gerencia Campus Living', 'info@campusliving.es',
    'Residencia oficial concertada con pensión completa, gimnasio y salas de estudio 24h.',
    ST_SetSRID(ST_MakePoint(-5.938500, 37.328000), 4326)
);

-- Alojamiento 3: Montequinto centro (a ~3.2 km, junto a parada de Metro)
INSERT INTO alojamientos (titulo, tipo, direccion, precio_mes, habitaciones_totales, habitaciones_libres, nombre_casero, contacto_casero, biografia_casero, geom)
VALUES (
    'Piso Luminoso junto a Metro Europa (Montequinto)',
    'Piso Compartido',
    'Av. de Europa, 24, Montequinto',
    290.00, 4, 2,
    'Manuel Sánchez', 'manuel.s@gmail.com',
    'Casero particular. El piso tiene terraza, aire acondicionado y supermercados al lado.',
    ST_SetSRID(ST_MakePoint(-5.931000, 37.348500), 4326)
);

-- Alojamiento 4: Montequinto Olivar de Quintos (a ~2.6 km)
INSERT INTO alojamientos (titulo, tipo, direccion, precio_mes, habitaciones_totales, habitaciones_libres, nombre_casero, contacto_casero, biografia_casero, geom)
VALUES (
    'Chalet adosado para estudiantes en Olivar de Quintos',
    'Piso Compartido',
    'Calle Mesina, 8, Olivar de Quintos',
    320.00, 4, 1,
    'Rafael Morales', 'rafa.morales@hotmail.com',
    'Alquilo habitaciones a universitarios responsables. Zona muy tranquila para concentrarse.',
    ST_SetSRID(ST_MakePoint(-5.926000, 37.342000), 4326)
);

-- Alojamiento 5: Bellavista (a ~4.8 km, línea de bus)
INSERT INTO alojamientos (titulo, tipo, direccion, precio_mes, habitaciones_totales, habitaciones_libres, nombre_casero, contacto_casero, biografia_casero, geom)
VALUES (
    'Ático Juvenil en Bellavista Sur',
    'Piso Compartido',
    'Calle Guadalajara, 19, Bellavista, Sevilla',
    275.00, 3, 1,
    'Laura Gil', 'laura.sevilla@gmail.com',
    'Piso recién reformado con fácil aparcamiento y estación de Cercanías a 4 minutos.',
    ST_SetSRID(ST_MakePoint(-5.973000, 37.341000), 4326)
);

-- Alojamiento 6: Sevilla Centro - Viapol (a ~8.5 km, muy lejos de Loyola para probar los filtros)
INSERT INTO alojamientos (titulo, tipo, direccion, precio_mes, habitaciones_totales, habitaciones_libres, nombre_casero, contacto_casero, biografia_casero, geom)
VALUES (
    'Apartamento en San Bernardo / Viapol',
    'Piso Compartido',
    'Calle Enramadilla, 3, Sevilla Centro',
    420.00, 3, 0,
    'Fernando Castro', 'fcastro@inmo.es',
    'Excelente ubicación para vida en Sevilla capital.',
    ST_SetSRID(ST_MakePoint(-5.982000, 37.381000), 4326)
);

-- 4. Insertamos Habitaciones y Biografías de Convivencia para los Pisos
-- Para el Alojamiento 1 (Piso en Entrenúcleos, 3 habitaciones, 2 ocupadas y 1 disponible)
INSERT INTO habitaciones_convivencia (alojamiento_id, numero_habitacion, estado, precio_habitacion, nombre_estudiante, grado, curso, biografia_convivencia)
VALUES 
(1, 1, 'Ocupada', 350.00, 'Álvaro Martín', 'Ingeniería del Software', 3, 
 'Suelo estudiar en biblioteca, entreno baloncesto 3 días por semana. Muy limpio con las zonas comunes y respetuoso con las horas de sueño.'),
(1, 2, 'Ocupada', 350.00, 'Lucía Ruiz', 'ADE y Relaciones Internacionales', 2, 
 'Chica tranquila, me gusta cocinar y escuchar podcasts. No hago fiestas entre semana porque madrugo para ir a Loyola.'),
(1, 3, 'Disponible', 350.00, NULL, NULL, NULL, 
 'Habitación libre con cama de 105cm, escritorio amplio, ventana exterior a jardín y armario empotrado.');

-- Para el Alojamiento 3 (Montequinto, 4 habitaciones: 2 ocupadas, 2 disponibles)
INSERT INTO habitaciones_convivencia (alojamiento_id, numero_habitacion, estado, precio_habitacion, nombre_estudiante, grado, curso, biografia_convivencia)
VALUES 
(3, 1, 'Ocupada', 290.00, 'Marcos Peña', 'Criminología y Derecho', 4, 
 'Último año de carrera. Busco buen ambiente de convivencia, compañerismo y respeto por las épocas de exámenes.'),
(3, 2, 'Ocupada', 290.00, 'Daniel Herrera', 'Ingeniería Mecatrónica', 1, 
 'Aficionado a la robótica y videojuegos con cascos. Sociable pero independiente.'),
(3, 3, 'Disponible', 290.00, NULL, NULL, NULL, 
 'Habitación exterior luminosa con mesa de estudio y aire acondicionado.'),
(3, 4, 'Disponible', 290.00, NULL, NULL, NULL, 
 'Habitación individual amueblada con conexión ethernet directa.');
