#!/bin/bash
set -e

echo "=== Установка i3-gaps, Polybar, Rofi, Feh, i3lock (Arch Linux) ==="

# Обновление системы
sudo pacman -Syu --noconfirm

# Установка базовых компонентов
sudo pacman -S --noconfirm \
    i3-wm \
    polybar \
    rofi \
    feh \
    i3lock \
    picom \
    dunst \
    xorg-xinit \
    xorg-server \
    xterm

# Дополнительно: шрифты для иконок в Polybar/Rofi
sudo pacman -S --noconfirm ttf-font-awesome noto-fonts-emoji

echo "Готово! Не забудьте добавить 'exec i3' в ~/.xinitrc"