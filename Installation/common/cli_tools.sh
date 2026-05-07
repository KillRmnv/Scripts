#!/bin/bash

# Установка утилит (дистрибутивонезависимо)
# tldr (через pacman в Arch, но оставлено для совместимости)
# starship (в Arch через pacman, но скрипт универсальный)

set -e

echo "=== Установка Starship (если нет в PATH) ==="
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh
fi

echo "=== Установка Superfile (если нет в PATH) ==="
if ! command -v superfile &> /dev/null; then
    bash -c "$(curl -sLo- https://superfile.dev/install.sh)"
fi

curl -fsSL https://pi.dev/install.sh | sh

curl -LsSf https://hf.co/cli/install.sh | bash

echo "Готово!"