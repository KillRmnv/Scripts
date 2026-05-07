#!/bin/bash

# Установка AUR пакетов для Arch Linux / CachyOS
# Требует установленного yay

set -e

if ! command -v yay &> /dev/null; then
    echo "Установка yay..."
    sudo pacman -S --noconfirm yay
fi

echo "=== Установка AUR пакетов ==="

echo "=== Базы данных ==="
yay -S --noconfirm pgadmin4

echo "=== Терминалы ==="
yay -S --noconfirm warp-terminal-bin

echo "=== Утилиты ==="
yay -S --noconfirm oxker-bin

echo "=== AI и ML ==="
yay -S --noconfirm mistral-vibe
yay -S --noconfirm mpvpaper

echo "=== Браузеры ==="
yay -S --noconfirm google-chrome

echo "Готово!"
