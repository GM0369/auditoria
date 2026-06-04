# Módulo Inventario: Recopilación directa en carpeta raíz
$NombrePC = $env:COMPUTERNAME
$Usuario = $env:USERNAME

# Guardado directo sin subcarpetas
$ArchivoReporte = ".\Info_PC.txt"

$SistemaOperativo = (Get-CimInstance Win32_OperatingSystem).Caption
$Arquitectura = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
$ModeloPC = (Get-CimInstance Win32_ComputerSystem).Model
$MarcaPC = (Get-CimInstance Win32_ComputerSystem).Manufacturer
$Procesador = (Get-CimInstance Win32_Processor).Name
$RAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)

$Bateria = Get-CimInstance Win32_Battery
$TipoEquipo = if ($Bateria) { "Notebook" } else { "PC de Escritorio" }

$Discos = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
$DiscoInfo = $Discos | ForEach-Object {
    "Unidad: $($_.DeviceID) - Capacidad: $([math]::Round($_.Size / 1GB, 2)) GB - Libre: $([math]::Round($_.FreeSpace / 1GB, 2)) GB"
}

$Contenido = @"
==========================================
    REPORTE DE INVENTARIO LOGÍSTICO
==========================================
Fecha del Reporte  : $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")
Nombre de la PC    : $NombrePC
Usuario Actual     : $Usuario
Tipo de Equipo     : $TipoEquipo
Marca              : $MarcaPC
Modelo             : $ModeloPC
Procesador         : $Procesador
Memoria RAM        : $RAM GB
Sistema Operativo : $SistemaOperativo ($Arquitectura)
==========================================
    INFORMACIÓN DEL DISCO
==========================================
$DiscoInfo
==========================================
"@

$Contenido | Out-File -FilePath $ArchivoReporte -Encoding utf8
Write-Host "Análisis del sistema volcado en .\Info_PC.txt" -ForegroundColor Green
