param(
  [string]$Destination = "Z:\fylorg"
)

$Source = Split-Path -Parent $MyInvocation.MyCommand.Path
$Exclude = @(
  'build', '.dart_tool', '.git', '.idea', '.agents',
  '*.user', '*.suo', '.vs', '.vscode',
  'android/.gradle', 'ios/Pods', 'ios/.symlinks',
  'windows/runner/resources', 'macos/Runner/App.framework',
  'linux/flutter/ephemeral',
  '*.iml', '.metadata', '.packages', '.flutter-plugins*',
  'pubspec.lock'
)

Write-Host "=== Fylorg - Deploy to Linux Mint ===" -ForegroundColor Cyan
Write-Host "Origen:   $Source" -ForegroundColor White
Write-Host "Destino:  $Destination" -ForegroundColor White
Write-Host ""

if (-not (Test-Path -LiteralPath "Z:\")) {
  Write-Host "ERROR: La unidad Z: no está disponible." -ForegroundColor Red
  Write-Host "Asegurate de que la carpeta compartida de Linux Mint esté mapeada." -ForegroundColor Yellow
  exit 1
}

Write-Host "Copiando proyecto a $Destination ..." -ForegroundColor Green
if (-not (Test-Path -LiteralPath $Destination)) {
  New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}

# Robocopy for fast, reliable mirroring
$robocopyArgs = @(
  $Source, $Destination, "/MIR",
  "/XD", "build", ".dart_tool", ".git", ".idea", ".agents", "fylorg",
         "android", "ios", "windows", "macos", "web", "test",
         "linux/flutter/ephemeral",
  "/XF", "*.iml", ".metadata", ".packages", ".flutter-plugins*",
         "pubspec.lock",
  "/R:1", "/W:1",
  "/NJH", "/NJS", "/NP", "/NDL"
)

$result = robocopy @robocopyArgs
if ($LASTEXITCODE -ge 8) {
  Write-Host "ERROR durante la copia (código: $LASTEXITCODE)" -ForegroundColor Red
  exit 1
}

Write-Host ""
Write-Host "=== Proyecto copiado exitosamente a Z:\fylorg ===" -ForegroundColor Green
Write-Host ""
Write-Host "Pasos para compilar en Linux Mint:" -ForegroundColor Cyan
Write-Host "  1. Accedé a la máquina Linux Mint (local o SSH)" -ForegroundColor White
Write-Host "  2. Navegá a la carpeta compartida:" -ForegroundColor White
Write-Host "     cd /ruta/del/compartido/fylorg" -ForegroundColor Gray
Write-Host "  3. Instalá dependencias (solo la primera vez):" -ForegroundColor White
Write-Host "     sudo apt install libgtk-3-dev cmake ninja-build" -ForegroundColor Gray
Write-Host "  4. Compilá con el script incluido:" -ForegroundColor White
Write-Host "     export DEPLOY_DIR=/ruta/del/compartido/fylorg" -ForegroundColor Gray
Write-Host "     chmod +x build-linux.sh" -ForegroundColor Gray
Write-Host "     ./build-linux.sh" -ForegroundColor Gray
Write-Host "  5. El ejecutable se copia automáticamente a:" -ForegroundColor White
Write-Host "     Z:\fylorg\fylorg   (visible desde Windows)" -ForegroundColor Gray
Write-Host ""
Write-Host "Para ejecutar directamente en Linux Mint:" -ForegroundColor Cyan
Write-Host "  ./build/linux/x64/release/bundle/fylorg" -ForegroundColor Gray
Write-Host "  O el copiado en:  \$DEPLOY_DIR/fylorg" -ForegroundColor Gray
