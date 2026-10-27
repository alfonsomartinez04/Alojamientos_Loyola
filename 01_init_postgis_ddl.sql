
-- 1. Activación de la extensión espacial PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- 2. Eliminación preventiva de tablas en cascada si ya existían
DROP TABLE IF EXISTS habitaciones_convivencia CASCADE;
DROP TABLE IF EXISTS alojamientos CASCADE;
DROP TABLE IF EXISTS zonas_cobertura CASCADE;
DROP TABLE IF EXISTS campus_universitario CASCADE;

-- -----------------------------------------------------------------------------
-- 3. Tabla 'campus_universitario' (Punto GPS de referencia)
-- -----------------------------------------------------------------------------
CREATE TABLE campus_universitario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    ciudad VARCHAR(60) NOT NULL,
    direccion VARCHAR(180) NOT NULL,
    lat NUMERIC(9, 6) NOT NULL,
    lon NUMERIC(9, 6) NOT NULL,
    geom GEOMETRY(Point, 4326) NOT NULL, -- Punto GPS en WGS 84 (SRID 4326)
    
    CONSTRAINT chk_campus_lat CHECK (lat BETWEEN -90.0 AND 90.0),
    CONSTRAINT chk_campus_lon CHECK (lon BETWEEN -180.0 AND 180.0)
);

-- -----------------------------------------------------------------------------
-- 4. Tabla 'zonas_cobertura' (Polígonos 2D de barrios y transporte)
-- -----------------------------------------------------------------------------
CREATE TABLE zonas_cobertura (
    id SERIAL PRIMARY KEY,
    nombre_barrio VARCHAR(100) NOT NULL,
    transporte_directo VARCHAR(120) NOT NULL,
    tiempo_estimado_min INT NOT NULL,
    geom GEOMETRY(Polygon, 4326) NOT NULL -- Polígono cerrado con límites geográficos del barrio
);

-- -----------------------------------------------------------------------------
-- 5. Tabla 'alojamientos' (Pisos, Residencias, Chalets y Estudios)
-- -----------------------------------------------------------------------------
CREATE TABLE alojamientos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(140) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    direccion VARCHAR(180) NOT NULL,
    barrio VARCHAR(80) NOT NULL,
    lat NUMERIC(9, 6) NOT NULL,
    lon NUMERIC(9, 6) NOT NULL,
    precio_mes NUMERIC(7, 2) NOT NULL,
    habitaciones_totales INT NOT NULL,
    habitaciones_libres INT NOT NULL,
    nombre_casero VARCHAR(100),
    contacto_casero VARCHAR(100),
    biografia_casero TEXT,
    geom GEOMETRY(Point, 4326) NOT NULL,

    -- Restricciones de integridad (Check constraints)
    CONSTRAINT chk_precio_mes_positivo CHECK (precio_mes > 0),
    CONSTRAINT chk_aloj_lat CHECK (lat BETWEEN -90.0 AND 90.0),
    CONSTRAINT chk_aloj_lon CHECK (lon BETWEEN -180.0 AND 180.0),
    CONSTRAINT chk_hab_libres CHECK (habitaciones_libres <= habitaciones_totales),
    CONSTRAINT chk_tipo_valido CHECK (tipo IN ('Piso Compartido', 'Residencia Universitaria', 'Chalet Adosado', 'Estudio / Ático'))
);

-- -----------------------------------------------------------------------------
-- 6. Tabla 'habitaciones_convivencia' (El factor diferencial del proyecto)
-- -----------------------------------------------------------------------------
CREATE TABLE habitaciones_convivencia (
    id SERIAL PRIMARY KEY,
    alojamiento_id INT NOT NULL REFERENCES alojamientos(id) ON DELETE CASCADE,
    numero_habitacion INT NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Disponible', 'Ocupada')),
    precio_habitacion NUMERIC(6, 2) NOT NULL,
    nombre_estudiante VARCHAR(80),
    grado VARCHAR(80),
    curso INT,
    biografia_convivencia TEXT
);

-- -----------------------------------------------------------------------------
-- 7. Creación de Índices Espaciales GiST y B-Tree
-- -----------------------------------------------------------------------------

-- Índice GiST estándar para operaciones espaciales (bounding box 2D)
CREATE INDEX idx_alojamientos_geom_gist 
    ON alojamientos 
    USING GIST (geom);

-- Índice GiST funcional sobre tipo GEOGRAPHY (calcula distancias geodésicas en metros reales)
CREATE INDEX idx_alojamientos_geog_gist 
    ON alojamientos 
    USING GIST ((geom::geography));

-- Índice GiST sobre polígonos de zonas de cobertura (para ST_Contains)
CREATE INDEX idx_zonas_geom_gist 
    ON zonas_cobertura 
    USING GIST (geom);

-- Índice B-Tree clásico para ordenaciones y filtros por precio
CREATE INDEX idx_alojamientos_precio_btree 
    ON alojamientos (precio_mes);

-- -----------------------------------------------------------------------------
-- 8. Documentación de metadatos en el catálogo de PostgreSQL
-- -----------------------------------------------------------------------------
COMMENT ON TABLE alojamientos IS 'Catálogo geoespacial de alojamientos para estudiantes en el entorno de la Univ. Loyola';
COMMENT ON COLUMN alojamientos.geom IS 'Punto GPS WGS84 (SRID 4326), formato Point(lon, lat)';
COMMENT ON INDEX idx_alojamientos_geog_gist IS 'Índice GiST geodésico para consultas de proximidad (ST_DWithin) en metros';
COMMENT ON TABLE habitaciones_convivencia IS 'Habitaciones individuales con biografía y perfil de convivencia de los inquilinos actuales';
