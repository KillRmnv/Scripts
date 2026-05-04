# Neovim Config

Конфигурация Neovim для разработки на **Java**, **Python**, **C++** с AI-ассистентами.

Работает с [Neovide](https://github.com/neovide/neovide) (GUI фронтенд).

## Структура

```
~/.config/nvim/
├── init.lua                    # Основной конфиг, настройки, Neovide
└── lua/plugins/
    ├── ai.lua                  # AI: Avante, OpenCode, cmp-ai
    ├── debug.lua               # DAP отладка (Python, Java)
    ├── editor.lua              # Treesitter, autopairs, surround, TODO
    ├── lsp.lua                 # LSP серверы, CMP автодополнение, none-ls
    ├── navigation.lua          # Neo-tree, Telescope, Leap, Harpoon, zoxide, tmux
    ├── testing.lua             # Neotest (Python, Java)
    ├── tools.lua               # Git (lazygit, diffview), Docker, Database, HTTP
    └── ui.lua                  # Тема, статус-бар, which-key, отступы, rainbow-delimiters
```

## Языки

| Язык | LSP | Форматирование | Тесты | Отладка |
|------|-----|----------------|-------|---------|
| Python | basedpyright + ruff | black + isort | pytest | debugpy |
| C++ | clangd | clang-format | - | - |
| Java | JDTLS | - | neotest-java | java-debug-adapter |
| Lua | lua_ls | - | - | - |
| Markdown | marksman | - | - | - |
| SQL | sqls | - | - | - |

## Установка

### 1. Neovim

Требуется **Neovim 0.11+** (для `vim.lsp.config`).

```bash
# Arch
sudo pacman -S neovim

# Ubuntu
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update && sudo apt install neovim
```

### 2. Зависимости (обязательно)

```bash
# Python инструменты
pip install black isort debugpy pytest

# JDK 25 (для Java)
# Скачать с https://jdk.java.net/25/ или использовать пакетный менеджер
sudo pacman -S jdk-openjdk  # Arch

# clangd и clang-format (для C++)
sudo pacman -S clang        # Arch
sudo apt install clang      # Ubuntu
```

### 3. Внешние утилиты (установить отдельно)

| Утилита | Описание | Ссылка | Установка |
|---------|----------|--------|-----------|
| **lazygit** | Git TUI | [github.com/jesseduffield/lazygit](https://github.com/jesseduffield/lazygit) | `sudo pacman -S lazygit` / `brew install lazygit` |
| **lazydocker** | Docker TUI | [github.com/jesseduffield/lazydocker](https://github.com/jesseduffield/lazydocker) | `sudo pacman -S lazydocker` / `brew install lazydocker` |
| **opencode** | AI CLI ассистент | [github.com/sst/opencode](https://github.com/sst/opencode) | `go install github.com/sst/opencode/cmd/opencode@latest` |
| **rg** (ripgrep) | Поиск по проекту | [github.com/BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) | `sudo pacman -S ripgrep` / `brew install ripgrep` |
| **fd** | Быстрый find | [github.com/sharkdp/fd](https://github.com/sharkdp/fd) | `sudo pacman -S fd` / `brew install fd` |
| **fzf** | Fuzzy finder | [github.com/junegunn/fzf](https://github.com/junegunn/fzf) | `sudo pacman -S fzf` / `brew install fzf` |
| **JetBrainsMono Nerd Font** | Шрифт с иконками | [github.com/ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts) | `yay -S nerd-fonts-jetbrains-mono` |


### 4. API ключи (для AI)

Добавь в `~/.bashrc` или `~/.zshrc`:

```bash
export OPEN_ROUTER="sk-or-v1-..."      # https://openrouter.ai
export MISTRAL_API_KEY="..."           # https://mistral.ai
```

### 5. Запуск

```bash
nvim  # Первый запуск установит все плагины через lazy.nvim
```

## Бинды

### Основные

| Бинд | Действие |
|------|----------|
| `<leader>` | Space |
| `<leader>?` | Показать все бинды (which-key) |

### Навигация

| Бинд | Действие |
|------|----------|
| `<C-p>` | Найти файл (Telescope) |
| `<C-f>` | Поиск по проекту (Telescope) |
| `<leader>e` | Toggle файловый менеджер (neo-tree) |
| `<leader>ef` | Фокус на neo-tree |
| `s` | Leap — быстрый прыжок |
| `S` | Leap — прыжок между окнами |
| `<leader>ha` | Harpoon — добавить файл |
| `<leader>hm` | Harpoon — меню |
| `<leader>h1-4` | Harpoon — файл 1-4 |
| `<C-h/j/k/l>` | Навигация Neovim ↔ tmux (vim-tmux-navigator) |
| `<leader>sr` | Find & replace (grug-far) |
| `<leader>st` | Поиск TODO (todo-comments) |

### Навигация по директориям (zoxide)

| Команда | Действие |
|---------|----------|
| `:Z {query}` | Перейти в директорию (zoxide) |
| `:Z <Tab>` | Автодополнение путей |

### LSP

| Бинд | Действие |
|------|----------|
| `gd` | Go to definition |
| `gr` | References |
| `gi` | Implementation |
| `K` | Hover (информация) |
| `<leader>rn` | Переименовать |
| `<leader>ca` | Code actions |
| `<leader>f` | Форматировать код |
| `[d` / `]d` | Предыдущая / следующая ошибка |

### Автодополнение

| Бинд | Действие |
|------|----------|
| `<Tab>` / `<S-Tab>` | Навигация по списку |
| `<CR>` | Подтвердить |
| `<C-Space>` | Вызвать вручную |
| `<C-e>` | Закрыть |
| `<leader>ai` | Toggle AI автодополнение (cmp-ai) |

### AI

| Бинд | Действие |
|------|----------|
| `<leader>aa` | Avante — задать вопрос |
| `<leader>ae` | Avante — редактировать |
| `<leader>ar` | Avante — обновить |
| `<leader>oc` | Toggle OpenCode |
| `<C-a>` | OpenCode — ask (заменил increment, теперь `+`) |
| `<C-x>` | OpenCode — select (заменил decrement, теперь `-`) |

### Java

| Бинд | Действие |
|------|----------|
| `<leader>oi` | Organize imports (авто при сохранении) |
| `<leader>em` | Extract method (visual mode) |

### Git

| Бинд | Действие |
|------|----------|
| `<leader>gg` | LazyGit |
| `<leader>gd` | Diffview |
| `<leader>gh` | История файла |
| `<leader>gD` | Закрыть diffview |

### Тесты (Neotest)

| Бинд | Действие |
|------|----------|
| `<leader>tt` | Запустить ближайший тест |
| `<leader>tf` | Запустить все тесты файла |
| `<leader>ts` | Toggle summary |
| `<leader>to` | Toggle output panel |
| `<leader>td` | Debug ближайший тест |

### Отладка (DAP)

| Бинд | Действие |
|------|----------|
| `<F5>` | Continue |
| `<leader>b` | Toggle breakpoint |

### Инструменты

| Бинд | Действие |
|------|----------|
| `<C-t>` | Toggle терминал |
| `<leader>dk` | LazyDocker |
| `<leader>db` | Database UI |
| `<leader>da` | Добавить DB подключение |
| `<leader>hr` | Запустить HTTP запрос |
| `<leader>xx` | Диагностики (Trouble, справа) |
| `<leader>xw` | Диагностики текущего буфера |
| `]t` / `[t` | Следующий / предыдущий TODO |

### Редактор

| Бинд | Действие |
|------|----------|
| `gcc` | Комментировать строку |
| `gc` | Комментировать блок |
| `ys{motion}{char}` | Surround — добавить |
| `ds{char}` | Surround — удалить |
| `cs{old}{new}` | Surround — заменить |
| `af` / `if` | Treesitter: функция (внешняя / внутренняя) |
| `ac` / `ic` | Treesitter: класс (внешний / внутренний) |

### Rainbow Delimiters

Скобки `(`, `[`, `{` и т.д. автоматически подсвечиваются разными цветами при входе/выходе из блока. Работает на базе Treesitter, без дополнительных биндов.

## Плагины (полный список)

### AI
- [avante.nvim](https://github.com/yetone/avante.nvim) — AI coding assistant
- [opencode.nvim](https://github.com/nickjvandyke/opencode.nvim) — интеграция с opencode CLI
- [cmp-ai](https://github.com/tzachar/cmp-ai) — локальное AI автодополнение (опционально)

### LSP & Автодополнение
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) — конфигурация LSP
- [mason.nvim](https://github.com/williamboman/mason.nvim) — менеджер LSP серверов
- [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) — мост
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) — автодополнение
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) — сниппеты
- [lspkind.nvim](https://github.com/onsails/lspkind.nvim) — иконки
- [lsp_signature](https://github.com/ray-x/lsp_signature.nvim) — подсказки сигнатур
- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) — внешние форматтеры/линтеры
- [trouble.nvim](https://github.com/folke/trouble.nvim) — диагностики
- [nvim-lsp-file-operations](https://github.com/antosha417/nvim-lsp-file-operations) — LSP + файлы

### Java
- [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) — Eclipse JDT LSP

### Навигация
- [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) — файловый менеджер
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) — fuzzy finder
- [leap.nvim](https://codeberg.org/andyg/leap.nvim) — быстрая навигация
- [harpoon](https://github.com/ThePrimeagen/harpoon) — быстрый доступ к файлам
- [zoxide.vim](https://github.com/nanotee/zoxide.vim) — умная навигация по директориям
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) — навигация Neovim ↔ tmux
- [better-vim-tmux-resizer](https://github.com/RyanMillerC/better-vim-tmux-resizer) — ресайз tmux-панелей

### Редактор
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — подсветка синтаксиса
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) — автозакрытие скобок
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) — комментирование
- [nvim-surround](https://github.com/kylechui/nvim-surround) — surround операции
- [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) — find & replace
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) — TODO подсветка

### Тесты
- [neotest](https://github.com/nvim-neotest/neotest) — тестовый фреймворк
- [neotest-python](https://github.com/nvim-neotest/neotest-python) — pytest адаптер
- [neotest-java](https://github.com/rcasia/neotest-java) — Java адаптер

### Отладка
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) — Debug Adapter Protocol
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) — UI для отладки

### UI
- [catppuccin](https://github.com/catppuccin/nvim) — цветовая схема
- [lualine](https://github.com/nvim-lualine/lualine.nvim) — статус-бар
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) — git индикаторы
- [which-key](https://github.com/folke/which-key.nvim) — подсказки биндов
- [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) — линии отступов
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) — иконки
- [rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim) — разноцветные скобки

### Инструменты
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) — терминал
- [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) — Git TUI
- [diffview.nvim](https://github.com/sindrets/diffview.nvim) — Git diff
- [kulala.nvim](https://github.com/mistweaverco/kulala.nvim) — HTTP клиент
- [vim-dadbod](https://github.com/tpope/vim-dadbod) — базы данных
- [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) — UI для DB

## Neovide

Конфиг автоматически настраивает Neovide при запуске через GUI.

```bash
neovide  # Запуск через GUI
```

Настройки (в `init.lua`):
- Шрифт: JetBrainsMono Nerd Font 13pt
- Курсор: railgun эффект
- Частота обновления: 144Hz
