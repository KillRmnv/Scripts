#!/bin/bash

# Установка пакетов через языковые менеджеры (pip, npm, cargo)
# Дистрибутивонезависимо

set -e

echo "=== Python пакеты (pip) ==="
pip install -U "huggingface_hub[cli]"
pip install kaggle

echo "=== NPM глобальные пакеты ==="
npm install -g cline
npm install -g @kilocode/cli
npm install -g @qwen-code/cli

echo "=== Rust/Cargo пакеты ==="
cargo install models

echo "=== Установка Posting через uv ==="
uv tool install --python 3.13 posting

echo "Готово!"
