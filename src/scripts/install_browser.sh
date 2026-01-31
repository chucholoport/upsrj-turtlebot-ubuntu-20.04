#!/bin/bash

set -e

echo "==== WEB BROWSER INSTALLER ===="
echo

echo "[1] Updating system..."
sudo apt update -y
echo 

if ! command -v snap >/dev/null 2>&1; then
	echo "[2] Installing snapd..."
	sudo apt install -y snapd
	sudo systemctl enable snapd
	sudo systemctl start snapd
else
	echo "[2] snapd already installed"
fi
echo

echo "[3] Installing Firefox"
sudo snap install firefox
echo 

#echo "[4] Installing Chromium"
#sudo snap install chromium
#echo

echo "[5] Verifying installation..."
if command -v firefox >/dev/null 2>&1; then
	echo "Firefox installed."
else
	echo "Firefox not found."
fi
echo

echo "==== DONE ===="
