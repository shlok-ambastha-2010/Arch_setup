#!/usr/bin/env bash
set -e

echo "==> Installing base development & utility packages"
sudo pacman -S --noconfirm \
  base-devel \
  git wget curl \
  gcc make cmake \
  perl \
  nano \
  terminus-font

echo "==> Ensuring yay is installed"
if ! command -v yay &>/dev/null; then
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
fi

echo "==> Installing AUR applications"
yay -S --noconfirm \
  zen-browser-bin \
  an-anime-game-launcher-bin

echo "==> Installing Flatpak"
sudo pacman -S --noconfirm flatpak

echo "==> Base helper setup complete"
echo "==> You can now proceed with end-4 dots installation manually"
