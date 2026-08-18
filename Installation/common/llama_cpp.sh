#!/bin/bash

# Установка llama.cpp (сборка из исходников)
# Зависимости: cmake, gcc (установлены через pacman)

set -e

echo "=== Сборка llama.cpp ==="
curl -LsSf https://llama.app/install.sh | sh
echo "Готово! Бинарники в ~/app/llama.cpp/build/bin/"