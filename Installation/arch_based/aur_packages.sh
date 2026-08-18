#!/bin/bash

# Установка AUR пакетов для Arch Linux / CachyOS
# Требует установленного yay

set -e

if ! command -v yay &> /dev/null; then
    echo "Установка yay..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd ~ && rm -rf /tmp/yay
fi

echo "=== Установка AUR пакетов ==="

echo "=== Базы данных ==="
yay -S --noconfirm pgadmin4

# echo "=== Терминалы ==="
# yay -S --noconfirm warp-terminal-bin

echo "=== Утилиты ==="
yay -S --noconfirm oxker-bin

echo "=== AI и ML ==="
yay -S --noconfirm mpvpaper

echo "=== Браузеры ==="
yay -S --noconfirm google-chrome

echo "=== LM Studio ==="
yay -S lmstudio-bin

echo "=== Windscribe ==="
yay -S windscribe-cli-v2-bin


echo "=== github cli file downloader ==="
yay -S ghgrab-bin   

echo "=== Wallpaper Engine ==="
yay -S linux-wallpaperengine-git

# yay -S hydra-launcher-bin
echo "Готово!"
