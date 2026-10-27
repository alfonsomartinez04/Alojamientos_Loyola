
-- 1. Inserción del Campus de la Universidad Loyola Andalucía
INSERT INTO campus_universitario (nombre, ciudad, direccion, lat, lon, geom)
VALUES (
    'Universidad Loyola Andalucía - Campus Sevilla',
    'Dos Hermanas',
    'Avenida de las Universidades, 2, 41704 Dos Hermanas, Sevilla',
    37.306900,
    -5.941800,
    ST_SetSRID(ST_MakePoint(-5.941800, 37.306900), 4326)
);

-- 2. Inserción de Polígonos de Cobertura (Transporte y Barrios Estudiantiles)
INSERT INTO zonas_cobertura (nombre_barrio, transporte_directo, tiempo_estimado_min, geom)
VALUES 
(
    'Entrenúcleos - Campus Direct',
    'Carril bici / A pie / Bus urbano',
    5,
    ST_SetSRID(ST_GeomFromText('POLYGON((
        -5.9550 37.3000,
        -5.9300 37.3000,
        -5.9300 37.3280,
        -5.9550 37.3280,
        -5.9550 37.3000
    ))'), 4326)
),
(
    'Montequinto - Olivar de Quintos',
    'Línea 1 Metro + Bus Lanzadera Loyola',
    12,
    ST_SetSRID(ST_GeomFromText('POLYGON((
        -5.9450 37.3300,
        -5.9150 37.3300,
        -5.9150 37.3600,
        -5.9450 37.3600,
        -5.9450 37.3300
    ))'), 4326)
),
(
    'Bellavista - Bermejales',
    'Lanzadera interurbana Loyola / Tren C1 Cercanías',
    15,
    ST_SetSRID(ST_GeomFromText('POLYGON((
        -5.9850 37.3200,
        -5.9600 37.3200,
        -5.9600 37.3480,
        -5.9850 37.3480,
        -5.9850 37.3200
    ))'), 4326)
);

