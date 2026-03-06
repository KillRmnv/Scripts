#!/usr/bin/env bash
mkdir -p ~/.config/picom
cat > ~/.config/picom/picom.conf << 'EOF'
# ═══════════════════════════════════════════════════════════
# Picom config с БЛЮРОМ для i3
# Catppuccin Mocha + WezTerm прозрачность
# ═══════════════════════════════════════════════════════════

# ─── Бэкенд (GLX для лучшей производительности) ────────────
backend = "glx";
vsync = true;
glx-no-stencil = true;
glx-copy-from-front = false;
use-damage = true;

# ─── БЛЮР (dual_kawase — лучший баланс качество/скорость) ──
blur = {
    method = "dual_kawase";
    strength = 8;           # Сила блюра (4-12, чем больше — тем размытее)
    background = false;     # Не размивать фон рабочего стола
    blur_kern = "3x3box";   # Ядро размытия
    deviation = 5.0;
};

# ─── Прозрачность ───────────────────────────────────────────
opacity-rule = [
    "85:class_g = 'WezTerm'",
    "85:class_g = 'ghostty'",
    "90:class_g = 'Alacritty'",
    "100:class_g = 'Cursor'",
    "100:class_g = 'Code'",
    "100:class_g = 'IntelliJ'",
    "100:class_g = 'firefox'",
    "100:class_g = 'google-chrome'"
];

# ─── Тени ───────────────────────────────────────────────────
shadow = true;
shadow-radius = 14;
shadow-opacity = 0.4;
shadow-offset-x = -12;
shadow-offset-y = -12;
shadow-exclude = [
    "name = 'Notification'",
    "class_g = 'Conky'",
    "class_g ?= 'Notify-osd'",
    "class_g = 'Cairo-clock'",
    "class_g = 'i3bar'",
    "class_g = 'Dunst'",
    "_GTK_FRAME_EXTENTS@:c"
];

# ─── Сглаживание ────────────────────────────────────────────
smoothing = true;
corner-radius = 10;

# ─── Исключения для блюра (чтобы не тормозило) ─────────────
blur-background-exclude = [
    "window_type = 'dock'",
    "window_type = 'desktop'",
    "class_g = 'i3bar'",
    "class_g = 'Dunst'",
    "class_g = 'Polybar'",
    "_GTK_FRAME_EXTENTS@:c",
    "class_g = 'firefox' && argb",
    "class_g = 'Cursor'",
    "class_g = 'Code'"
];

# ─── Fading (плавное появление/исчезновение) ────────────────
fading = true;
fade-in-step = 0.03;
fade-out-step = 0.03;
fade-delta = 5;

# ─── Исключения для окон ────────────────────────────────────
wintypes:
{
    tooltip = { 
        fade = true; 
        shadow = true; 
        opacity = 0.9; 
        focus = true; 
        full-shadow = false; 
    };
    dock = { 
        shadow = false; 
        clip-shadow-above = true; 
    };
    dnd = { 
        shadow = false; 
    };
    popup_menu = { 
        opacity = 0.9; 
        shadow = true; 
    };
    dropdown_menu = { 
        opacity = 0.9; 
        shadow = true; 
    };
};
EOF

echo "✅ Picom config с блюром создан: ~/.config/picom/picom.conf"
