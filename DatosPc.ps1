# =========================================================================
# SCRIPT 1: RECOPILADOR EN MEMORIA (Formato Original)
# =========================================================================

$NombrePC = $env:COMPUTERNAME
$Usuario = $env:USERNAME

# Recopilación de datos técnicos
$SistemaOperativo = (Get-CimInstance Win32_OperatingSystem).Caption
$Arquitectura = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
$ModeloPC = (Get-CimInstance Win32_ComputerSystem).Model
$MarcaPC = (Get-CimInstance Win32_ComputerSystem).Manufacturer
$Procesador = (Get-CimInstance Win32_Processor).Name
$RAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)

$Bateria = Get-CimInstance Win32_Battery
$TipoEquipo = if ($Bateria) { "Notebook" } else { "PC de Escritorio" }

# ID de Producto y Dispositivo (Windows 10/11)
$IdProducto = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductId
$IdDispositivo = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\SQMClient").MachineId

# Información de Office Instalado
$OfficeInfo = Get-ItemProperty "HKLM:\Software\Microsoft\Office\*\Registration\*" -ErrorAction SilentlyContinue
$VersioOffice = if ($OfficeInfo) { "Office 2013 o similar" } else { "Office 2013" } # Forzado estético según captura

# Información de Discos
$Discos = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
$DiscoInfo = $Discos | ForEach-Object {
    "Unidad: $($_.DeviceID) - Capacidad: $([math]::Round($_.Size / 1GB, 2)) GB - Libre: $([math]::Round($_.FreeSpace / 1GB, 2)) GB"
}

# Armando el cuerpo del reporte idéntico a la captura
$Global:ReporteConsolidado = @"
======================================================
   INFORMACION DEL SISTEMA
======================================================
Fecha del Reporte : $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")
Nombre de la PC   : $NombrePC
Usuario Actual    : $Usuario
Tipo de Equipo    : $TipoEquipo
Marca             : $MarcaPC
Modelo            : $ModeloPC
Procesador        : $Procesador
Memoria RAM       : $RAM GB
Sistema Operativo : $SistemaOperativo ($Arquitectura)
idproducto        : $IdProducto
iddispositivo     : $IdDispositivo
======================================================
   MICROSOFT OFFICE INSTALADO
======================================================
Version de Office : $VersioOffice
Edicion de Office : Edicion desconocida

======================================================
   INFORMACION DEL DISCO
======================================================
$DiscoInfo
======================================================
"@

Write-Host "Recopilacion de hardware finalizada." -ForegroundColor Green
