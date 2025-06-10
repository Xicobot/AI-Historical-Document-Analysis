@echo off
title Lanzador Diario de Madrid
echo.
echo 🚀 Abriendo Diario de Madrid con permisos especiales...
echo.

REM Obtener la ruta del directorio actual donde está este archivo
set "CURRENT_DIR=%~dp0"

REM Ruta al archivo index.html (mismo directorio que este .bat)
set "HTML_FILE=%CURRENT_DIR%index.html"

REM Verificar si existe index.html
if not exist "%HTML_FILE%" (
    echo ❌ Error: No se encontró index.html en esta carpeta
    echo    Asegúrate de que este archivo .bat esté en la misma carpeta que index.html
    echo.
    pause
    exit /b 1
)

echo ✅ Archivo encontrado: index.html
echo 🔧 Configurando Chrome con permisos de archivos locales...

REM Lanzar Chrome con permisos y abrir la página directamente
"C:\Program Files\Google\Chrome\Application\chrome.exe" --allow-file-access-from-files --disable-web-security --user-data-dir="%TEMP%\chrome_diario_dev" "%HTML_FILE%"

REM Si la ruta estándar no funciona, intentar con Chrome (x86)
if %ERRORLEVEL% neq 0 (
    echo 🔄 Intentando ruta alternativa de Chrome...
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --allow-file-access-from-files --disable-web-security --user-data-dir="%TEMP%\chrome_diario_dev" "%HTML_FILE%"
)

REM Si ninguna funciona
if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ No se pudo encontrar Chrome en las rutas estándar
    echo.
    echo 📋 Rutas probadas:
    echo    - C:\Program Files\Google\Chrome\Application\chrome.exe
    echo    - C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
    echo.
    echo 💡 Soluciones:
    echo    1. Instala Google Chrome si no lo tienes
    echo    2. O edita este archivo y cambia la ruta a Chrome
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ ¡Chrome abierto con éxito!
echo 📄 El Diario de Madrid debería cargarse automáticamente
echo.
echo 💡 Nota: Se creó un perfil temporal para evitar conflictos
echo    Puedes cerrar esta ventana si todo funciona bien
echo.
pause