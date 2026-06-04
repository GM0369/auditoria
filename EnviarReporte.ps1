$MiCorreo        = "gonzalomartinez0369@gmail.com"
$PasswordApp     = "zwlf mvcn jtlu hiku"
$ServidorSMTP    = "smtp.gmail.com"
$PuertoSMTP      = 587

# Apuntamos al archivo suelto que generó el Script 1
$ArchivoReporte = ".\Info_PC.txt"

if (Test-Path $ArchivoReporte) {
    # Leemos el texto del archivo para meterlo adentro del cuerpo del mail
    $TextoDelReporte = Get-Content -Path $ArchivoReporte -Raw

    # Configuración del correo con el texto directo en el cuerpo (Body)
    $ConfigCorreo = @{
        From       = $MiCorreo
        To         = $MiCorreo
        Subject    = "Inventario Directo - Equipo: $($env:COMPUTERNAME)"
        Body       = $TextoDelReporte
        SmtpServer = $ServidorSMTP
        Port       = $PuertoSMTP
        UseSsl     = $true
    }

    $PasswordSecure = ConvertTo-SecureString $PasswordApp -AsPlainText -Force
    $Credenciales = New-Object System.Management.Automation.PSCredential ($MiCorreo, $PasswordSecure)

    Write-Host "Enviando reporte directo al cuerpo del correo..." -ForegroundColor Cyan
    Send-MailMessage @ConfigCorreo -Credential $Credenciales
    Write-Host "Proceso de envío completado con éxito." -ForegroundColor Green
} else {
    Write-Warning "Error: No se localizó el archivo 'Info_PC.txt' para enviar."
}
