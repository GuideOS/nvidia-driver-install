#!/bin/bash
clear
echo "==TGGs Debian 12 NVIDIA INSTALLER=="
echo "Run the installation using 'su -' as the root user!"
echo "If no root user is set up, please use the script 'nv_debian_upgrade_sudo.sh'!"
su -
# Add contrib and non-free to the repository
echo "Adding 'contrib' and 'non-free' branches to standard repositories..."
apt update && apt install software-properties-common -y
apt-add-repository contrib non-free -y

# Enable backports
echo "Enabling Bookworm-Backports..."
REPO="deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware"
SOURCE_FILE="/etc/apt/sources.list"

if grep -qF "$REPO" "$SOURCE_FILE" || grep -qF "$REPO" /etc/apt/sources.list.d/*.list; then
    echo "The repository is already listed. Skipping this step..."
else
    echo "The repository is not listed. Adding it now..."
    echo "$REPO" | tee -a "$SOURCE_FILE"
fi

# Update system and install kernel
echo "Updating package sources..."
apt update
echo "Installing latest backports kernel & headers, DKMS, and firmware-nonfree..."
apt install -t bookworm-backports -y linux-image-amd64 linux-headers-amd64
apt install -y dkms firmware-misc-nonfree firmware-linux-nonfree
clear
echo "Fetching NVIDIA keyring from NVIDIA server..."
# Fetch NVIDIA keyring
wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
sleep 2

# Install keyring
echo "Installing NVIDIA keyring..."
dpkg -i cuda-keyring_1.1-1_all.deb
sleep 2
apt update
apt -f install
clear

# Add NVIDIA repository
echo "Adding NVIDIA-CUDA repository to /etc/apt/sources.list.d/"
echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /" \
    | tee /etc/apt/sources.list.d/cuda-debian12-x86_64.list
sleep 2

# Driver selection
clear
echo "== DRIVER SELECTION =="
echo "Which Nvidia driver would you like to install?"
echo "1) Open driver (nvidia-open)"
echo "2) Proprietary driver with CUDA (cuda-drivers)"
echo "3) Cancel"

read -p "Please choose an option (1/2/3): " choice

case $choice in
    1)
        echo "Installing the open Nvidia driver..."
        apt install -y nvidia-open
        ;;
    2)
        echo "Installing the proprietary Nvidia driver with CUDA..."
        apt install -y cuda-drivers
        ;;
    3)
        echo "Installation canceled."
        exit 0
        ;;
    *)
        echo "Invalid input. Please choose 1, 2, or 3."
        exit 1
        ;;
esac

# Set backports priority
clear
echo "Creating /etc/apt/preferences.d/backports with Pin-Priority 499..."
echo "Package: *
Pin: release o=Debian Backports,a=stable-backports,n=bookworm-backports
Pin-Priority: 499" | tee /etc/apt/preferences.d/backports
sleep 2
clear
echo "Rebooting system..."
sleep 2
reboot
