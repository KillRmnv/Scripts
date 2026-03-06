#!/usr/bin/env bash
mkdir -p ~/.config/sway
cat > ~/.config/sway/config << 'EOF'
# ═══════════════════════════════════════════════════════════
# Sway config для Ubuntu 22.04 (Wayland)
# Стек: WezTerm + Fish + Starship + JetBrains Mono + Catppuccin
# ═══════════════════════════════════════════════════════════

# ─── Модификатор (Win/Super) ───────────────────────────────
set $mod Mod4
set $alt Mod1

# ─── Шрифт (JetBrains Mono Nerd Font) ───────────────────────
font pango:JetBrainsMono Nerd Font 15

# ─── Цветовая схема Catppuccin Mocha ────────────────────────
set $bg #1e1e2e
set $fg #cdd6f4
set $accent #89b4fa
set $urgent #f38ba8
set $inactive #6c7086

# ─── Отступы (gaps) ─────────────────────────────────────────
gaps inner 10
gaps outer 5
smart_gaps on

# ─── Панель (Waybar) ────────────────────────────────────────
# Waybar предпочтительнее для Sway
bar {
    swaybar_command waybar
}

# ─── Утилиты (автозапуск) ───────────────────────────────────
# Уведомления (swaync или dunst)
exec swaync

# Сеть в трее
exec nm-applet --indicator

# Polkit (запрос пароля)
exec /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1

# Буфер обмена (wl-clipboard)
exec wl-paste --type text --watch cliphist store
exec wl-paste --type image --watch cliphist store

# Блокировка при простое
exec swayidle -w \
    timeout 300 'swaylock -f -c 1e1e2e' \
    timeout 600 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"'

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

# ─── Скриншоты (Wayland-native) ─────────────────────────────
bindsym $mod+Shift+s exec grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png
bindsym $mod+Print exec grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png

# ─── Блокировка экрана ──────────────────────────────────────
bindsym $mod+Shift+x exec swaylock -c 1e1e2e

# ─── Выход из сессии ────────────────────────────────────────
bindsym $mod+Shift+e exec "swaynag -t warning -m 'Выход из Sway?' -B 'Да' 'swaymsg exit'"

# ─── Перезагрузка конфига ───────────────────────────────────
bindsym $mod+Shift+c reload

# ─── Правила для окон ───────────────────────────────────────
# Плавающие окна по умолчанию
for_window [app_id="pavucontrol"] floating enable
for_window [app_id="nm-connection-editor"] floating enable
for_window [title="Firefox — Sharing Indicator"] floating enable

# ─── Яркость и громкость ────────────────────────────────────
bindsym XF86MonBrightnessUp exec brightnessctl set +5%
bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# ─── Системные ──────────────────────────────────────────────
# Скрыть курсор при простое
exec --no-startup-id swaymsg -t get_inputs | jq -r '.[] | select(.type == "pointer") | .identifier' | xargs -I {} swayinput {} tap enabled

# ─── Завершение ─────────────────────────────────────────────
EOF

echo "✅ Sway config создан: ~/.config/sway/config"
