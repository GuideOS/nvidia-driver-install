# NVIDIA-Driver Setup for Debian Bookworm

These bash scripts are intended for use with **Debian Bookworm** and an **NVIDIA GPU**.
Please only use these scripts if you are using an NVIDIA GPU.

![Bild](https://github.com/GuideOS/nvidia-driver-install/blob/main/screenshot.png?raw=true)

> **Important:** You need to uninstall any previously installed NVIDIA drivers before using these scripts.

## Script Functionality

The script performs the following tasks:

1. Adds `contrib` and `non-free` repositories to your `sources.list`.
2. Installs the latest kernel, kernel headers, DKMS, and firmware non-free.
3. Pulls and installs the **NVIDIA Keyring**.
4. Adds the **NVIDIA Debian 12 Repository** to `/etc/apt/sources.list.d/`.
5. Prompts you to choose between installing either the **NVIDIA Open Driver** or the **CUDA Drivers** (closed-source).

## Usage

**Please use at your own risk!**

The best use case is for a fresh installation of **Debian 12** with an **NVIDIA GPU** (which is not working properly, e.g., no boot to the desktop environment), and you want to install a more modern driver.

## Build for OpenBuildService

```
dpkg-source --build ./
```
## Build Local

```
dpkg-buildpackage -us -uc
```

## Install

```
sudo apt install ./tgg-nvidia
```

## Usage

```
sudo tgg-nvidia
```


