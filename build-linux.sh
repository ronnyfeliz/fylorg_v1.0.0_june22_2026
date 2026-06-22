#!/bin/bash
# ============================================================
# build-linux.sh - Compila Fylorg para Linux
# ============================================================
# Uso:
#   ./build-linux.sh
#
# El ejecutable se copia automáticamente al directorio raíz
# del proyecto, visible desde Windows como Z:\fylorg\fylorg
#
# Para copiar a otra ubicación:
#   DEPLOY_DIR=/ruta/personalizada ./build-linux.sh
# ============================================================

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

BINARY_NAME="fylorg"
BUILD_MODE="release"
DEPLOY_DIR="${DEPLOY_DIR:-$PROJECT_DIR}"

cd "$PROJECT_DIR"

echo "=== Fylorg - Build Linux ==="
echo "Modo:    $BUILD_MODE"
echo "Destino: $DEPLOY_DIR"
echo ""

# 1. Compilar
echo "→ Compilando..."
flutter build linux --$BUILD_MODE
echo "  ✅ Build exitoso"
echo ""

# 2. Copiar el ejecutable al directorio de deploy
BUNDLE_DIR="build/linux/x64/$BUILD_MODE/bundle"
BINARY_PATH="$BUNDLE_DIR/$BINARY_NAME"

if [ ! -f "$BINARY_PATH" ]; then
  echo "ERROR: No se encontró $BINARY_PATH"
  exit 1
fi

echo "→ Copiando $BINARY_NAME a $DEPLOY_DIR ..."
cp "$BINARY_PATH" "$DEPLOY_DIR/$BINARY_NAME"
echo "  ✅ Copiado: $DEPLOY_DIR/$BINARY_NAME"
echo ""

# 3. Mostrar resultado
echo "=== Resumen ==="
echo "Ejecutable: $DEPLOY_DIR/$BINARY_NAME"
echo "Tamaño:     $(du -h "$DEPLOY_DIR/$BINARY_NAME" | cut -f1)"
echo ""

# 4. Hacer ejecutable
chmod +x "$PROJECT_DIR/$BINARY_NAME" "$0"
