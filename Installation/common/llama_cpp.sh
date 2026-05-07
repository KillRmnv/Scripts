#!/bin/bash

# Установка llama.cpp (сборка из исходников)
# Зависимости: cmake, gcc (установлены через pacman)

set -e

echo "=== Сборка llama.cpp ==="
mkdir -p ~/app
cd ~/app
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
mkdir -p build && cd build
cmake .. -DLLAMA_AVX2=ON -DLLAMA_F16C=ON -DLLAMA_FMA=ON -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release -j12

echo "Готово! Бинарники в ~/app/llama.cpp/build/bin/"