#!/bin/bash

# Инструменты, устанавливаемые НЕЗАВИСИМО от пакетного менеджера.
# Запускается из каждого дистрибутивного скрипта:
#   bash "$SCRIPT_DIR/external_tools.sh"
# Дистрибутивонезависимо (Arch / Debian / Alpine).
# Большинство — готовые glibc-бинарники; на Alpine (musl) некоторые
# могут не заработать.

set -e

echo "=== Fisher (менеджер плагинов Fish) ==="
if ! fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"; then
    curl -sL https://git.io/fisher | source
    fisher install jorgebucaran/fisher
fi

echo "=== Posting (через uv) ==="
uv tool install --python 3.13 posting || uv tool install posting

echo "=== Superfile (TUI файловый менеджер) ==="
bash -c "$(curl -sLo- https://superfile.dev/install.sh)"

echo "=== Pi (coding agent) ==="
curl -fsSL https://pi.dev/install.sh | sh

echo "=== Fresh (текстовый редактор) ==="
curl https://raw.githubusercontent.com/sinelaw/fresh/refs/heads/master/scripts/install.sh | sh
echo "=== ZED (текстовый редактор) ==="
curl -f https://zed.dev/install.sh | sh

echo "Готово! Внешние инструменты установлены."
