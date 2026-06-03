# =========================================================================
# 1. CONFIGURACIÓN DE TU CORREO (Fijo para cualquier PC)
# =========================================================================
$MiCorreo     = "gonzalomartinez0369@gmail.com"
$PasswordApp  = "zwlf mvcn jtlu hiku"
$ServidorSMTP = "smtp.gmail.com"
$PuertoSMTP   = 587

# =========================================================================
# 2. OBTENCIÓN DE INFORMACIÓN DEL SISTEMA
# =========================================================================
$NombrePC = $env:COMPUTERNAME
$Usuario = $env:USERNAME
$SistemaOperativo = (Get-CimInstance Win32_OperatingSystem).Caption
$Arquitectura = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
$ModeloPC = (Get-CimInstance Win32_ComputerSystem).Model
$MarcaPC = (Get-CimInstance Win32_ComputerSystem).Manufacturer
$Procesador = (Get-CimInstance Win32_Processor).Name
$RAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$Idproducto = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductId).ProductId
$Iddispositivo = (Get-CimInstance Win32_ComputerSystemProduct).UUID

# Determinar si es PC o Notebook (basado en la batería)
$Bateria = Get-CimInstance Win32_Battery
if ($Bateria) {
    $TipoEquipo = "Notebook"
} else {
    $TipoEquipo = "PC de Escritorio"
}

# Obtener información del disco
$Discos = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID, Size, FreeSpace
$DiscoInfo = $Discos | ForEach-Object {
    "Unidad: $($_.DeviceID) - Capacidad: $([math]::Round($_.Size / 1GB, 2)) GB - Libre: $([math]::Round($_.FreeSpace / 1GB, 2)) GB"
}

# Obtener versión de Microsoft Office instalada
$OfficePath = "HKLM:\SOFTWARE\Microsoft\Office"
$OfficeVersions = Get-ChildItem -Path $OfficePath -ErrorAction SilentlyContinue | Select-Object -ExpandProperty PSChildName
$OfficeVersion = "No instalado"
$OfficeEdicion = "N/A"

# Diccionario de versiones de Office
$OfficeDict = @{
    "8.0"  = "Office 97"
    "9.0"  = "Office 2000"
    "10.0" = "Office XP (2002)"
    "11.0" = "Office 2003"
    "12.0" = "Office 2007"
    "14.0" = "Office 2010"
    "15.0" = "Office 2013"
    "16.0" = "Office 2016/2019/365"
}

# Determinar la versión de Office instalada
foreach ($ver in $OfficeVersions) {
    if ($OfficeDict.ContainsKey($ver)) {
        $OfficeVersion = $OfficeDict[$ver]
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Office\$ver\Registration"
        $OfficeEdicion = (Get-ItemProperty -Path "$RegKey\*" -ErrorAction SilentlyContinue).ProductName
        if (!$OfficeEdicion) { $OfficeEdicion = "Edición desconocida" }
        break
    }
}

# =========================================================================
# 3. CREAR EL CONTENIDO DEL INFORME (Se guarda en la variable $Contenido)
# =========================================================================
$Contenido = @"
==========================================
    INFORMACIÓN DEL SISTEMA
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
idproducto        : $Idproducto
iddispositivo     : $Iddispositivo
==========================================
    MICROSOFT OFFICE INSTALADO
==========================================
Versión de Office  : $OfficeVersion
Edición de Office  : $OfficeEdicion

==========================================
    INFORMACIÓN DEL DISCO
==========================================
$DiscoInfo
==========================================
"@

# =========================================================================
# 4. ENVIAR POR EMAIL DIRECTAMENTE DESDE LA MEMORIA
# =========================================================================
$ConfigCorreo = @{
    From       = $MiCorreo
    To         = $MiCorreo
    Subject    = "Reporte - PC: $NombrePC - Usuario: $Usuario"
    Body       = $Contenido                                      # <-- Usa el texto directo de la RAM
    SmtpServer = $ServidorSMTP
    Port       = $PuertoSMTP
    UseSsl     = $true
}

# Cargar las credenciales de forma segura
$PasswordSecure = ConvertTo-SecureString $PasswordApp -AsPlainText -Force
$Credenciales = New-Object System.Management.Automation.PSCredential ($MiCorreo, $PasswordSecure)

# Enviar el correo
Write-Host "Recopilando datos de la PC..." -ForegroundColor Yellow
Write-Host "Enviando reporte directamente a tu email..." -ForegroundColor Cyan
Send-MailMessage @ConfigCorreo -Credential $Credenciales
Write-Host "¡Listo! Correo enviado sin guardar archivos en el disco." -ForegroundColor Green
