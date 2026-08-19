#!/bin/bash
set -e

echo "=== Установка i3-gaps, Polybar, Rofi, Feh, i3lock (Debian/Ubuntu) ==="

sudo apt update && sudo apt upgrade -y

# Установка компонентов
sudo apt install -y \
    i3 \
    polybar \
    rofi \
    feh \
    i3lock \
    picom \
    dunst \i3 debian
    xinit \
    xserver-xorg \
    xterm

# Шрифты для красоты
sudo apt install -y fonts-font-awesome fonts-noto-color-emoji

echo "Готово! Не забудьте добавить 'exec i3' в ~/.xinitrc"