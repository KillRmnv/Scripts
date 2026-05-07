# Installation Scripts

Коллекция скриптов для автоматической настройки рабочей станции разработчика.

## Структура

- `package_managers/` — Установка дополнительных пакетных менеджеров (Homebrew).
- `arch_based/` — Скрипты для Arch Linux / CachyOS.
- `debian_based/` — Скрипты для Debian / Ubuntu.
- `common/` — Дистрибутивонезависимые установки (через pip, npm, cargo).

---

## Последовательность запуска

### Для Arch Linux / CachyOS

1. **Установка основных пакетов (Pacman):**
   ```bash
   ./arch_based/main_install.sh
   ```
   *Устанавливает: системные утилиты, языки (Python, JDK, Node, Rust), БД, редакторы, Docker, шрифты, Hyprland, Starship, Fish и др.*

2. **Установка AUR пакетов (Yay):**
   ```bash
   ./arch_based/aur_packages.sh
   ```
   *Устанавливает: pgadmin4, warp-terminal, oxker-bin, mistral-vibe, mpvpaper, google-chrome.*

3. **Установка языковых пакетов (Pip, NPM, Cargo):**
   ```bash
   ./common/language_packages.sh
   ```
   *Требует: python-pip, npm, rust/cargo (установлены на шаге 1).*
   *Устанавливает: huggingface_hub, kaggle, cline, kilocode, qwen-code, models, posting.*

4. **Сборка специфичных утилит:**
   ```bash
   ./common/llama_cpp.sh
   ```
   *Сборка llama.cpp из исходников.*

---

### Для Debian / Ubuntu

1. **Основной скрипт установки:**
   ```bash
   ./debian_based/ubuntu.sh
   ```
   *Устанавливает основные пакеты через apt, Docker, Python, Java, Node.js и т.д.*

2. **Дополнительные утилиты (по необходимости):**
   ```bash
   ./debian_based/gh_ubuntu.sh      # GitHub CLI
   ./debian_based/fish_ubuntu.sh    # Fish Shell + Fisher
   ./debian_based/jq_ubuntu.sh      # jq (JSON processor)
   ./debian_based/wm_de.sh          # KDE Plasma
   ./debian_based/hyprland.sh       # Hyprland
   ```

3. **Homebrew (опционально):**
   ```bash
   ./package_managers/install_brew.sh
   ```

4. **Общие скрипты (Pip, NPM, Cargo):**
   ```bash
   ./common/language_packages.sh
   ```

---

## Примечания

- Скрипты `common/` предполагают, что соответствующие менеджеры (pip, npm, cargo) уже установлены в системе.
- Для корректной работы Docker после установки может потребоваться перезагрузка или выход из системы (чтобы применилась группа docker).
- Скрипт `arch_based/main_install.sh` настраивает Fish как оболочку по умолчанию.
