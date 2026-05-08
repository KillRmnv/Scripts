#!/bin/bash

# Установка пакетов через языковые менеджеры (pip, npm, cargo)
# Дистрибутивонезависимо

set -e

echo "=== NPM глобальные пакеты ==="
sudo npm install -g cline
sudo npm install -g @kilocode/cli

echo "=== Установка Posting через uv ==="
uv tool install --python 3.13 posting

echo "Готово!"
