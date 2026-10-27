# Script para cargar alojamientos_loyola_20.json en PostgreSQL / PostGIS
$dockerPath = "C:\Users\alfon\AppData\Local\Programs\DockerDesktop\resources\bin"
$jsonPath = "c:\Users\alfon\Documents\UNI\TERCERO\1er CUATRI\ADBBDD\TPI\alojamientos-loyola\alojamientos_loyola_20.json"

$data = Get-Content -Raw -Path $jsonPath -Encoding UTF8 | ConvertFrom-Json

# Limpiamos las tablas anteriores para insertar los 20 nuevos
$clearSql = "TRUNCATE TABLE habitaciones_convivencia, alojamientos RESTART IDENTITY CASCADE;"
& "$dockerPath\docker.exe" exec alojamientos-postgis psql -U loyola_admin -d alojamientos_db -c $clearSql

foreach ($item in $data) {
    # Escapamos comillas simples
    $titulo = $item.titulo -replace "'", "''"
    $tipo = $item.tipo -replace "'", "''"
    $direccion = $item.direccion -replace "'", "''"
    $barrio = $item.barrio -replace "'", "''"
    $precio = $item.precio_mes
    $totales = $item.habitaciones_totales
    $libres = $item.habitaciones_libres
    $casero = $item.nombre_casero -replace "'", "''"
    $contacto = $item.contacto_casero -replace "'", "''"
    $bioCasero = $item.biografia_casero -replace "'", "''"
    $lat = $item.lat
    $lon = $item.lon

    $sqlInsertAloj = @"
INSERT INTO alojamientos (titulo, tipo, direccion, barrio, precio_mes, habitaciones_totales, habitaciones_libres, nombre_casero, contacto_casero, biografia_casero, geom)
VALUES ('$titulo', '$tipo', '$direccion', '$barrio', $precio, $totales, $libres, '$casero', '$contacto', '$bioCasero', ST_SetSRID(ST_MakePoint($lon, $lat), 4326))
RETURNING id;
"@
    $res = & "$dockerPath\docker.exe" exec alojamientos-postgis psql -U loyola_admin -d alojamientos_db -t -A -c $sqlInsertAloj
    $alojId = $res.Trim()

    foreach ($hab in $item.habitaciones) {
        $num = $hab.numero
        $est = $hab.estado
        $precioHab = $hab.precio
        $inq = if ($hab.inquilino) { "'" + ($hab.inquilino -replace "'", "''") + "'" } else { "NULL" }
        $grado = if ($hab.grado) { "'" + ($hab.grado -replace "'", "''") + "'" } else { "NULL" }
        $curso = if ($hab.curso) { $hab.curso } else { "NULL" }
        $bioHab = if ($hab.biografia) { "'" + ($hab.biografia -replace "'", "''") + "'" } else { "NULL" }

        $sqlInsertHab = @"
INSERT INTO habitaciones_convivencia (alojamiento_id, numero_habitacion, estado, precio_habitacion, nombre_estudiante, grado, curso, biografia_convivencia)
VALUES ($alojId, $num, '$est', $precioHab, $inq, $grado, $curso, $bioHab);
"@
        & "$dockerPath\docker.exe" exec alojamientos-postgis psql -U loyola_admin -d alojamientos_db -c $sqlInsertHab | Out-Null
    }
}

Write-Host "¡Los 20 alojamientos y sus habitaciones han sido insertados con exito en PostGIS!" -ForegroundColor Green
