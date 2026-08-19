#!/bin/bash
set -e

echo "=== Установка i3, Polybar, Rofi, Feh, i3lock (Alpine Linux) ==="

sudo apk update && sudo apk upgrade

# Установка компонентов
sudo apk add \
    i3 \
    polybar \
    rofi \
    feh \
    i3lock \
    picom \
    dunst \
    xinit \
    xorg-server \
    xterm

# Шрифты
sudo apk add font-awesome font-noto-emoji

echo "Готово! В Alpine обычно используют startx. Добавьте 'exec i3' в ~/.xinitrc"