-- 3. Inserción de los 20 Alojamientos en un radio máximo de 5 km de Loyola
INSERT INTO alojamientos (id, titulo, tipo, direccion, barrio, lat, lon, precio_mes, habitaciones_totales, habitaciones_libres, nombre_casero, contacto_casero, biografia_casero, geom)
VALUES
(1, 'Piso Moderno Entrenúcleos Suites', 'Piso Compartido', 'Av. de las Universidades, 14, Entrenúcleos', 'Entrenúcleos', 37.311500, -5.939000, 350.00, 3, 1, 'Carmen Domínguez', 'carmen.d@alojaloyola.es', 'Exalumna de Loyola. Acondiciono mis pisos para universitarios con wifi fibra 1Gb y mesas de estudio.', ST_SetSRID(ST_MakePoint(-5.939000, 37.311500), 4326)),
(2, 'Residencia Loyola Campus Living', 'Residencia Universitaria', 'Calle José Rodríguez de la Borbolla, 5, Entrenúcleos', 'Entrenúcleos', 37.314000, -5.936000, 680.00, 45, 5, 'Gerencia Campus Living', 'info@campusliving.es', 'Residencia concertada para Loyola. Pensión completa, gimnasio, salas coworking y vigilancia 24h.', ST_SetSRID(ST_MakePoint(-5.936000, 37.314000), 4326)),
(3, 'Piso Jardines de las Universidades', 'Piso Compartido', 'Calle Manuel Clavero Arévalo, 8, Entrenúcleos', 'Entrenúcleos', 37.316500, -5.943000, 340.00, 4, 2, 'Javier Benítez', 'j.benitez@gmail.com', 'Piso nuevo a estrenar junto a carril bici directo a la puerta de Loyola.', ST_SetSRID(ST_MakePoint(-5.943000, 37.316500), 4326)),
(4, 'Ático Panorámico Av. Plácido Fdez Viagas', 'Estudio / Ático', 'Av. Plácido Fernández Viagas, 22, Entrenúcleos', 'Entrenúcleos', 37.319000, -5.938000, 390.00, 3, 1, 'Elena Herrera', 'elena.atico@inmo.com', 'Ático de diseño con terraza de 25m2 para desconectar con vistas a todo Entrenúcleos.', ST_SetSRID(ST_MakePoint(-5.938000, 37.319000), 4326)),
(5, 'Piso Estudiantil Torre Entrenúcleos', 'Piso Compartido', 'Calle Santiago Carrillo, 4, Entrenúcleos', 'Entrenúcleos', 37.322000, -5.941000, 360.00, 3, 1, 'Andrés Macías', 'andres.m@yahoo.es', 'Trato cercano, resuelvo cualquier avería el mismo día. Busco inquilinos formales.', ST_SetSRID(ST_MakePoint(-5.941000, 37.322000), 4326)),
(6, 'Chalet Estudiantil Olivar de Quintos', 'Chalet Adosado', 'Calle Mesina, 8, Olivar de Quintos', 'Olivar de Quintos', 37.332000, -5.931000, 420.00, 4, 2, 'Rafael Morales', 'rafa.morales@hotmail.com', 'Chalet adosado con patio trasero para barbacoas de fin de semana y zona de relax.', ST_SetSRID(ST_MakePoint(-5.931000, 37.332000), 4326)),
(7, 'Piso junto a Estación Metro Olivar de Quintos', 'Piso Compartido', 'Av. Condes de Ibarra, 3, Olivar de Quintos', 'Olivar de Quintos', 37.335000, -5.928000, 310.00, 3, 1, 'María Ángeles Vílchez', 'mavilchez@gmail.com', 'Ubicación inmejorable: a 50 metros del metro final de línea 1 y lanzadera directa a Loyola.', ST_SetSRID(ST_MakePoint(-5.928000, 37.335000), 4326)),
(8, 'Piso Luminoso Av. de Europa', 'Piso Compartido', 'Av. de Europa, 24, Montequinto', 'Montequinto', 37.342000, -5.931500, 280.00, 4, 2, 'Manuel Sánchez', 'manuel.s@gmail.com', 'Piso con supermercados Mercadona y Dia justo debajo y terraza comunitaria.', ST_SetSRID(ST_MakePoint(-5.931500, 37.342000), 4326)),
(9, 'Estudio Individual Montequinto Centro', 'Estudio / Ático', 'Calle Siena, 6, Montequinto', 'Montequinto', 37.345000, -5.934000, 450.00, 1, 1, 'Inmaculada León', 'inma.leon@gestinmo.com', 'Estudio independiente para quien busca privacidad absoluta sin compartir zonas comunes.', ST_SetSRID(ST_MakePoint(-5.934000, 37.345000), 4326)),
(10, 'Piso Compartido junto a Metro Europa', 'Piso Compartido', 'Av. de San José de Calasanz, 11, Montequinto', 'Montequinto', 37.348000, -5.930000, 260.00, 4, 1, 'Pablo Osorio', 'posorio@pisossevilla.com', 'Económico y práctico. Especial para estudiantes con presupuesto ajustado.', ST_SetSRID(ST_MakePoint(-5.930000, 37.348000), 4326)),
(11, 'Piso Estudiantes Calle Bolonia', 'Piso Compartido', 'Calle Bolonia, 15, Montequinto', 'Montequinto', 37.343500, -5.927000, 290.00, 3, 1, 'Patricia Valera', 'pvalera@quintoalquila.com', 'Piso reformado con cocina americana, electrodomésticos clase A y aire acondicionado.', ST_SetSRID(ST_MakePoint(-5.927000, 37.343500), 4326)),
(12, 'Residencia Universitaria Montequinto Hub', 'Residencia Universitaria', 'Av. de los Pinos, 32, Montequinto', 'Montequinto', 37.346000, -5.936500, 590.00, 30, 4, 'Comunidad ResiHub', 'sevilla@resihub.com', 'Residencia mixta con salas de estudio, actividades de integración deportiva y lavandería.', ST_SetSRID(ST_MakePoint(-5.936500, 37.346000), 4326)),
(13, 'Piso Reformado Calle Guadalajara', 'Piso Compartido', 'Calle Guadalajara, 19, Bellavista', 'Bellavista', 37.333000, -5.972000, 275.00, 3, 1, 'Laura Gil', 'laura.sevilla@gmail.com', 'Zona con gran ambiente de bares de tapas y estación de tren de cercanías.', ST_SetSRID(ST_MakePoint(-5.972000, 37.333000), 4326)),
(14, 'Ático Premium Jardines de Hércules', 'Estudio / Ático', 'Paseo de Europa, 45, Bellavista - Bermejales', 'Bellavista', 37.337000, -5.975000, 430.00, 2, 1, 'Tomás Varo', 'tomasvaro@inmobellido.com', 'Urbanización privada con piscina comunitaria, pista de pádel y portero 24 horas.', ST_SetSRID(ST_MakePoint(-5.975000, 37.337000), 4326)),
(15, 'Piso Cercanías Bellavista', 'Piso Compartido', 'Calle Asencio y Toledo, 14, Bellavista', 'Bellavista', 37.329000, -5.970000, 295.00, 3, 1, 'Francisco Alarcón', 'alarcon_bellavista@hotmail.com', 'A 3 minutos andando de la estación de Cercanías Renfe y parada de autobús.', ST_SetSRID(ST_MakePoint(-5.970000, 37.329000), 4326)),
(16, 'Piso Económico Plaza del Arenal', 'Piso Compartido', 'Plaza del Arenal, 6, Dos Hermanas Centro', 'Dos Hermanas Centro', 37.289000, -5.927000, 240.00, 3, 1, 'Antonia Gómez', 'antoniagomez@gmail.com', 'En pleno centro histórico de Dos Hermanas, con todo tipo de comercios y tren de cercanías.', ST_SetSRID(ST_MakePoint(-5.927000, 37.289000), 4326)),
(17, 'Chalet con Piscina Arco Norte', 'Chalet Adosado', 'Av. Adolfo Suárez, 55, Dos Hermanas Norte', 'Dos Hermanas Centro', 37.298000, -5.932000, 480.00, 4, 1, 'Guillermo Bécquer', 'gbecquer@chaletsdoshermanas.es', 'Chalet de lujo con piscina, porche ajardinado y aparcamiento privado.', ST_SetSRID(ST_MakePoint(-5.932000, 37.298000), 4326)),
(18, 'Piso Céntrico Calle Antonia Díaz', 'Piso Compartido', 'Calle Antonia Díaz, 31, Dos Hermanas Centro', 'Dos Hermanas Centro', 37.286000, -5.929000, 250.00, 3, 1, 'Joaquín Valenzuela', 'jvalenzuela@pisosdh.com', 'Piso tradicional andaluz con patio de luces, muy fresco en verano y silencioso.', ST_SetSRID(ST_MakePoint(-5.929000, 37.286000), 4326)),
(19, 'Apartamento Moderno Av. de España', 'Piso Compartido', 'Av. de España, 78, Dos Hermanas', 'Dos Hermanas Centro', 37.293000, -5.940000, 330.00, 2, 1, 'Susana Porras', 'susana.porras@alquileres.com', 'Piso moderno de 2 habitaciones, ideal para convivencia íntima y de confianza.', ST_SetSRID(ST_MakePoint(-5.940000, 37.293000), 4326)),
(20, 'Residencia Universitaria El Arenal', 'Residencia Universitaria', 'Calle Real Utrera, 20, Dos Hermanas Centro', 'Dos Hermanas Centro', 37.288500, -5.925000, 520.00, 20, 3, 'Residencia El Arenal S.L.', 'reservas@resielarenal.es', 'Residencia con régimen de media pensión o pensión completa opcional y salas comunes de estudio.', ST_SetSRID(ST_MakePoint(-5.925000, 37.288500), 4326));

