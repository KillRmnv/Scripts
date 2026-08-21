#!/bin/bash

# Fallback install for Void Linux (replacement for Arch Linux setup).
# Run with: sudo bash void-setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# При запуске через sudo $USER резолвится как root. Определяем реального
# пользователя, чтобы docker-группа и оболочка по умолчанию применялись к нему.
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

echo "=== Обновление системы ==="
sudo xbps-install -Su --yes

echo "=== Системные утилиты ==="
sudo xbps-install -Sy --yes curl wget gnupg net-tools git base-devel pkgconf openssl tree bat ripgrep fd fzf pass jq unzip xtools

echo "=== Языки и SDK ==="
sudo xbps-install -Sy --yes python3 python3-pip
sudo xbps-install -Sy --yes openjdk17
sudo xbps-install -Sy --yes python3-pipx
sudo pipx ensurepath

# Устанавливаем uv через pipx (рекомендуемый способ)
sudo -u "$REAL_USER" pipx install uv

echo "=== Базы данных ==="
sudo xbps-install -Sy --yes sqlite
sudo xbps-install -Sy --yes postgresql
# В Void нужно инициализировать БД вручную
#
# Создаем каталог от root
sudo mkdir -p /var/lib/postgres
# Меняем владельца на postgres
sudo chown postgres:postgres /var/lib/postgres
# Устанавливаем правильные права
sudo chmod 700 /var/lib/postgres
if [ ! -d /var/lib/postgres/data ]; then
    sudo -u postgres initdb -D /var/lib/postgres/data
fi
# Включаем PostgreSQL через runit
sudo ln -s /etc/sv/postgresql /var/service/

echo "=== Редакторы ==="
sudo xbps-install -Sy --yes neovim

echo "=== Терминал и Shell ==="
sudo xbps-install -Sy --yes fish-shell kitty alacritty
sudo xbps-install -Sy --yes font-jetbrains-mono

echo "=== Docker ==="
sudo xbps-install -Sy --yes docker docker-compose
sudo ln -s /etc/sv/docker /var/service/
sudo usermod -aG docker "$REAL_USER"

echo "=== Утилиты разработки и мониторинга ==="
sudo xbps-install -Sy --yes btop lazygit zoxide github-cli

echo "=== Настройка Fish (по умолчанию) ==="
which fish
echo "/usr/bin/fish" | sudo tee -a /etc/shells
sudo chsh -s /usr/bin/fish "$REAL_USER"

echo "=== Внешние инструменты (без пакетного менеджера) ==="
if [ -f "$SCRIPT_DIR/external_tools.sh" ]; then
    bash "$SCRIPT_DIR/external_tools.sh"
fi

echo "=== AUR-подобные пакеты (установка из исходников) ==="
sudo xbps-install -Sy --yes dbeaver

echo "=== Дополнительные пакеты из репозиториев ==="
# Некоторые полезные пакеты, которых не было в основном списке
sudo xbps-install -Sy --yes htop tmux xclip

echo "Готово! Требуется перезагрузка (для группы docker и оболочки по умолчанию)."
