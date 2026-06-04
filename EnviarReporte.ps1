$MiCorreo        = "gonzalomartinez0369@gmail.com"
$PasswordApp     = "zwlf mvcn jtlu hiku"
$ServidorSMTP    = "smtp.gmail.com"
$PuertoSMTP      = 587

# Apuntamos al archivo suelto en la carpeta actual
$ArchivoReporte = ".\Info_PC.txt"

if (Test-Path $ArchivoReporte) {
    $ConfigCorreo = @{
        From       = $MiCorreo
        To         = $MiCorreo
        Subject    = "Inventario Directo - Equipo: $($env:COMPUTERNAME)"
        Body       = "Se remite el reporte de inventario en texto plano generado en la estación de diagnóstico."
        SmtpServer = $ServidorSMTP
        Port       = $PuertoSMTP
        UseSsl     = $true
        Attachments = $ArchivoReporte
    }

    $PasswordSecure = ConvertTo-SecureString $PasswordApp -AsPlainText -Force
    $Credenciales = New-Object System.Management.Automation.PSCredential ($MiCorreo, $PasswordSecure)

    Write-Host "Enviando reporte por correo..." -ForegroundColor Cyan
    Send-MailMessage @ConfigCorreo -Credential $Credenciales
    Write-Host "Proceso de envío completado con éxito." -ForegroundColor Green
} else {
    Write-Warning "Error: No se localizó el archivo 'Info_PC.txt' para enviar."
}