-- Ajustamos la secuencia del ID de alojamientos
SELECT setval('alojamientos_id_seq', 20);

-- 4. Inserción de Habitaciones y Perfiles de Convivencia
INSERT INTO habitaciones_convivencia (alojamiento_id, numero_habitacion, estado, precio_habitacion, nombre_estudiante, grado, curso, biografia_convivencia)
VALUES 
-- Alojamiento 1 (Entrenúcleos)
(1, 1, 'Ocupada', 350.00, 'Álvaro Martín', 'Ingeniería del Software', 3, 'Estudio mucho en biblioteca, juego al baloncesto y me gusta mantener la cocina limpia y el silencio de noche.'),
(1, 2, 'Ocupada', 350.00, 'Lucía Ruiz', 'ADE y Relaciones Internacionales', 2, 'Chica tranquila, me gusta salir a correr por Entrenúcleos y repostería los findes. Ambiente de estudio.'),
(1, 3, 'Disponible', 350.00, NULL, NULL, NULL, 'Habitación individual con luz natural, cama de 105cm, escritorio amplio, silla ergonómica y armario empotrado.'),

-- Alojamiento 2 (Residencia Loyola Living)
(2, 101, 'Ocupada', 680.00, 'Guillermo Sanz', 'Derecho y ADE', 1, 'Deportista, sociable, de Madrid. Me gusta hacer piña en las zonas comunes de la residencia.'),
(2, 102, 'Disponible', 680.00, NULL, NULL, NULL, 'Habitación individual con baño privado, pensión completa incluida, climatización y limpieza semanal.'),

