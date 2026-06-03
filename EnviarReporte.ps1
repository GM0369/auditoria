# =========================================================================
# SCRIPT 2: ENVIADOR DE REPORTES (Módulo Inventario Limpio)
# =========================================================================

$MiCorreo        = "gonzalomartinez0369@gmail.com"
$PasswordApp     = "zwlf mvcn jtlu hiku"
$ServidorSMTP    = "smtp.gmail.com"
$PuertoSMTP      = 587

# Rutas de trabajo relativas a la carpeta ScriptsSistemas
$CarpetaInventario = ".\Inventario"
$ArchivoZip        = ".\Inventario.zip"

if (Test-Path $CarpetaInventario) {
    # Remover ZIP previo si existe para evitar duplicados
    if (Test-Path $ArchivoZip) { Remove-Item $ArchivoZip -Force }

    Write-Host "Comprimiendo la carpeta Inventario..." -ForegroundColor Yellow
    # Compresión nativa de la carpeta
    Compress-Archive -Path $CarpetaInventario -DestinationPath $ArchivoZip -Force

    # Configuración del correo con el adjunto
    $ConfigCorreo = @{
        From       = $MiCorreo
        To         = $MiCorreo
        Subject    = "Inventario Consolidado - Equipo: $($env:COMPUTERNAME)"
        Body       = "Adjunto se remite el paquete comprimido de la carpeta Inventario generada en la estación de diagnóstico."
        SmtpServer = $ServidorSMTP
        Port       = $PuertoSMTP
        UseSsl     = $true
        Attachments = $ArchivoZip
    }

    # Credenciales seguras para Gmail
    $PasswordSecure = ConvertTo-SecureString $PasswordApp -AsPlainText -Force
    $Credenciales = New-Object System.Management.Automation.PSCredential ($MiCorreo, $PasswordSecure)

    Write-Host "Enviando correo con el inventario..." -ForegroundColor Cyan
    Send-MailMessage @ConfigCorreo -Credential $Credenciales
    Write-Host "Proceso de envío completado con éxito." -ForegroundColor Green
} else {
    Write-Warning "Error: No se localizó la carpeta 'Inventario' para procesar."
}
