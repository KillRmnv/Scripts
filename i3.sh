#!/usr/bin/env bash
mkdir -p ~/.config/i3
cat > ~/.config/i3/config << 'EOF'
# ═══════════════════════════════════════════════════════════
# i3 config для Ubuntu 22.04
# Стек: WezTerm + Fish + Starship + JetBrains Mono + Catppuccin
# ═══════════════════════════════════════════════════════════

# ─── Модификатор (Win/Super) ───────────────────────────────
set $mod Mod4
set $alt Mod1

# ─── Шрифт (JetBrains Mono Nerd Font) ───────────────────────
font pango:JetBrainsMono Nerd Font 15

# ─── Цветовая схема Catppuccin Mocha ────────────────────────
# bg: #1e1e2e | fg: #cdd6f4 | accent: #89b4fa | blue: #89dceb
set $bg #1e1e2e
set $fg #cdd6f4
set $accent #89b4fa
set $urgent #f38ba8
set $inactive #6c7086

# ─── Отступы (gaps) ─────────────────────────────────────────
gaps inner 10
gaps outer 5
smart_gaps on

# ─── Панель (i3bar) ─────────────────────────────────────────
bar {
    position bottom
    font pango:JetBrainsMono Nerd Font 15
    status_command i3status
    colors {
        background $bg
        separator $inactive
        focused_workspace $accent $bg $fg
        active_workspace $accent $bg $fg
        inactive_workspace $bg $bg $inactive
        urgent_workspace $urgent $bg $fg
        binding_mode $urgent $bg $fg
    }
}

# ─── Утилиты (автозапуск) ───────────────────────────────────
# Прозрачность (picom)
exec --no-startup-id picom --backend glx --vsync --experimental-backends

# Уведомления (dunst)
exec --no-startup-id dunst

# Сеть в трее
exec --no-startup-id nm-applet

# Polkit (запрос пароля) - Ubuntu 22.04
exec --no-startup-id /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1

# Буфер обмена
exec --no-startup-id clipmenud

# ─── Терминал и приложения ──────────────────────────────────
# Основной терминал (WezTerm)
bindsym $mod+Return exec wezterm start

# Lazygit
bindsym $mod+g exec wezterm start -- lazygit

# FZF
bindsym $mod+f exec wezterm start -- fzf

# Файловый менеджер
bindsym $mod+e exec nautilus

# Браузер
bindsym $mod+b exec google-chrome-stable

# Cursor IDE
bindsym $mod+c exec cursor

# ─── Управление окнами ──────────────────────────────────────
# Закрыть окно
bindsym $mod+Shift+q kill

# Плавающее окно
bindsym $mod+Shift+space floating toggle

# Фокусировка
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# Перемещение окон
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# Изменение размера (режим)
bindsym $mod+r mode "resize"
mode "resize" {
    bindsym h resize shrink width 10 px
    bindsym j resize grow height 10 px
    bindsym k resize shrink height 10 px
    bindsym l resize grow width 10 px
    bindsym Return mode "default"
    bindsym Escape mode "default"
}

# ─── Рабочие столы ──────────────────────────────────────────
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10

# Перемещение на рабочий стол
bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10

# ─── Скриншоты ──────────────────────────────────────────────
bindsym $mod+Shift+s exec maim -s ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png
bindsym $mod+Print exec maim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png

# ─── Блокировка экрана ──────────────────────────────────────
bindsym $mod+Shift+x exec i3lock -c 1e1e2e

# ─── Выход из сессии ────────────────────────────────────────
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'Выход из i3?' -B 'Да' 'i3-msg exit'"

# ─── Перезагрузка конфига ───────────────────────────────────
bindsym $mod+Shift+c reload

# ─── Правила для окон ───────────────────────────────────────
# Плавающие окна по умолчанию
for_window [class="Pavucontrol"] floating enable
for_window [class="Nm-connection-editor"] floating enable
for_window [title="Firefox — Sharing Indicator"] floating enable

# Прозрачность для WezTerm (если picom не справляется)
for_window [class="WezTerm"] transparency 0.85

# ─── Авто-раскладка для приложений ──────────────────────────
# IDE на весь экран
for_window [class="Cursor" | class="Code" | class="IntelliJ"] layout tabbed

# ─── Системные ──────────────────────────────────────────────
# Всегда включать NumLock
exec --no-startup-id numlockx on

# Скрыть курсор при простое
exec --no-startup-id unclutter -idle 3

# ─── Завершение ─────────────────────────────────────────────
EOF

echo "✅ i3 config создан: ~/.config/i3/config"
