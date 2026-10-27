# Script de ejecución completa de las 7 consultas geoespaciales
$dockerPath = "C:\Users\alfon\AppData\Local\Programs\DockerDesktop\resources\bin"
$sqlFile = "c:\Users\alfon\Documents\UNI\TERCERO\1er CUATRI\ADBBDD\TPI\alojamientos-loyola\03_consultas_espaciales.sql"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "EJECUTANDO 03_consultas_espaciales.sql EN POSTGIS" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

Get-Content -Path $sqlFile -Raw -Encoding UTF8 | & "$dockerPath\docker.exe" exec -i alojamientos-postgis psql -U loyola_admin -d alojamientos_db

Write-Host "==========================================================" -ForegroundColor Green
Write-Host "Todas las consultas se han ejecutado con exito." -ForegroundColor Green
Write-Host "Abre mapa_alojamientos.html para ver el mapa interactivo." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
