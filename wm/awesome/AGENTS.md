# Awesome WM Config

Modular config: `rc.lua` entry point, modules in `config/`.

- **No build/test/lint**: this is Lua config, not a software project.
- **Apply changes**: restart awesome with `Mod4+Control+R` (hard reload) or the menu (soft reload).
- **Modules**:
  - `config/variables.lua` — theme, terminal, editor, modkey, keyboard layouts, layouts table
  - `config/menu.lua` — main menu, launcher widget, menubar
  - `config/wibar.lua` — status bar, per-screen widgets, wallpaper
  - `config/widgets.lua` — net speed, RAM, CPU, battery widgets (3s update)
  - `config/keybindings.lua` — global keys, client keys, tag keys, mouse bindings
  - `config/rules.lua` — client rules
  - `config/signals.lua` — client signals, titlebars, focus
- **Keybindings**: `Mod4+Q` close, `Mod4+B` open Firefox, `Mod4+Return` terminal.
- **Screenshots**: `Mod4+Print` full, `Mod4+Shift+Print` select, `+Ctrl` for clipboard. Requires `maim` + `xclip`.
- **Keyboard layouts**: `us,ru` with `Alt+Shift` toggle.
- **Default layout**: dwindle (first in layouts table).
