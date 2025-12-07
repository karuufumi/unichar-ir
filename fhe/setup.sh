#!/usr/bin/env bash

set -e  # stop on error

echo "======================================"
echo "   Microsoft SEAL Local Installer"
echo "   Project-local installation to ./include and ./lib"
echo "======================================"

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

SEAL_VERSION="4.1.1"
SEAL_REPO="https://github.com/microsoft/SEAL.git"
SEAL_DIR="$PROJECT_ROOT/third_party/SEAL"
INSTALL_PREFIX="$PROJECT_ROOT"

echo "Project root: $PROJECT_ROOT"
echo "Install prefix: $INSTALL_PREFIX"
echo ""

# -------------------------------
# 1) Clone SEAL if missing
# -------------------------------
if [ ! -d "$SEAL_DIR" ]; then
  echo "🔍 SEAL source not found. Cloning..."
  mkdir -p "$PROJECT_ROOT/third_party"
  git clone --recursive "$SEAL_REPO" "$SEAL_DIR"
else
  echo "✔️  SEAL source found: $SEAL_DIR"
fi

echo ""

# -------------------------------
# 2) Build SEAL
# -------------------------------
echo "🔧 Building SEAL..."
cd "$SEAL_DIR"
rm -rf build
cmake -S . -B build -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX"
cmake --build build --config Release

echo ""

# -------------------------------
# 3) Install SEAL locally
# -------------------------------
echo "📦 Installing SEAL to:"
echo "  include/"
echo "  lib/"
echo ""

cmake --install build --config Release

echo ""

# -------------------------------
# 4) Verify installation
# -------------------------------
echo "🔍 Verifying installation..."

CONFIG_FILE="$PROJECT_ROOT/lib/cmake/SEAL-4.1/SEALConfig.cmake"

if [ -f "$CONFIG_FILE" ]; then
  echo "🎉 SEAL installation successful!"
  echo "   Found: lib/cmake/SEAL-4.1/SEALConfig.cmake"
else
  echo "❌ ERROR: SEALConfig.cmake not found!"
  echo "   Installation did not complete correctly."
  exit 1
fi

echo ""
echo "======================================"
echo "   SEAL is now installed locally!"
echo "   You can now build with CMake."
echo "======================================"