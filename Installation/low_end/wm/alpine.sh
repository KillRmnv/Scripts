#!/bin/bash
set -e

echo "=== Установка i3, Polybar, Rofi, Feh, i3lock (Alpine Linux) ==="

 apk update &&  apk upgrade

# Установка компонентов
 apk add \
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
 apk add font-awesome font-noto-emoji

echo "Готово! В Alpine обычно используют startx. Добавьте 'exec i3' в ~/.xinitrc"