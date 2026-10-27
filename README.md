# 🏠 Buscador Geoespacial de Alojamientos en el Campus Loyola Sevilla
### Base de Datos Especializada con PostgreSQL y PostGIS (TPI 1)

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![PostGIS](https://img.shields.io/badge/PostGIS-3.4-5B9B42?logo=postgis&logoColor=white)](https://postgis.net/)
[![Docker](https://img.shields.io/badge/Docker%20Compose-Ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Leaflet](https://img.shields.io/badge/Leaflet-1.9.4-199900?logo=leaflet&logoColor=white)](https://leafletjs.com/)

**Asignatura:** Ampliación de Bases de Datos  
**Grado:** Grado en Ingeniería del Software (Curso 2026/2027)  
**Institución:** Universidad Loyola Andalucía (Campus Sevilla - Dos Hermanas)  
**Profesor:** Dr. Anier Soria Lorente  
**Estudiante:** Alfonso Nicolás Martínez Márquez  

---

## 📖 Descripción del Proyecto

Este repositorio contiene la implementación completa del **Trabajo Práctico Individual 1 (TPI 1)**, enfocado en el **Tema 3: Bases de Datos Especializadas (Geoespaciales)**.

El proyecto aborda la búsqueda y filtrado inteligente de alojamientos para estudiantes en el entorno de influencia del **Campus de la Universidad Loyola en Dos Hermanas (Sevilla)**:
* **Muestra:** 20 alojamientos realistas en un radio de 5 km distribuidos en **Entrenúcleos**, **Montequinto**, **Bellavista (Sevilla Sur)** y **Dos Hermanas Centro**.
* **Modelo Espacial y Relacional:** Geometrías nativas `Point` y `Polygon` en el sistema de coordenadas elipsoidal **WGS 84 (SRID 4326)**, combinadas con una tabla normalizada de habitaciones y perfiles de convivencia.
* **Índices Espaciales GiST:** Indexación funcional sobre `(geom::geography)` que permite resolver consultas de radio en apenas **0,12 milisegundos**.
* **Visor Web Interactivo:** Aplicación web en Leaflet (`mapa_alojamientos.html`) con cartografía de Esri, selector dinámico de radio y ordenación por distancia y precio.

---

## 🏛️ Estructura del Repositorio

```text
📁 Alojamientos_Loyola/
  ├── compose.yaml                         # Orquestación de PostgreSQL 16 + PostGIS 3.4
  ├── init.sql                             # Carga inicial automatizada de DDL y datos
  ├── 01_init_postgis_ddl.sql              # Esquema DDL de tablas e índices GiST
  ├── 02_insert_20_alojamientos.sql        # Inserción de 20 viviendas y 58 habitaciones
  ├── 03_consultas_espaciales.sql          # Consultas espaciales (ST_DWithin, ST_Distance, ST_Contains)
  ├── mapa_alojamientos.html               # Visor interactivo en Leaflet con azulejos Esri
  ├── alojamientos_loyola_20.json          # Dataset en formato JSON
  └── TPI_1_Alfonso_Alojamientos_Loyola.pdf # Memoria oficial entregable en PDF
```

---

## 🚀 Puesta en Marcha Rápida (Docker)

### 1. Clonar el repositorio
```bash
git clone https://github.com/alfonsomartinez04/Alojamientos_Loyola.git
cd Alojamientos_Loyola
```

### 2. Levantar la base de datos PostGIS
```bash
docker compose up -d
```
* **Host:** `localhost` | **Puerto:** `5432`
* **Base de datos:** `alojamientos_db` | **Usuario:** `loyola_admin` | **Contraseña:** `loyola_password`

### 3. Ejecutar la consulta espacial de proximidad (Ejemplo: Radio 2.000 m)
```bash
docker exec -it alojamientos-postgis psql -U loyola_admin -d alojamientos_db -c \
  "SELECT id, titulo, barrio, precio_mes, \
   ROUND(ST_Distance(geom::geography, ST_SetSRID(ST_MakePoint(-5.9418, 37.3069), 4326)::geography)::numeric, 0) AS dist_m \
   FROM alojamientos \
   WHERE ST_DWithin(geom::geography, ST_SetSRID(ST_MakePoint(-5.9418, 37.3069), 4326)::geography, 2000) \
   ORDER BY dist_m ASC;"
```

### 4. Abrir el Mapa Interactivo
Abre el archivo `mapa_alojamientos.html` en tu navegador para interactuar con el mapa, ajustar el radio con el slider y ordenar las ofertas.

---

## 📄 Memoria del Trabajo

La memoria oficial en PDF con las 10 secciones de la plantilla de Loyola, la justificación teórica frente a bases de datos relacionales tradicionales, el análisis de rendimiento con `EXPLAIN ANALYZE` y las capturas reales está disponible en:
* [`TPI_1_Alfonso_Alojamientos_Loyola.pdf`](./TPI_1_Alfonso_Alojamientos_Loyola.pdf)
