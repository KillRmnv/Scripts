#!/bin/bash
set -e

echo "=== Установка i3-wm, Polybar, Rofi, Feh, i3lock (Alpine Linux) ==="

# --- ВАЖНО: Подключаем community репозиторий ---
ALPINE_VER="$(cat /etc/alpine-release | cut -d. -f1,2)"
COMMUNITY_REPO="http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VER}/community"

if ! grep -qF "/community" /etc/apk/repositories; then
    echo "$COMMUNITY_REPO" >> /etc/apk/repositories
fi
# -----------------------------------------------

apk update && apk upgrade

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
    xterm \
    font-awesome \
    font-noto-emoji

echo "Готово! Настройка gaps делается в ~/.config/i3/config"