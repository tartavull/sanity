#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

APP_NAME="Sanity"
APP_BUNDLE="$APP_NAME.app"
DMG_NAME="$APP_NAME.dmg"
VOLUME_NAME="Sanity Installer"
TEMP_DIR="$SCRIPT_DIR/tmp-dmg"

# Clean previous output
rm -rf "$TEMP_DIR"
rm -f "$DMG_NAME"

# Create temp folder and populate it
mkdir -p "$TEMP_DIR"
cp -R "$APP_BUNDLE" "$TEMP_DIR/"
ln -s /Applications "$TEMP_DIR/Applications"

# Create the DMG
create-dmg \
  --volname "$VOLUME_NAME" \
  --window-size 500 300 \
  --icon "$APP_BUNDLE" 100 100 \
  --icon "Applications" 350 100 \
  "$DMG_NAME" \
  "$TEMP_DIR"

# Cleanup
rm -rf "$TEMP_DIR"

echo "✅ DMG created: $SCRIPT_DIR/$DMG_NAME"
