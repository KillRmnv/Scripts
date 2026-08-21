#!/bin/bash

# Установка пакетов через языковые менеджеры (pip, npm, cargo)
# Дистрибутивонезависимо

set -e

echo "=== Установка Posting через uv ==="
uv tool install --python 3.13 posting

pipx install ghgrab
echo "Готово!"
