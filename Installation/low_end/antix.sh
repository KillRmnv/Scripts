#!/bin/bash

# Fallback install for antiX (sysVinit) – адаптировано из оригинального скрипта.
# Run with: sudo bash debian-antix.sh   (или от root)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Определяем реального пользователя (даже при sudo)
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

# Проверяем, есть ли systemd (в antiX его нет)
if command -v systemctl &>/dev/null; then
    echo "⚠️  Обнаружен systemd – используем systemctl"
    USE_SYSTEMD=true
else
    echo "✅ sysVinit / runit – используем service и update-rc.d"
    USE_SYSTEMD=false
fi

# Функция для запуска/включения сервисов
start_service() {
    local svc="$1"
    if [ "$USE_SYSTEMD" = true ]; then
        systemctl enable --now "$svc" 2>/dev/null || true
    else
        service "$svc" start 2>/dev/null || true
        update-rc.d "$svc" enable 2>/dev/null || true
    fi
}

echo "=== Обновление системы ==="
apt update && apt upgrade -y
apt install -y curl wget gpg software-properties-common apt-transport-https ca-certificates

echo "=== Системные утилиты ==="
apt install -y curl wget gnupg net-tools git build-essential pkg-config libssl-dev openssl tree bat ripgrep fd-find fzf pass jq chafa git-lfs flatpak mitmproxy unzip

# Симлинки для bat и fd (как в оригинале)
[ -x /usr/bin/batcat ] && [ ! -e /usr/local/bin/bat ] && ln -s /usr/bin/batcat /usr/local/bin/bat
[ -x /usr/bin/fdfind ] && [ ! -e /usr/local/bin/fd ]  && ln -s /usr/bin/fdfind /usr/local/bin/fd

echo "=== Языки и SDK ==="
apt install -y python3 python3-pip
apt install -y openjdk-21-jdk
# Устанавливаем uv для реального пользователя (не root)
sudo -u "$REAL_USER" sh -c 'curl -LsSf https://astral.sh/uv/install.sh | sh'

echo "=== pipx ==="
apt install -y pipx
sudo -u "$REAL_USER" pipx ensurepath

echo "=== Базы данных ==="
apt install -y sqlite3
apt install -y postgresql postgresql-contrib
start_service postgresql

echo "=== Редакторы ==="
apt install -y neovim
sudo -u "$REAL_USER" sh -c 'curl -f https://zed.dev/install.sh | sh'

echo "=== Терминал и Shell ==="
apt install -y fish kitty alacritty

echo "=== DBeaver CE ==="
wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | gpg --dearmor -o /usr/share/keyrings/dbeaver.gpg.key
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | tee /etc/apt/sources.list.d/dbeaver.list
apt update
apt install -y dbeaver-ce

echo "=== Nerd Font (нет в apt) ==="
mkdir -p "$REAL_HOME/.local/share/fonts"
cd /tmp
wget -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d "$REAL_HOME/.local/share/fonts/"
rm JetBrainsMono.zip
sudo -u "$REAL_USER" fc-cache -f
cd "$SCRIPT_DIR"

echo "=== Docker (адаптировано для sysVinit) ==="
if ! command -v docker &> /dev/null; then
    # Устанавливаем docker.io из репозиториев Debian (работает с sysVinit)
    apt install -y docker.io
    usermod -aG docker "$REAL_USER"
    start_service docker
fi

echo "=== Утилиты разработки и мониторинга ==="
apt install -y btop
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    mv lazygit /usr/local/bin/
    rm lazygit.tar.gz
fi
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi
# github-cli через официальный репозиторий (работает без systemd)
if ! command -v gh &> /dev/null; then
    (type -p wget >/dev/null || (apt update && apt install wget -y)) \
        && mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && mkdir -p -m 755 /etc/apt/sources.list.d \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && apt update \
        && apt install gh -y
fi

echo "=== Настройка Fish (по умолчанию) ==="
if ! command -v fish &> /dev/null; then
    apt install -y fish
fi
which fish
echo "/usr/bin/fish" | tee -a /etc/shells
chsh -s /usr/bin/fish "$REAL_USER"

# Внешние инструменты – если есть файл external_tools.sh, запускаем
if [ -f "$SCRIPT_DIR/external_tools.sh" ]; then
    echo "=== Внешние инструменты (без пакетного менеджера) ==="
    bash "$SCRIPT_DIR/external_tools.sh"
else
    echo "⚠️  Файл external_tools.sh не найден – пропускаем"
fi

echo "=== Дополнительные инструменты (вне репозиториев) ==="
# windscribe: официальный .deb (не зависит от systemd)
if ! command -v windscribe &> /dev/null; then
    wget -O /tmp/windscribe.deb "https://assets.windscribe.com/clients/linux/latest?platform=ubuntu" || true
    dpkg -i /tmp/windscribe.deb || apt -f install -y
    rm -f /tmp/windscribe.deb
fi
# ghgrab-bin – пропускаем, так как нет в репозиториях
if ! command -v ghgrab &> /dev/null; then
    echo "ghgrab-bin недоступен через apt; установите вручную из релиза GitHub."
fi

echo "Готово! Требуется перезагрузка (для группы docker и оболочки по умолчанию)."