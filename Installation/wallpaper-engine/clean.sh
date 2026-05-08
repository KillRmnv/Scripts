#!/bin/bash
# Скрипт очистки памяти после переключения обоев linux-wallpaperengine

echo "=== Очистка кэша памяти ==="

# 1. Синхронизация буферов на диск
echo "Синхронизация буферов..."
sync

# 2. Показать состояние ДО очистки
echo ""
echo "До очистки:"
free -h | grep "Mem:"

# 3. Очистка dentry/inode cache (самое важное для wallpaper engine)
echo ""
echo "Очистка dentry/inode cache..."
echo 2 | sudo tee /proc/sys/vm/drop_caches > /dev/null

# 4. Показать состояние ПОСЛЕ очистки
sleep 1
echo ""
echo "После очистки:"
free -h | grep "Mem:"

# 5. Показать топ-5 slabs
echo ""
echo "Топ-5 slab объектов:"
sudo cat /proc/slabinfo | awk '{print $1, $2 * $3 / 1048576 " MB"}' | sort -k2 -nr | head -5

echo ""
echo "✓ Готово!"
