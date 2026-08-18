#!/bin/bash

# Fallback install for Arch Linux / CachyOS (weak/replacement machine).
# Mirrors the full package set from Installation/arch_based/main_install.sh
# but is standalone so it can run even if the main setup is broken.
# Run with: sudo bash arch.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# При запуске через sudo $USER резолвится как root. Определяем реального
# пользователя, чтобы docker-группа и оболочка по умолчанию применялись к нему.
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

echo "=== Обновление системы ==="
sudo pacman -Syu --noconfirm

echo "=== Системные утилиты ==="
sudo pacman -S --noconfirm curl wget gnupg net-tools git base-devel pkgconf openssl tree bat ripgrep fd fzf pass jq chafa git-lfs flatpak mitmproxy unzip

echo "=== Языки и SDK ==="
sudo pacman -S --noconfirm python python-pip
sudo pacman -S --noconfirm jdk-openjdk
pip install --upgrade pip
sudo pacman -S --noconfirm uv
sudo pacman -S --noconfirm python-pipx

echo "=== Базы данных ==="
sudo pacman -S --noconfirm sqlite
sudo pacman -S --noconfirm postgresql
sudo systemctl enable --now postgresql

echo "=== Редакторы ==="
sudo pacman -S --noconfirm neovim zed

echo "=== Терминал и Shell ==="
sudo pacman -S --noconfirm fish kitty alacritty
sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd

echo "=== Docker ==="
sudo pacman -S --noconfirm docker docker-compose
sudo systemctl enable --now docker
sudo usermod -aG docker "$REAL_USER"

echo "=== Утилиты разработки и мониторинга ==="
sudo pacman -S --noconfirm btop lazygit zoxide github-cli

echo "=== Настройка Fish (по умолчанию) ==="
which fish
echo "/usr/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/bin/fish "$REAL_USER"

echo "=== Внешние инструменты (без пакетного менеджера) ==="
bash "$SCRIPT_DIR/external_tools.sh"

echo "=== AUR пакеты (через yay) ==="
if ! command -v yay &> /dev/null; then
    echo "Установка yay..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd ~ && rm -rf /tmp/yay
fi
yay -S --noconfirm ghgrab-bin
yay -S --noconfirm windscribe-cli-v2-bin
yay -S --noconfirm dbeaver-bin

echo "Готово! Требуется перезагрузка (для группы docker и оболочки по умолчанию)."
