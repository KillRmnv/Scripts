#!/bin/bash

# Fallback install for Alpine Linux 3.23 (weak/replacement machine).
# Run as root: bash alpine.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Определяем пользователя (при запуске от root это будет root)
REAL_USER="${SUDO_USER:-$(whoami)}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

echo "=== Обновление системы ==="
apk update && apk upgrade

echo "=== Репозитории (community) ==="
ALPINE_VER="$(cat /etc/alpine-release | cut -d. -f1,2)"
COMMUNITY_REPO="http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VER}/community"

# Добавляем community, если его нет
if ! grep -qF "/community" /etc/apk/repositories; then
    sed -i "/\/main/a ${COMMUNITY_REPO}" /etc/apk/repositories
fi

# КРИТИЧЕСКИ ВАЖНО: обновляем индексы после изменения repos
# testing убран, так как в stable ветках он часто отсутствует (404)
apk update

echo "=== Системные утилиты ==="
# || true защищает от падения скрипта, если какой-то пакет недоступен
apk add curl wget gnupg net-tools git build-base pkgconf openssl tree \
    bat fd fzf pass jq git-lfs flatpak mitmproxy unzip chafa || true

echo "=== Языки и SDK ==="
apk add python3 py3-pip openjdk21-jdk || echo "WARNING: openjdk21-jdk not found, trying openjdk17..." && apk add openjdk17-jdk || true

# uv installer
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "=== pipx ==="
python3 -m pip install --user pipx || python3 -m pip install --user --break-system-packages pipx
python3 -m pipx ensurepath || true

echo "=== Базы данных ==="
apk add sqlite postgresql
/etc/init.d/postgresql setup 2>/dev/null || true
rc-update add postgresql default 2>/dev/null || true
rc-service postgresql start 2>/dev/null || true

echo "=== Редакторы ==="
apk add neovim

echo "=== Терминал и Shell ==="
apk add fish kitty alacritty || true

echo "=== Nerd Font ==="
mkdir -p "$REAL_HOME/.local/share/fonts"
cd /tmp
if wget -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"; then
    unzip -o JetBrainsMono.zip -d "$REAL_HOME/.local/share/fonts/" || true
    rm -f JetBrainsMono.zip
else
    echo "WARNING: Failed to download fonts"
fi
fc-cache -f 2>/dev/null || true
cd "$SCRIPT_DIR"

echo "=== Docker ==="
apk add docker docker-compose
rc-update add docker default
rc-service docker start
addgroup "$REAL_USER" docker

echo "=== Утилиты разработки ==="
apk add btop lazygit zoxide github-cli || true

echo "=== Настройка Fish ==="
if command -v fish &> /dev/null; then
    echo "/usr/bin/fish" | tee -a /etc/shells
    chsh -s /usr/bin/fish "$REAL_USER" || true
else
    echo "WARNING: fish not installed, skipping shell config"
fi

echo "=== Внешние инструменты ==="
if [ -f "$SCRIPT_DIR/external_tools.sh" ]; then
    bash "$SCRIPT_DIR/external_tools.sh"
else
    echo "WARNING: external_tools.sh not found in $SCRIPT_DIR"
fi

echo "Готово! Требуется перезагрузка (reboot)."