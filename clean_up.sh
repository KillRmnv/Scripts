# Google Chrome кэш
sudo rm -rf ~/.cache/google-chrome
sudo rm -rf ~/.config/google-chrome/Default/Cache

# Cursor IDE кэш
sudo rm -rf ~/.config/Cursor/User/workspaceStorage
sudo rm -rf ~/.cursor/extensions

# VSCode кэш
sudo rm -rf ~/.vscode/extensions

# Временные файлы
sudo echo "🗑️ Временные файлы..."
sudo rm -rf /tmp/*
sudo rm -rf ~/.cache/*

sudo journalctl --vacuum-time=2weeks  # Оставить логи за 2 недели
sudo apt clean                        # Очистка кеша пакетов apt
sudo apt autoremove                   # Удаление ненужных зависимостей

# Очистка старых логов в /var/log
sudo find /var/log -type f -name "*.log.*" -delete
sudo find /var/log -type f -name "*.gz" -delete

