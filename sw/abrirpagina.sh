#!/bin/bash
# abrir_diario.sh

echo "🚀 Abriendo Diario de Madrid..."

# Obtener directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML_FILE="$SCRIPT_DIR/index.html"

# Verificar si existe index.html
if [ ! -f "$HTML_FILE" ]; then
    echo "❌ Error: No se encontró index.html"
    exit 1
fi

echo "✅ Archivo encontrado: index.html"
echo "🔧 Abriendo Chrome con permisos..."

# Para Linux
if command -v google-chrome &> /dev/null; then
    google-chrome --allow-file-access-from-files --disable-web-security --user-data-dir="/tmp/chrome_dev" "$HTML_FILE"
# Para macOS
elif command -v "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" &> /dev/null; then
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --allow-file-access-from-files --disable-web-security --user-data-dir="/tmp/chrome_dev" "$HTML_FILE"
else
    echo "❌ Chrome no encontrado"
    exit 1
fi

echo "✅ ¡Chrome abierto!"