-- Alojamiento 3 (Jardines Universidades)
(3, 1, 'Ocupada', 340.00, 'Mateo Rossi', 'Economía (Erasmus)', 3, 'Estudiante italiano de Erasmus. Respetuoso, ordenado, me gusta practicar español y conocer gente sana.'),
(3, 2, 'Ocupada', 340.00, 'Sofia Delgado', 'Psicología', 2, 'Suelo estudiar con música tranquila en cascos. No fumadora y muy cuidadosa con la convivencia.'),
(3, 3, 'Disponible', 340.00, NULL, NULL, NULL, 'Habitación con cama grande, balcón privado a jardín y toma ethernet de alta velocidad.'),
(3, 4, 'Disponible', 340.00, NULL, NULL, NULL, 'Habitación luminosa orientada al este con escritorio esquinero y armario doble.'),

-- Alojamiento 4 (Ático Entrenúcleos)
(4, 1, 'Ocupada', 390.00, 'Nicolás Cano', 'Ingeniería Mecatrónica', 4, 'Fan de la robótica y la Fórmula 1. Ordenado, responsable y con buen sentido del humor.'),
(4, 2, 'Ocupada', 390.00, 'Paula Márquez', 'Comunicación Digital', 3, 'Creativa, trabajo a tiempo parcial en marketing. Busco convivencia colaborativa y buen rollo.'),
(4, 3, 'Disponible', 390.00, NULL, NULL, NULL, 'Habitación principal con acceso directo a terraza panorámica y aire acondicionado frío/calor.'),

-- Alojamiento 5 (Torre Entrenúcleos)
(5, 1, 'Ocupada', 360.00, 'David Romero', 'Criminología', 2, 'Madrugo para ir al gimnasio, limpio y enfocado en los exámenes. Cero problemas de convivencia.'),
(5, 2, 'Ocupada', 360.00, 'Carla Lozano', 'Educación Infantil', 3, 'Sociable, me encanta el cine y la fotografía. Me gusta compartir cenas charlando.'),
(5, 3, 'Disponible', 360.00, NULL, NULL, NULL, 'Habitación amueblada, colchón viscoelástico nuevo y ventana insonorizada.'),

-- Alojamiento 6 (Chalet Olivar)
(6, 1, 'Ocupada', 420.00, 'Hugo Giménez', 'Biotecnología', 2, 'Me gusta la tranquilidad del chalet para estudiar. Salgo a correr por el parque los domingos.'),
(6, 2, 'Ocupada', 420.00, 'Ignacio Rivas', 'Ingeniería Industrial', 3, 'Organizado, amante de la tecnología y el deporte. Respetuoso con los horarios de descanso.'),
(6, 3, 'Disponible', 420.00, NULL, NULL, NULL, 'Habitación espaciosa con vistas al jardín del chalet, baño semi-privado.'),
(6, 4, 'Disponible', 420.00, NULL, NULL, NULL, 'Habitación individual con luz cenital, escritorio doble y estanterías para libros.'),

