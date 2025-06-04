#!/bin/bash

set -e

TMP_DIR="$(mktemp -d)"
BIN_PATH="/usr/bin/obsidian"
DESKTOP_FILE="/usr/share/applications/obsidian.desktop"
ICON_PATH="/home/dz/Pictures/app-icons/obsidian.png"

# Step 1: Get the real AppImage URL
echo "[*] Resolving actual download URL..."
REAL_URL=$(curl -Ls "https://obsidian.md/download?platform=linux&arch=x64" |
    grep -oP 'https://github.com/obsidianmd/obsidian-releases/releases/download/[^"]+\.AppImage' | head -n1)

if [[ -z "$REAL_URL" ]]; then
    echo "[!] Failed to extract AppImage URL. Exiting."
    exit 1
fi

# Step 2: Download it
echo "[*] Downloading $REAL_URL"
curl -L "$REAL_URL" -o "$TMP_DIR/Obsidian.AppImage"
chmod +x "$TMP_DIR/Obsidian.AppImage"

# Step 3: Replace binary
echo "[*] Updating /usr/bin/obsidian..."
sudo mv "$TMP_DIR/Obsidian.AppImage" "$BIN_PATH"

# Step 4: Write desktop entry
echo "[*] Writing desktop entry..."
sudo tee "$DESKTOP_FILE" >/dev/null <<EOF
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Obsidian
Comment=Markdown Notes
Icon=$ICON_PATH
Exec=$BIN_PATH
Terminal=false
#--ozone-platform-hint=auto
EOF

rm -rf "$TMP_DIR"
echo "[+] Obsidian updated and installed to /usr/bin/obsidian"
