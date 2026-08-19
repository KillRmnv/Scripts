#!/bin/bash
set -e

echo "=== Установка i3-wm, Polybar, Rofi, Feh, i3lock (Alpine Linux) ==="

apk update && apk upgrade

# Установка компонентов
# В Alpine нет i3-gaps, используем обычный i3 (gaps встроены с v4.19)
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
    xterm \
    font-awesome \
    font-noto-emoji

echo "Готово! Настройка gaps делается в ~/.config/i3/config"
echo "Пример: gaps inner 10; gaps outer 5"