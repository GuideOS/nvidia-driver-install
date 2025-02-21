These bash-scripts are intended to be used with Debian Bookworm and a NVIDIA-GPU.

Please only use this script when you are using a NVIDIA-GPU.
You need to uninstall previous installed NVIDIA-DRIVERS.

The script itself is doing the following:
Adds contrib and non-free to your sources.list
Adds the Backports-Repository (bookworm-backports)
Then installs the latest backports-kernel and kernel-headers & DKMS & firmware-nonfree

After that the NVIDIA-Keyring is pulled and installed
The NVIDIA Debian 12 Repository is added in /etc/apt/sources.list.d/

Finally you are asked, which driver you want to install: NVIDIA-OPEN or CUDA-DRIVERs (closed source)

Please use at your own risk! 

Best case is: You have a  fresh install of Debian 12 got a NVIDIA-GPU (which is not working properly - no boot to DE) and would like to install a more modern driver.

After Pulling the Repo, you need to make the scripts executeable with: 

chmod +x <scriptname.sh>

Use the sudo version, if you have installed Debian 12 with sudo.

Use the su version, if you are using a regular root-user-account without sudo.

Note: It seems like it is also working with Linux Mint Debian Edition.
