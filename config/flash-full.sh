#!/bin/sh

# Secure OpenWRT Flash Script with License Key Validation

# ───────────────────────────────────────────────

# ───────────────────────────────────────────────

SERVER_URL="http://80.225.221.245:7000/get_file"
FIRMWARE_NAME="sysupgrade-full.bin"
TMP_DIR="/tmp/.firmware_flash"
TMP_FILE="$TMP_DIR/$FIRMWARE_NAME"

# ───────────────────────────────────────────────────────────
# Custom Banner
clear
echo "╔═════════════════════════════════════════╗"
echo "║       ╔╗╔╔═╗╔═╗╔╗ ╦ ╦╔═╗╦═╗╔╦╗          ║"
echo "║       ║║║║ ║║ ║╠╩╗║║║╠═╣╠╦╝ ║           ║"
echo "║       ╝╚╝╚═╝╚═╝╚═╝╚╩╝╩ ╩╩╚═ ╩           ║"
echo "╚═════════════════════════════════════════╝"
echo ""
echo "   > NoobWRT - Firmware Flasher (Pro)"
echo "   > Contact  : https://wa.me/94716172860"
echo ""

# Confirm flash
read -p "Press 'y' to continue with firmware flash: " confirm_flash
if [ "$confirm_flash" != "y" ]; then
  echo "Aborted by user."
  exit 0
fi

# Ask for license key
echo -n "Enter your license key: "
read -r LICENSE_KEY

# Prepare environment
echo "Preparing system..."
mkdir -p "$TMP_DIR"

# Download securely
echo " Downloading firmware..."
curl -sSL --fail \
  -H "Authorization: $LICENSE_KEY" \
  "$SERVER_URL?filename=$FIRMWARE_NAME" \
  -o "$TMP_FILE"

if [ $? -ne 0 ]; then
  echo " Connection failed or license key invalid."
  rm -rf "$TMP_DIR"
  exit 1
fi

# Verify file exists
if [ ! -f "$TMP_FILE" ]; then
  echo " Downloaded file missing."
  rm -rf "$TMP_DIR"
  exit 1
fi

# Optional: Validate firmware content
if ! grep -q "OpenWrt" "$TMP_FILE"; then
  echo "Warning: Firmware might be invalid or corrupted."
  read -p "Continue anyway? [y/N]: " confirm
  if [ "$confirm" != "y" ]; then
    rm -rf "$TMP_DIR"
    exit 1
  fi
fi

# Run sysupgrade
echo " Starting flash..."
sysupgrade -n -v "$TMP_FILE"
