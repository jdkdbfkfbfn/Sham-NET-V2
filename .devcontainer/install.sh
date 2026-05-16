#!/bin/sh
set -eu
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
echo "Downloading latest Xray-core..."
# Use latest stable release
wget -O "${TMP_DIR}/xray.zip" https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip "${TMP_DIR}/xray.zip" -d "${TMP_DIR}"
chmod +x "${TMP_DIR}/xray"
mv "${TMP_DIR}/xray" /usr/local/bin/xray
echo "Xray-core installed successfully!"
