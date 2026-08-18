#!/bin/bash
# AUR гейминг пакеты
set -e

echo "=== ProtonGE (кастомный Proton для Steam) ==="
yay -S --noconfirm proton-ge-custom-bin

echo "=== ProtonUp-Qt (обновлялка ProtonGE/Wine-GE) ==="
yay -S --noconfirm protonup-qt

yay -S proton-cachyos-slr

echo "=== Heroic Games Launcher (Epic + GOG + Amazon) ==="
yay -S --noconfirm heroic-games-launcher

echo "=== Eden — Nintendo Switch эмулятор ==="
# eden-nightly-bin — PGO-оптимизированная nightly сборка (рекомендуется)
# yay -S --noconfirm eden-nightly-bin

echo "Готово!"