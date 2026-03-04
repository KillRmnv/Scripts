# ═══════════════════════════════════════════════════════════
# bobthefish + Catppuccin Mocha
# ═══════════════════════════════════════════════════════════

# 🎨 Цветовая схема
set -g theme_color_scheme dark

# 🔧 Иконки (требуется Nerd Font — у вас JetBrainsMono Nerd Font ✅)
set -g theme_nerd_fonts yes

# 🧹 Чистый вид: курсор на новой строке
set -g theme_newline_cursor yes

# 👤 Пользователь: показывать только при SSH
set -g theme_display_user ssh

# 🖥️ Хостнейм: скрывать на локальной машине
set -g theme_hide_hostname yes

# 📂 Путь: сокращать длинные пути
set -g fish_prompt_pwd_dir_length 2

# 🐙 Git: показывать статус (ветка, изменения)
set -g theme_display_git yes
set -g theme_display_git_dirty yes
set -g theme_display_git_untracked yes
set -g theme_display_git_ahead_verbose yes

# 🐍 Python virtualenv
set -g theme_display_virtualenv yes

# ⏱️ Время выполнения команды (справа)
set -g theme_display_cmd_duration yes

# ═══════════════════════════════════════════════════════════
# Catppuccin Mocha цвета (ручная настройка)
# ═══════════════════════════════════════════════════════════

# Базовые цвета Catppuccin Mocha
set -g catppuccin_base       '#1e1e2e'   # Фон
set -g catppuccin_surface0   '#313244'   # Вторичный фон
set -g catppuccin_surface1   '#45475a'   # Третичный фон
set -g catppuccin_text       '#cdd6f4'   # Текст
set -g catppuccin_subtext0   '#a6adc8'   # Вторичный текст
set -g catppuccin_blue       '#89b4fa'   # Акцент (синий)
set -g catppuccin_red        '#f38ba8'   # Ошибка
set -g catppuccin_green      '#a6e3a1'   # Успех / Git clean
set -g catppuccin_yellow     '#f9e2af'   # Предупреждение
set -g catppuccin_mauve      '#cba6f7'   # Git branch
set -g catppuccin_teal       '#94e2d5'   # Путь

# Применяем цвета к