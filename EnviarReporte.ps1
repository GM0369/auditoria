# =========================================================================
# SCRIPT 2: ENVIADOR DIRECTO AL CUERPO DEL EMAIL
# =========================================================================

$MiCorreo        = "gonzalomartinez0369@gmail.com"
$PasswordApp     = "zwlf mvcn jtlu hiku"
$ServidorSMTP    = "smtp.gmail.com"
$PuertoSMTP      = 587

if ($Global:ReporteConsolidado) {
    # Configuración del correo inyectando la variable en el Body
    $ConfigCorreo = @{
        From       = $MiCorreo
        To         = $MiCorreo
        Subject    = "Reporte de sistema - ($($env:COMPUTERNAME))"
        Body       = $Global:ReporteConsolidado
        SmtpServer = $ServidorSMTP
        Port       = $PuertoSMTP
        UseSsl     = $true
    }

    $PasswordSecure = ConvertTo-SecureString $PasswordApp -AsPlainText -Force
    $Credenciales = New-Object System.Management.Automation.PSCredential ($MiCorreo, $PasswordSecure)

    Write-Host "Enviando reporte directamente al cuerpo del correo..." -ForegroundColor Cyan
    Send-MailMessage @ConfigCorreo -Credential $Credenciales
    Write-Host "Proceso de envio completado con exito." -ForegroundColor Green
} else {
    Write-Warning "Error: No se encontraron datos en la memoria para enviar."
}
