#!/bin/bash

# Fallback install for Alpine Linux (weak/replacement machine).
# Run as root: bash alpine.sh
#
# ВНИМАНИЕ: Alpine использует musl (не glibc). Некоторые инструменты
# распространяются только в виде готовых glibc-бинарников и на Alpine
# не ставятся. Ниже они оставлены КОММЕНТАРИЯМИ с пояснением.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# При запуске без sudo SUDO_USER пуст, поэтому берем текущего (root)
REAL_USER="${SUDO_USER:-$(whoami)}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

echo "=== Обновление системы ==="
apk update && apk upgrade

echo "=== Репозитории (community + testing) ==="
ALPINE_RELEASE="$(cat /etc/alpine-release 2>/dev/null)"
ALPINE_VER="$(echo "$ALPINE_RELEASE" | cut -d. -f1,2)"

# Определяем, Edge это или стабильная версия
if echo "$ALPINE_RELEASE" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+-.*-g[0-9a-f]+$'; then
    # Это Edge — используем edge/ вместо v3.XX/
    BASE_URL="http://dl-cdn.alpinelinux.org/alpine/edge"
else
    # Стабильная версия — используем v3.XX/
    BASE_URL="http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VER}"
fi

COMMUNITY_REPO="${BASE_URL}/community"
TESTING_REPO="${BASE_URL}/testing"

# Добавляем community
if ! grep -qF "/community" /etc/apk/repositories; then
    sed -i "s|/main|/main\n${COMMUNITY_REPO}|" /etc/apk/repositories
fi

# Добавляем testing
if ! grep -qF "/testing" /etc/apk/repositories; then
    echo "${TESTING_REPO}" >> /etc/apk/repositories
fi

# ОБЯЗАТЕЛЬНО обновляем индексы
apk update

echo "=== Системные утилиты ==="
# Исправленные имена пакетов для Alpine v3.24:
apk add curl wget gnupg net-tools git build-base pkgconf openssl tree \
    bat fd fzf pass jq git-lfs flatpak mitmproxy unzip chafa || true

echo "=== Языки и SDK ==="
apk add python3 py3-pip openjdk21

# Системный pip в Alpine защищён PEP 668 (EXTERNALLY-MANAGED); обновлять
# его не нужно — всю работу с пакетами выполняет uv.
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "=== pipx ==="
# На Alpine pipx ставится через pip --user
python3 -m pip install --user pipx || python3 -m pip install --user --break-system-packages pipx
python3 -m pipx ensurepath

echo "=== Базы данных ==="
apk add sqlite postgresql
/etc/init.d/postgresql setup 2>/dev/null || true
rc-update add postgresql default 2>/dev/null || true
rc-service postgresql start 2>/dev/null || true

echo "=== Редакторы ==="
apk add neovim
# zed: НЕТ пакета для Alpine и готовый бинарь требует glibc -> поставить нельзя.
# dbeaver: НЕТ пакета для Alpine (Java GUI) -> ставится через flatpak/flathub

echo "=== Терминал и Shell ==="
apk add fish kitty alacritty

echo "=== Nerd Font (нет в apk) ==="
mkdir -p "$REAL_HOME/.local/share/fonts"
cd /tmp
wget -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d "$REAL_HOME/.local/share/fonts/" || true
rm -f JetBrainsMono.zip
fc-cache -f 2>/dev/null || true
cd "$SCRIPT_DIR"

echo "=== Docker ==="
apk add docker docker-compose
rc-update add docker default
rc-service docker start
addgroup "$REAL_USER" docker

echo "=== Утилиты разработки и мониторинга ==="
apk add btop lazygit zoxide github-cli

echo "=== Настройка Fish (по умолчанию) ==="
which fish
echo "/usr/bin/fish" | tee -a /etc/shells
chsh -s /usr/bin/fish "$REAL_USER" || true

echo "=== Внешние инструменты (без пакетного менеджера) ==="
bash "$SCRIPT_DIR/external_tools.sh"

echo "=== Инструменты вне репозиториев Alpine ==="
# windscribe: НЕТ пакета для Alpine и готовый бинарь требует glibc -> поставить нельзя.
# ghgrab-bin: НЕТ пакета для Alpine -> поставить нельзя.

echo "Готово! Требуется перезагрузка (для группы docker и оболочки по умолчанию)."