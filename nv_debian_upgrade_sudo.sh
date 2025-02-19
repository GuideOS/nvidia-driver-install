#!/bin/bash
clear
echo "==TGGs Debian 12 NVIDIA INSTALLER=="
echo "Es muss sudo aktiv und installiert sein!"
# Repository um contrib und non-free erweitern
sudo apt-add-repository contrib non-free -y >/dev/null 2>&1

# Backports aktivieren
REPO="deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware"
SOURCE_FILE="/etc/apt/sources.list"

if grep -qF "$REPO" "$SOURCE_FILE" 2>/dev/null || grep -qF "$REPO" /etc/apt/sources.list.d/*.list 2>/dev/null; then
    echo "Das Repository ist bereits eingetragen. Überspringe diesen Schritt..." >/dev/null
else
    echo "Das Repository ist nicht eingetragen. Es wird hinzugefügt..." >/dev/null
    echo "$REPO" | sudo tee -a "$SOURCE_FILE" >/dev/null 2>&1
fi

# System aktualisieren und Kernel installieren
sudo apt update >/dev/null 2>&1
sudo apt install -y linux-image-6.12.9+bpo-amd64 linux-headers-6.12.9+bpo-amd64 dkms firmware-misc-nonfree firmware-linux-nonfree >/dev/null 2>&1

clear
# Nvidia Keyring holen
wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb >/dev/null 2>&1
sleep 5

# Keyring installieren
sudo dpkg -i cuda-keyring_1.1-1_all.deb 2>&1
sleep 3
sudo apt update >/dev/null 2>&1
sudo apt -f install >/dev/null 2>&1
clear

# NVIDIA Repository eintragen
echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /" \
    | sudo tee /etc/apt/sources.list.d/cuda-debian12-x86_64.list >/dev/null 2>&1
sleep 3

# Driverauswahl
echo "Welche Nvidia-Treiber möchtest du installieren?"
echo "1) Offener Treiber (nvidia-open)"
echo "2) Proprietärer Treiber mit CUDA (nvidia-driver nvidia-cuda-toolkit)"
echo "3) Abbrechen"

read -p "Bitte wähle eine Option (1/2/3): " choice

case $choice in
    1)
        echo "Installiere den offenen Nvidia-Treiber..." >/dev/null
        sudo apt install -y nvidia-open >/dev/null 2>&1
        ;;
    2)
        echo "Installiere den proprietären Nvidia-Treiber mit CUDA..." >/dev/null
        sudo apt install -y nvidia-driver nvidia-cuda-toolkit >/dev/null 2>&1
        ;;
    3)
        echo "Installation abgebrochen." >/dev/null
        exit 0
        ;;
    *)
        echo "Ungültige Eingabe. Bitte wähle 1, 2 oder 3." 1>&2
        exit 1
        ;;
esac

echo "Installation abgeschlossen -- SYSTEM NEU STARTEN BITTE!"

