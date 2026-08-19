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

echo "=== Репозитории (community + testing) ==="
ALPINE_VER="$(cat /etc/alpine-release | cut -d. -f1,2)"
COMMUNITY_REPO="http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VER}/community"
TESTING_REPO="http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VER}/testing"

# Добавляем community, если его нет
if ! grep -qF "/community" /etc/apk/repositories; then
    # Добавляем после строки с /main
    sed -i "/\/main/a ${COMMUNITY_REPO}" /etc/apk/repositories
fi

# Добавляем testing, если его нет
if ! grep -qF "/testing" /etc/apk/repositories; then
    echo "${TESTING_REPO}" >> /etc/apk/repositories
fi

# КРИТИЧЕСКИ ВАЖНО: обновляем индексы после изменения repos
apk update

echo "=== Системные утилиты ==="
# В Alpine 3.23 эти пакеты лежат в community. 
# Используем || true, чтобы не прерывать скрипт при отсутствии одного пакета.
apk add curl wget gnupg net-tools git build-base pkgconf openssl tree \
    bat fd fzf pass jq git-lfs flatpak mitmproxy unzip chafa || true

echo "=== Языки и SDK ==="
apk add python3 py3-pip openjdk21-jdk

# uv installer
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "=== pipx ==="
python3 -m pip install --user pipx || python3 -m pip install --user --break-system-packages pipx
python3 -m pipx ensurepath

echo "=== Базы данных ==="
apk add sqlite postgresql
/etc/init.d/postgresql setup 2>/dev/null || true
rc-update add postgresql default 2>/dev/null || true
rc-service postgresql start 2>/dev/null || true

echo "=== Редакторы ==="
apk add neovim

echo "=== Терминал и Shell ==="
apk add fish kitty alacritty

echo "=== Nerd Font ==="
mkdir -p "$REAL_HOME/.local/share/fonts"
cd /tmp
wget -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
unzip -o JetBrainsMono.zip -d "$REAL_HOME/.local/share/fonts/" || true
rm -f JetBrainsMono.zip
fc-cache -f 2>/dev/null || true
cd "$SCRIPT_DIR"

echo "=== Docker ==="
apk add docker docker-compose
rc-update add docker default
rc-service docker start
addgroup "$REAL_USER" docker

echo "=== Утилиты разработки ==="
apk add btop lazygit zoxide github-cli

echo "=== Настройка Fish ==="
which fish
echo "/usr/bin/fish" | tee -a /etc/shells
chsh -s /usr/bin/fish "$REAL_USER" || true

echo "=== Внешние инструменты ==="
if [ -f "$SCRIPT_DIR/external_tools.sh" ]; then
    bash "$SCRIPT_DIR/external_tools.sh"
else
    echo "WARNING: external_tools.sh not found in $SCRIPT_DIR"
fi

echo "Готово! Требуется перезагрузка (reboot)."