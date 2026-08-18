# Установка на слабое / запасное железо (fallback)

Набор скриптов для развёртывания рабочей станции на случай, если основная
система сломается. Копия пакетного набора из `Installation/`, разбитая по
дистрибутивам. Каждый скрипт самодостаточен и запускается отдельно.

## Использование

```bash
sudo bash arch.sh      # Arch Linux / CachyOS
sudo bash debian.sh    # Debian / Ubuntu
sudo bash alpine.sh    # Alpine Linux
```

Каждый скрипт в конце вызывает `external_tools.sh` (инструменты вне
пакетного менеджера), поэтому запускать его вручную не нужно.

## Состав (одинаков для всех дистрибутивов)

- Базовые утилиты: curl wget gnupg net-tools git build-tools pkgconf openssl
  tree bat ripgrep fd fzf pass jq chafa git-lfs flatpak mitmproxy
- Языки/SDK: java, python, pip, uv
- Базы данных: sqlite, postgresql
- Редакторы: neovim, zed
- Shell/терминал: fish (по умолчанию), kitty, fisher
- Контейнеры: docker, docker-compose
- Dev-утилиты: btop, lazygit, zoxide, github-cli
- Шрифты: ttf-jetbrains-mono-nerd (или ручная Nerd Font)
- Верстка: texlive (meta)
- Терминалы: kitty, alacritty
- GUI БД: dbeaver
- Сетевой анализ: mitmproxy
- Внешние (без пакетного менеджера): posting, superfile, pi, fresh, fisher

## Отображение имён пакетов по дистрибутивам

| Логич. пакет      | Arch              | Debian                       | Alpine            |
|-------------------|-------------------|------------------------------|-------------------|
| build-tools       | `base-devel`      | `build-essential pkg-config libssl-dev` | `build-base` |
| java              | `jdk-openjdk`     | `openjdk-21-jdk`             | `openjdk21`       |
| python/pip        | `python python-pip` | `python3 python3-pip`      | `python3 py3-pip` |
| uv                | `uv`              | скрипт astral.sh             | скрипт astral.sh  |
| sqlite            | `sqlite`          | `sqlite3`                    | `sqlite`          |
| postgresql        | `postgresql`      | `postgresql postgresql-contrib` | `postgresql`   |
| neovim            | `neovim`          | `neovim`                     | `neovim`          |
| zed               | `zed`             | скрипт zed.dev               | — (нельзя, см.ниже) |
| fish              | `fish`            | `fish`                       | `fish`            |
| kitty             | `kitty`           | `kitty`                      | `kitty`           |
| alacritty         | `alacritty`       | `alacritty`                  | `alacritty`       |
| dbeaver           | AUR `dbeaver-bin` | репозиторий dbeaver-ce       | — (только flatpak) |
| mitmproxy         | `mitmproxy`       | `mitmproxy`                  | `mitmproxy`       |
| Nerd Font         | `ttf-jetbrains-mono-nerd` | ручной wget           | ручной wget       |
| docker            | `docker docker-compose` | get.docker.com         | `docker docker-compose` |
| btop/lazygit/zoxide | `btop lazygit zoxide` | `btop` + скрипты       | `btop` + попытка  |
| github-cli        | `github-cli`      | репозиторий gh               | `github-cli`      |
| texlive           | `texlive-meta`    | `texlive`                    | `texlive`         |
| windscribe        | AUR `windscribe-cli-v2-bin` | `.deb`               | — (нельзя)        |
| ghgrab-bin        | AUR `ghgrab-bin`  | релиз GitHub                 | — (нельзя)        |
| chafa             | `chafa`           | `chafa`                      | опц. (пропуск)    |
| fd                | `fd`              | `fd-find`                    | `fd`              |
| bat               | `bat`             | `bat`                        | `bat`             |

## Особенности Alpine

Alpine использует musl, а не glibc. Следующие инструменты распространяются
только как готовые glibc-бинарники и **на Alpine не ставятся** — они оставлены
комментариями прямо в `alpine.sh`:

- `zed` — нет пакета, бинарь требует glibc
- `windscribe` — нет пакета, бинарь требует glibc
- `ghgrab-bin` — нет пакета для Alpine

`lazygit`, `zoxide`, `github-cli`, `chafa`, `kitty` доступны в репозитории
Alpine `community` и ставятся напрямую. Скрипт сам подключает `community` и
`edge/testing` (версия определяется из `/etc/alpine-release`), добавляя строки
в `/etc/apk/repositories` без дублей и обновляя индекс.

Особенности работы на Alpine, учтённые в `alpine.sh`:

- Системный `pip` защищён PEP 668 (EXTERNALLY-MANAGED) — строка
  `pip install --upgrade pip` **удалена**; пакеты ставит `uv`.
- PostgreSQL требует инициализации перед первым запуском:
  `sudo /etc/init.d/postgresql setup` выполняется перед `rc-service`.
- В группу `docker` пользователь добавляется через `sudo addgroup "$REAL_USER" docker`
  (в Alpine нет `usermod` из shadow по умолчанию).
- Рабочая директория фиксируется в `SCRIPT_DIR` в начале скрипта, поэтому
  `cd /tmp` в блоке шрифтов не ломает последующий вызов `external_tools.sh`.

`external_tools.sh` (posting/superfile/pi/fresh/fisher) рассчитан на glibc;
на Alpine некоторые готовые бинарники могут не запуститься — проверяйте
индивидуально.

## Запуск через sudo (общая логика)

Скрипты рассчитаны на `sudo bash <distro>.sh`. При таком запуске `$USER`
резолвится как `root`, поэтому в начале каждого скрипта определяется
реальный пользователь:

```bash
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"
```

Через `REAL_USER`/`REAL_HOME` назначаются: группа `docker`, оболочка по
умолчанию (`chsh -s /usr/bin/fish "$REAL_USER"`), целевая папка Nerd Font и
установка Zed (запуск от имени реального пользователя, а не root).

## Особенности Debian/Ubuntu

- Пакеты `bat` и `fd-find` ставят исполняемые файлы как `batcat` и `fdfind`
  (конфликт имён). Скрипт создаёт симлинки `/usr/local/bin/bat` → `batcat`
  и `/usr/local/bin/fd` → `fdfind`, чтобы работали привычные команды.

## Примечания

- После установки нужна перезагрузка: применяются группа `docker` и оболочка
  по умолчанию (Fish).
- Скрипты используют `sudo` и `set -e`; запускайте на целевой системе, не как
  сухую проверку.
