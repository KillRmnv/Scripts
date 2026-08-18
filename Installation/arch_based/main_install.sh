#!/bin/bash

# Основной скрипт установки для Arch Linux / CachyOS
# Только pacman пакеты

set -e

echo "=== Обновление системы ==="
sudo pacman -Syu --noconfirm
sudo pacman -S octopi
echo "=== Системные утилиты ==="
sudo pacman -S --noconfirm curl wget gnupg net-tools git base-devel pkgconf openssl tree chafa bat ripgrep fd fzf pass jq git-lfs flatpak

echo "=== Разработка: Языки и SDK ==="
sudo pacman -S --noconfirm python python-pip python-virtualenv
sudo pacman -S --noconfirm jdk21-openjdk jdk-openjdk
sudo pacman -S --noconfirm maven gradle
sudo pacman -S --noconfirm nodejs-lts-jod npm
sudo pacman -S --noconfirm rustup
rustup install stable

echo "=== Сборочные инструменты ==="
sudo pacman -S --noconfirm cmake ninja meson

echo "=== Базы данных ==="
sudo pacman -S --noconfirm postgresql dbeaver

echo "=== Редакторы и IDE ==="
sudo pacman -S --noconfirm neovim zed obsidian texlive-meta

echo "=== Терминал и Shell ==="
sudo pacman -S --noconfirm fish starship kitty

echo "=== Утилиты разработки и мониторинга ==="
sudo pacman -S --noconfirm docker docker-compose btop lazygit superfile tealdeer zoxide dust github-cli

echo "=== AI и ML (uv, opencode) ==="
sudo pacman -S --noconfirm uv opencode

echo "=== Медиа и прочее ==="
sudo pacman -S --noconfirm wireshark-qt mpv klavaro
sudo pacman -S mitmproxy

echo "=== Шрифты ==="
sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd

echo "=== Рабочий стол ==="
# sudo pacman -S --noconfirm niri cachyos-niri-settings
# sudo pacman -S --noconfirm hyprland
curl -fsSL https://install.danklinux.com | sh
sudo pacman -S adw-gtk-theme

echo "=== Screen recording packages ==z="
sudo pacman -S gpu-screen-recorder xdg-desktop-portal xdg-desktop-portal-wlr

echo "=== Настройка Docker ==="
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

echo "=== Настройка Fish ==="
which fish
echo "/usr/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/bin/fish

echo "=== Настройка Fisher ==="
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

# Скачать git.fish от bobthecow и положить в completions
curl -o ~/.config/fish/completions/git.fish \
  https://raw.githubusercontent.com/bobthecow/git-flow-completion/master/git.fish
echo "Готово! Требуется перезагрузка."

sudo pacman -S waypaper