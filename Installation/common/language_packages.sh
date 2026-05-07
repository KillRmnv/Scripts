#!/bin/bash

# Установка пакетов через языковые менеджеры (pip, npm, cargo)
# Дистрибутивонезависимо

set -e

echo "=== NPM глобальные пакеты ==="
npm install -g cline
npm install -g @kilocode/cli

echo "=== Установка Posting через uv ==="
uv tool install --python 3.13 posting

echo "Готово!"
