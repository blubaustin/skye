#!/bin/bash
#This script will harden a debian 12 install. Will try to comment as we go. The only thing this script cannot do is pre-install extensions for the browser.
#A list of browser extensions to install will be given
#clearurls ublock origin decentraleyes dark reader (makes everything dark for reading personal prefrence)
sudo add-apt-repository contrib non-free-firmware
sudo apt-get update
sudo apt-get -y upgrade
#installs nessecary packages for: stable diffusion to start, pull from git, kernel compile tools for things
sudo apt-get -y install git build-essential libncurses5-dev zlib1g-dev curl virtualenv python3-virtualenv dkms extrepo nstall dirmngr ca-certificates software-properties-common apt-transport-https dkms
python3 -m venv venv
sudo apt-get -y build-dep linux
sudo extrepo enable librewolf
sudo apt update && sudo apt -y install librewolf vlc
sudo apt-get -y remove firefox
git clone https://github.com/ovh/debian-cis.git
cd debian-cis.git
sudo cp debian/default /etc/default/cis-hardening
sudo git clone https://github.com/ovh/debian-cis.git && cd debian-cis
sudo cp debian/default /etc/default/cis-hardening
sudo sed -i "s#CIS_LIB_DIR=.*#CIS_LIB_DIR='sudo(pwd)'/lib#" /etc/default/cis-hardening
sudo sed -i "s#CIS_CHECKS_DIR=.*#CIS_CHECKS_DIR='sudo(pwd)'/bin/hardening#" /etc/default/cis-hardening
sudo sed -i "s#CIS_CONF_DIR=.*#CIS_CONF_DIR='sudo(pwd)'/etc#" /etc/default/cis-hardening
sudo sed -i "s#CIS_TMP_DIR=.*#CIS_TMP_DIR='sudo(pwd)'/tmp#" /etc/default/cis-hardening
sudo bash bin/hardening.sh --set-hardening-level 1 --audit
sudo bash bin/hardening.sh --set-hardening-level 1 --apply
cd ..
cd /usr/src/
sudo wget https://git.kernel.org/torvalds/t/linux-6.14-rc2.tar.gz
sudo tar xvf linux-6.14-rc2.tar.gz
cd linux-6.14-rc2
sudo wget https://raw.githubusercontent.com/blubskye/skye/refs/heads/main/.config
sudo rm -rf Makefile
sudo wget sudo wget https://raw.githubusercontent.com/blubskye/skye/refs/heads/main/Makefile
sudo make -j5
sudo make -j5 modules_install
sudo make install

##uncomment below for nvidia crap
#sudo curl -fSsL https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/3bf863cc.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nvidia-drivers.gpg > /dev/null 2>&1
#sudo echo 'deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /' | sudo tee /etc/apt/sources.list.d/nvidia-drivers.list
#sudo apt install nvidia-driver cuda nvidia-smi nvidia-settings

echo "Remember to install in librewolf clearurls ublock origin decentraleyes dark reader. Cool."
librewolf --new-tab "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/"
librewolf --new-tab "https://addons.mozilla.org/en-US/firefox/addon/decentraleyes/"
librewolf --new-tab "https://addons.mozilla.org/en-US/firefox/addon/darkreader/"
librewolf --new-tab "https://addons.mozilla.org/en-US/firefox/addon/clearurls/"

echo "Full reboot required for all changes to take effect recommended"
