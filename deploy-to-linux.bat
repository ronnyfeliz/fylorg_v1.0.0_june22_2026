@echo off
setlocal enabledelayedexpansion

set SOURCE=%~dp0
set DEST=Z:\fylorg

echo === Fylorg - Deploy to Linux Mint ===
echo Origen:  %SOURCE%
echo Destino: %DEST%
echo.

if not exist Z:\ (
    echo ERROR: La unidad Z: no esta disponible.
    echo Asegurate de que la carpeta compartida de Linux Mint este mapeada.
    pause
    exit /b 1
)

if exist "%DEST%" (
    echo Eliminando destino anterior...
    rmdir /s /q "%DEST%" 2>nul
)

echo Copiando proyecto a %DEST% ...
mkdir "%DEST%" 2>nul

rem Usamos robocopy para copia rapida
robocopy "%SOURCE%" "%DEST%" /MIR ^
    /XD build .dart_tool .git .idea .agents ^
       android\.gradle ios\Pods ios\.symlinks ^
       windows\runner\resources macos\Runner\App.framework ^
       linux\flutter\ephemeral ^
    /XF *.iml .metadata .packages .flutter-plugins* ^
       pubspec.lock ^
    /NJH /NJS /NP /NDL

if %ERRORLEVEL% geq 8 (
    echo ERROR durante la copia.
    pause
    exit /b 1
)

echo.
echo === Proyecto copiado exitosamente a Z:\fylorg ===
echo.
echo Pasos para compilar en Linux Mint:
echo   1. Accede a la maquina Linux Mint (local o SSH)
echo   2. Navega a la carpeta compartida:
echo      cd /ruta/del/compartido/fylorg
echo   3. Instala dependencias (solo la primera vez):
echo      sudo apt install libgtk-3-dev cmake ninja-build
echo   4. Compila:
echo      flutter pub get
echo      flutter build linux
echo   5. El ejecutable estara en:
echo      build/linux/x64/release/bundle/fylorg
echo      (accesible desde Windows en Z:\fylorg\build\...)
echo.
echo Para ejecutar directamente en Linux Mint:
echo   ./build/linux/x64/release/bundle/fylorg
echo.
pause
