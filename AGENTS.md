# AGENTS.md

Personal dotfiles + workstation install scripts. This is a config collection, **not** a software project: there is no build, test, lint, typecheck, or package manifest. Do not invent or run such commands.

## Layout mirrors XDG config paths
Files here map to locations under the user's home, not a single app:
- `IDE/nvim/` → `~/.config/nvim` (Neovim config, entrypoint `init.lua`)
- `Shell/fish/` → `~/.config/fish`; top-level `Shell/bashrc`, `Shell/zsh.sh` → shell rc files
- `Terminal/kitty/`, `Terminal/ghostty/` → `~/.config/kitty`, `~/.config/ghostty`
- `etc/` → misc dotfiles (`starship.toml`, `settings.json`, `userChrome.css`, fonts, hydra)
- `grub/themes`, `hyprshade/shaders`, `wm/niri+noctalia` → window-manager / boot theming

Editing these usually means deploying to the live config path; keep filenames intact (some contain spaces, e.g. `IDE/c++ vs code/`, `IDE/python vs code/`).

## Shell
Fish is the default interactive shell (set by `Installation/arch_based/main_install.sh`). Shell logic lives in `Shell/fish/`; `.fish` functions/completions in `Shell/fish/functions` and `Shell/fish/completions`. Don't assume bash-only syntax when editing fish files.

## Installation scripts (`Installation/`)
Run **in order**; later steps depend on earlier ones.
- Arch/CachyOS: `arch_based/main_install.sh` (pacman, sets Fish default) → `arch_based/aur_packages.sh` (yay/AUR) → `common/language_packages.sh` (pip/npm/cargo; needs those installed first) → `common/llama_cpp.sh` (builds from source).
- Debian/Ubuntu: `debian_based/ubuntu.sh` → optional `debian_based/{gh,fish_ubuntu,jq_ubuntu,wm_de,hyprland}.sh` → `package_managers/install_brew.sh` → `common/language_packages.sh`.
- `common/` scripts assume pip/npm/cargo already present. Most scripts use `sudo` and `set -e`; run them on a real target system, not as a dry exercise.
- Docker needs logout/reboot after install for the `docker` group to take effect.
- `low_end/` is a standalone fallback set (Arch/Debian/Alpine) for when the main system breaks. Each script is self-contained and runs separately (e.g. `sudo bash low_end/arch.sh`); every script auto-calls `external_tools.sh` at the end, so don't run it manually. These are a slimmed-down mirror of `Installation/`, not a sub-step of the main flow.

## Neovim (JVIM)
Java-focused config. Plugins managed by Lazy.nvim (auto-install on first launch). Entrypoint `IDE/nvim/init.lua`; plugin specs in `IDE/nvim/lua/io/github/israiloff/config/`. Lua formatter is `stylua` (installed via Mason). See `IDE/nvim/README.md` for keymaps/troubleshooting.

## Wallpaper engine (`Installation/wallpaper-engine/`)
Known memory leak when switching wallpapers; use `clean.sh` to recover. Install copies a built binary to `/usr/local/bin/`.

## Docs
Authoritative overviews live in `Installation/README.md` (run order) and `Installation/OVERVIEW.md` (full package list). Prefer those over guessing package names.
