#!/usr/bin/env bash
# ==========================================
# Arch Linux Full Desktop + Gaming Setup
# Hyprland + SDDM + Epic Games (Heroic)
# ==========================================

set -e

# --------------------------
# ROOT & SYSTEM CHECKS
# --------------------------
if [[ $EUID -ne 0 ]]; then
  echo "Please run this script with sudo"
  exit 1
fi

if ! command -v pacman &>/dev/null; then
  echo "This script is intended for Arch Linux only"
  exit 1
fi

echo "Arch Linux detected"

# --------------------------
# SYSTEM UPDATE
# --------------------------
echo "Updating system"
pacman -Syyu --noconfirm

# --------------------------
# NETWORK (OPTIONAL)
# --------------------------
# nmcli dev wifi connect "SSID" password "PASSWORD"

# --------------------------
# BASE PACKAGES
# --------------------------
echo "Installing base packages"
pacman -S --noconfirm \
  terminus-font \
  git wget curl perl \
  gcc make cmake \
  nano base-devel

# --------------------------
# HYPRLAND SETUP
# --------------------------
echo "Setting up Hyprland"
mkdir -p ~/hyprland_configuration
cd ~/hyprland_configuration

git clone https://github.com/end-4/dots-hyprland
cd dots-hyprland
./install.sh

# --------------------------
# SDDM DISPLAY MANAGER
# --------------------------
echo "Installing SDDM"
pacman -S --noconfirm sddm
systemctl enable sddm

# --------------------------
# ENABLE MULTILIB
# --------------------------
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
  echo "Enabling multilib repository"
  sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
fi

pacman -Sy --noconfirm

# --------------------------
# GAMING DEPENDENCIES
# --------------------------
echo "Installing Wine and Vulkan dependencies"
pacman -S --noconfirm \
  wine wine-mono wine-gecko winetricks \
  gamemode mangohud \
  vulkan-icd-loader lib32-vulkan-icd-loader \
  vulkan-tools \
  mesa lib32-mesa \
  lib32-libpulse lib32-alsa-lib \
  lib32-libxcomposite lib32-libxinerama \
  lib32-libxrandr lib32-libxcursor \
  lib32-libxdamage lib32-libxi \
  lib32-libxtst lib32-libxkbcommon \
  lib32-libdrm

# --------------------------
# HEROIC GAMES LAUNCHER
# --------------------------
echo "Installing Heroic Games Launcher"

if pacman -Si heroic-games-launcher &>/dev/null; then
  pacman -S --noconfirm heroic-games-launcher
else
  echo "Installing yay"
  sudo -u "$SUDO_USER" bash <<EOF
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
EOF

  sudo -u "$SUDO_USER" yay -S --noconfirm heroic-games-launcher-bin
fi

chmod +x /usr/bin/heroic || true

# --------------------------
# EXTRA GAME LAUNCHERS
# --------------------------
echo "Installing additional launchers"
sudo -u "$SUDO_USER" yay -S --noconfirm an-anime-game-launcher-bin

# --------------------------
# FINALIZE
# --------------------------
systemctl start sddm

echo "Installation finished"
echo "Run Heroic using: heroic"
echo "Log in to Epic Games inside Heroic"
echo "Proton-GE is recommended for better performance"
echo "Use Super + / to open the Hyprland cheat sheet"