-- Alojamiento 7 (Metro Olivar)
(7, 1, 'Ocupada', 310.00, 'Adrián Navarro', 'Administración de Empresas', 4, 'Centrado en el TFG y prácticas en empresa. Rutinas fijas y ambiente muy tranquilo.'),
(7, 2, 'Ocupada', 310.00, 'Sergio Santos', 'Ingeniería del Software', 2, 'Apasionado del código y el ajedrez. Convivencia fácil, no pongo problemas por nada.'),
(7, 3, 'Disponible', 310.00, NULL, NULL, NULL, 'Habitación exterior con balcón a la avenida, armario empotrado y mesa de oficina.'),

-- Alojamiento 8 (Av. de Europa Montequinto)
(8, 1, 'Ocupada', 280.00, 'Marcos Peña', 'Criminología y Derecho', 4, 'Último año. Busco buen ambiente de convivencia, compañerismo y respeto en época de exámenes.'),
(8, 2, 'Ocupada', 280.00, 'Daniel Herrera', 'Ingeniería Mecatrónica', 1, 'De Almería. Me gusta la tecnología, la música indie y cocinar los domingos.'),
(8, 3, 'Disponible', 280.00, NULL, NULL, NULL, 'Habitación exterior soleada, mesa de estudio con flexo y calefactor.'),
(8, 4, 'Disponible', 280.00, NULL, NULL, NULL, 'Habitación interior muy silenciosa ideal para los que necesitan máxima concentración.'),

-- Alojamiento 9 (Estudio Montequinto)
(9, 1, 'Disponible', 450.00, NULL, NULL, NULL, 'Estudio completo: cocina propia equipada, baño en suite, sofá cama de alta gama y zona de estudio.'),

-- Alojamiento 10 (Metro Europa)
(10, 1, 'Ocupada', 260.00, 'Iván Carrasco', 'Educación Primaria', 2, 'Extrovertido, toco la guitarra acústica (a horas prudentes) y hago senderismo.'),
(10, 2, 'Ocupada', 260.00, 'Raúl Montero', 'Ingeniería del Software', 3, 'Horario intensivo de estudio, me gusta salir de cañas los jueves universitarios.'),
(10, 3, 'Ocupada', 260.00, 'Gonzalo Ortiz', 'Fisioterapia', 1, 'Muy ordenado con la limpieza semanal y responsable en casa.'),
(10, 4, 'Disponible', 260.00, NULL, NULL, NULL, 'Habitación económica y acogedora con armario y mesa de estudio.'),

-- Alojamiento 11 (Calle Bolonia)
(11, 1, 'Ocupada', 290.00, 'Marina Conde', 'Periodismo y Comunicación', 2, 'Lectora empedernida, organizada y alegre. Ambiente casero tranquilo y de respeto mutuo.'),
(11, 2, 'Ocupada', 290.00, 'Lucía Tejero', 'Diseño Gráfico', 3, 'Tranquila, trabajo en proyectos creativos. Me encanta el orden en el salón y la cocina.'),
(11, 3, 'Disponible', 290.00, NULL, NULL, NULL, 'Habitación amueblada con cama nido, estantería espaciosa y ventana exterior.'),

-- Alojamiento 12 (Montequinto Hub)
(12, 204, 'Ocupada', 590.00, 'Felipe Cobos', 'Relaciones Internacionales', 1, 'De Córdoba, apasionado de los debates y los idiomas. Muy sociable.'),
(12, 205, 'Disponible', 590.00, NULL, NULL, NULL, 'Habitación individual con baño privado, aire acondicionado centralizado y gastos incluidos.'),

-- Alojamiento 13 (Calle Guadalajara Bellavista)
(13, 1, 'Ocupada', 275.00, 'Emilio Pardo', 'Enfermería', 3, 'Hago turnos de prácticas en hospital, por lo que valoro muchísimo el silencio y la consideración de descanso.'),
(13, 2, 'Ocupada', 275.00, 'Celia Barroso', 'Farmacia', 2, 'Estudio constante, limpia y colaborativa. Me gusta cocinar comida saludable.'),
(13, 3, 'Disponible', 275.00, NULL, NULL, NULL, 'Habitación exterior con cama canapé de 105cm, mesa de escritorio y armario de 2 puertas.'),

