param(
  [int]$Port = 8443,
  [string]$JwtSecret = "THIS_IS_A_DEMO_SECRET_WITH_MORE_THAN_32_CHARACTERS",
  [string]$AllowedOrigins = "http://localhost:8080,https://localhost:8080",
  [switch]$NoSsl
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$backendPath = Join-Path $repoRoot "server2-spring"
$jarPath = Join-Path $backendPath "target\secureapp-0.0.1-SNAPSHOT.jar"
$keystorePath = Join-Path $backendPath "keystore.p12"

Write-Host "[1/4] Verificando puerto $Port..."
$conn = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
if ($null -ne $conn) {
  $pidToKill = $conn[0].OwningProcess
  Write-Host "      Puerto ocupado por PID $pidToKill. Finalizando proceso..."
  Stop-Process -Id $pidToKill -Force
  Start-Sleep -Seconds 1
}

Write-Host "[2/4] Verificando jar..."
if (-not (Test-Path $jarPath)) {
  Write-Host "      Jar no encontrado, compilando con Maven..."
  Push-Location $backendPath
  mvn -DskipTests package
  Pop-Location
}

Write-Host "[3/4] Configurando variables de entorno..."
$env:SERVER_PORT = "$Port"
$env:JWT_SECRET = $JwtSecret
$env:APP_ORIGINS = $AllowedOrigins

if ($NoSsl.IsPresent) {
  $env:SERVER_SSL_ENABLED = "false"
} else {
  $env:SERVER_SSL_ENABLED = "true"
  if (-not (Test-Path $keystorePath)) {
    throw "No existe keystore en $keystorePath. Genera uno antes de usar SSL."
  }
  $env:SSL_KEY_STORE = "keystore.p12"
  $env:SSL_KEY_STORE_PASSWORD = "changeit"
}

Write-Host "[4/4] Iniciando backend en server2-spring..."
Push-Location $backendPath
java -jar $jarPath
Pop-Location
