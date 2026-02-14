#!/bin/bash
set -euo pipefail

#updating
sudo pacman -Syu --noconfirm

#installing base software
sudo pacman -S base-devel curl git go fakeroot  --noconfirm

#yay
sudo -u "$SUDO_USER" git clone https://aur.archlinux.org/yay.git /tmp/yay
sudo -u "$SUDO_USER" bash -c 'cd /tmp/yay && makepkg -si --noconfirm'
rm -rf /tmp/yay

#syncthing
sudo pacman -S syncthing --noconfirm
sudo systemctl enable --now "syncthing@$SUDO_USER.service"
sudo systemctl status "syncthing@$SUDO_USER.service" --no-pager

sudo -u "$SUDO_USER" mkdir -p "/home/$SUDO_USER/.shared/{Keepass,Obsidian}"

#software
sudo pacman -S obsidian keepassxc fish firefox uv zed jupyterlab rust docker solaar tmux micro --noconfirm

#fish
su - "$SUDO_USER" -c "chsh -s \"\$(which fish)\""

#nekoray
yay -S sing-geoip-db sing-geoip-db sing-geosite-db --noconfirm

sudo -u "$SUDO_USER" git clone https://aur.archlinux.org/nekoray-bin.git /tmp/nekoray
sudo -u "$SUDO_USER" bash -c 'cd /tmp/nekoray/ && makepkg -si --noconfirm'
rm -rf /tmp/nekoray

#miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
sudo -u "$SUDO_USER" bash Miniconda3-latest-Linux-x86_64.sh -b -p "/home/$SUDO_USER/.miniconda3"
sudo -wu "$SUDO_USER" ~/.miniconda3/bin/conda init bash
sudo -u "$SUDO_USER" ~/.miniconda3/bin/conda init fish

rm Miniconda3-latest-Linux-x86_64.sh

#flatpak
sudo pacman -S flatpak --noconfirm
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#flatpak-apps
sudo flatpak install flathub org.gnome.Boxes -y
flatpak install flathub com.discordapp.Discord -y
