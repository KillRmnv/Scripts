#!/bin/bash
# Gaming пресет для CachyOS / AMD Radeon Vega 7
set -e

echo "=== AMD GPU драйверы (Mesa/Vulkan, уже могут быть) ==="
sudo pacman -S --noconfirm \
  mesa lib32-mesa \
  vulkan-radeon lib32-vulkan-radeon \
  vulkan-icd-loader lib32-vulkan-icd-loader \
  vulkan-mesa-layers lib32-vulkan-mesa-layers \
  xf86-video-amdgpu \
  libva-mesa-driver lib32-libva-mesa-driver \
  mesa-vdpau lib32-mesa-vdpau

echo "=== Wine и совместимость ==="
sudo pacman -S --noconfirm \
  wine-staging winetricks \
  lib32-pipewire lib32-alsa-plugins \
  lib32-libpulse lib32-openal

echo "=== Steam ==="
sudo pacman -S --noconfirm steam

echo "=== Производительность и мониторинг ==="
sudo pacman -S --noconfirm \
  gamemode lib32-gamemode \
  mangohud lib32-mangohud \
  goverlay \
  gamescope \
  corectrl

echo "=== Launchers ==="
sudo pacman -S --noconfirm lutris

echo "=== Торрент-клиент ==="
sudo pacman -S --noconfirm qbittorrent

echo "=== Доп. утилиты ==="
sudo pacman -S --noconfirm \
  sc-controller \
  wine-mono \
  cabextract \
  p7zip

echo "=== Настройка gamemode ==="
sudo usermod -aG gamemode $USER

echo "Готово! Перезайди в сессию для применения gamemode."