-- Alojamiento 14 (Jardines de Hércules)
(14, 1, 'Ocupada', 430.00, 'Clara Soler', 'Máster en Ciberseguridad', 1, 'Graduada en ingeniería, teletrabajo a media jornada. Ambiente muy profesional y tranquilo.'),
(14, 2, 'Disponible', 430.00, NULL, NULL, NULL, 'Habitación con acceso a terraza común del ático, baño compartido solo con Clara.'),

-- Alojamiento 15 (Cercanías Bellavista)
(15, 1, 'Ocupada', 295.00, 'Rodrigo Paz', 'Ingeniería de Telecomunicación', 2, 'Muy aficionado al cine clásico y a programar. Silencioso y siempre predispuesto a ayudar.'),
(15, 2, 'Ocupada', 295.00, 'Marta Galiano', 'ADE', 3, 'Madrugadora, alegre y muy responsable con los turnos de limpieza de la casa.'),
(15, 3, 'Disponible', 295.00, NULL, NULL, NULL, 'Habitación con ventana a patio interior silencioso, mesa de estudio con cajonera.'),

-- Alojamiento 16 (Plaza Arenal Dos Hermanas)
(16, 1, 'Ocupada', 240.00, 'Lucas Marín', 'Derecho', 3, 'Estudio por las mañanas, trabajo los fines de semana. Respetuoso con los compañeros.'),
(16, 2, 'Ocupada', 240.00, 'Pablo Reina', 'Ingeniería del Software', 1, 'Me gusta el fútbol y el gaming. Convivencia relajada y cordial.'),
(16, 3, 'Disponible', 240.00, NULL, NULL, NULL, 'Habitación individual muy económica, cama de 90cm y mesa de estudio.'),

-- Alojamiento 17 (Arco Norte Dos Hermanas)
(17, 1, 'Ocupada', 480.00, 'Jaime de la Cerda', 'ADE Bilingüe', 4, 'Preparando oposiciones internacionales. Muy serio, deportista (tenis) y amante de la lectura.'),
(17, 2, 'Ocupada', 480.00, 'Belén Cifuentes', 'Biomedicina', 3, 'Paso muchas horas en laboratorios. Cuando estoy en casa me gusta descansar y cocinar tranquila.'),
(17, 3, 'Ocupada', 480.00, 'Darío Nieto', 'Ingeniería de Datos', 2, 'Tranquilo, ordenado, suelo estudiar en el jardín cuando hace buen tiempo.'),
(17, 4, 'Disponible', 480.00, NULL, NULL, NULL, 'Suite amplia con armario vestidor, mesa ejecutiva de trabajo y vistas a la piscina.'),

-- Alojamiento 18 (Calle Antonia Díaz)
(18, 1, 'Ocupada', 250.00, 'Teresa Cobo', 'Psicología', 4, 'Muy sociable pero madura. Me gusta tener la casa bonita y limpia, cero malos rollos.'),
(18, 2, 'Ocupada', 250.00, 'Manuel Serrano', 'ADE', 2, 'Chico deportista, corro por las tardes y estudio con regularidad. No fumador.'),
(18, 3, 'Disponible', 250.00, NULL, NULL, NULL, 'Habitación individual con ventana al patio, cama de 90cm, escritorio y armario.'),

-- Alojamiento 19 (Av. de España)
(19, 1, 'Ocupada', 330.00, 'Enrique Saldaña', 'Ingeniería del Software', 3, 'Programador, me gusta el gym y la cocina japonesa. Limpio, organizado y cordial.'),
(19, 2, 'Disponible', 330.00, NULL, NULL, NULL, 'Habitación exterior con cama de 135cm, mesa grande de trabajo y aire acondicionado inverter.'),

-- Alojamiento 20 (Residencia El Arenal)
(20, 12, 'Ocupada', 520.00, 'Ignacio Baena', 'Derecho', 1, 'De Huelva, me encanta la vida universitaria, salir de tapas y el ambiente de la residencia.'),
(20, 14, 'Disponible', 520.00, NULL, NULL, NULL, 'Habitación individual con baño, limpieza semanal y media pensión incluida.');
