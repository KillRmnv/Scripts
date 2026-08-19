#!/bin/bash

# Fallback install for Debian / Ubuntu (weak/replacement machine).
# Run with: sudo bash debian.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# При запуске через sudo $USER резолвится как root. Определяем реального
# пользователя, чтобы docker-группа, шрифты и оболочка по умолчанию
# применялись к нему, а не к root.
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

echo "=== Обновление системы ==="
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget gpg apt-transport-https ca-certificates

echo "=== Системные утилиты ==="
sudo apt install -y curl wget gnupg net-tools git build-essential pkg-config libssl-dev openssl tree bat ripgrep fd-find fzf pass jq chafa git-lfs flatpak mitmproxy unzip

# Debian поставит bat как batcat и fd-find как fdfind (конфликт имён).
# Создаём симлинки, чтобы работали привычные команды bat и fd.
[ -x /usr/bin/batcat ] && [ ! -e /usr/local/bin/bat ] && ln -s /usr/bin/batcat /usr/local/bin/bat
[ -x /usr/bin/fdfind ] && [ ! -e /usr/local/bin/fd ]  && ln -s /usr/bin/fdfind /usr/local/bin/fd

echo "=== Языки и SDK ==="
sudo apt install -y python3 python3-pip
sudo apt install -y openjdk-21-jdk
# Системный pip в Debian защищён PEP 668 (EXTERNALLY-MANAGED); обновлять
# его не нужно — всю работу с пакетами выполняет uv.
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "=== pipx ==="
sudo apt update
sudo apt install -y pipx
sudo -u "$REAL_USER" pipx ensurepath

echo "=== Базы данных ==="
sudo apt install -y sqlite3
sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable --now postgresql

echo "=== Редакторы ==="
sudo apt install -y neovim
# zed: нет в apt — ставится через официальный скрипт (для реального юзера,
# иначе попадёт в /root/.local)
sudo -u "$REAL_USER" sh -c 'curl -f https://zed.dev/install.sh | sh'

echo "=== Терминал и Shell ==="
sudo apt install -y fish kitty alacritty

echo "=== DBeaver CE ==="
wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | gpg --dearmor -o /usr/share/keyrings/dbeaver.gpg.key
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt update
sudo apt install -y dbeaver-ce

echo "=== Nerd Font (нет в apt) ==="
mkdir -p "$REAL_HOME/.local/share/fonts"
cd /tmp
wget -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d "$REAL_HOME/.local/share/fonts/"
rm JetBrainsMono.zip
sudo -u "$REAL_USER" fc-cache -f
cd "$SCRIPT_DIR"

echo "=== Docker ==="
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    usermod -aG docker "$REAL_USER"
    rm get-docker.sh
fi

echo "=== Утилиты разработки и мониторинга ==="
sudo apt install -y btop
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo mv lazygit /usr/local/bin/
    rm lazygit.tar.gz
fi
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi
# github-cli через официальный репозиторий
if ! command -v gh &> /dev/null; then
    (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
        && sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt update \
        && sudo apt install gh -y
fi

echo "=== Настройка Fish (по умолчанию) ==="
if ! command -v fish &> /dev/null; then
    sudo apt install -y fish
fi
which fish
echo "/usr/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/bin/fish "$REAL_USER"

echo "=== Внешние инструменты (без пакетного менеджера) ==="
bash "$SCRIPT_DIR/external_tools.sh"

echo "=== Дополнительные инструменты (вне репозиториев) ==="
# windscribe: официальный .deb
if ! command -v windscribe &> /dev/null; then
    wget -O /tmp/windscribe.deb "https://assets.windscribe.com/clients/linux/latest?platform=ubuntu" || true
    sudo dpkg -i /tmp/windscribe.deb || sudo apt -f install -y
    rm -f /tmp/windscribe.deb
fi
# ghgrab-bin: релиз на GitHub (нет в apt) — пробуем, при ошибке пропускаем
if ! command -v ghgrab &> /dev/null; then
    echo "ghgrab-bin недоступен через apt; установите вручную из релиза GitHub (https://github.com/.../ghgrab)."
fi

echo "Готово! Требуется перезагрузка (для группы docker и оболочки по умолчанию)."
