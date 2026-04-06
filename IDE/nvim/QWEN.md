# QWEN.md — Neovim Configuration Context

## Project Overview

This is a **personal Neovim configuration** located at `~/.config/nvim/`, built with **Lua** and managed by **[lazy.nvim](https://github.com/folke/lazy.nvim)** plugin manager. The config is designed for development in **Java**, **Python**, and **C++**, with full LSP support, AI assistants, debugging, and testing capabilities. It also works with **[Neovide](https://github.com/neovide/neovide)** as a GUI frontend.

### Architecture

The configuration follows a **modular plugin-based architecture**:

```
~/.config/nvim/
├── init.lua                    # Entry point: leader key, lazy.nvim bootstrap, base settings, Neovide config
├── lazy-lock.json              # Plugin versions lockfile
├── README.md                   # User-facing documentation
└── lua/
    ├── plugins/
    │   ├── ai.lua              # AI assistants: Avante, OpenCode, cmp-ai
    │   ├── debug.lua           # DAP debugging (Python via debugpy, Java)
    │   ├── editor.lua          # Treesitter, autopairs, surround, TODO comments, find & replace
    │   ├── lsp.lua             # LSP servers, nvim-cmp autocompletion, none-ls formatters/linters
    │   ├── navigation.lua      # Neo-tree, Telescope, Leap, Harpoon
    │   ├── testing.lua         # Neotest (pytest, Java)
    │   ├── tools.lua           # Git (lazygit, diffview), Docker, Database, HTTP client
    │   └── ui.lua              # Catppuccin theme, statusline, which-key, indent lines, alpha dashboard
    └── utils/
        └── ascii_art.lua       # ASCII art collection for alpha dashboard
```

### Key Technologies & Tools

| Category | Tools |
|----------|-------|
| **Plugin Manager** | lazy.nvim |
| **LSP Servers** | basedpyright, ruff, clangd, lua_ls, jdtls, marksman, sqls |
| **Autocompletion** | nvim-cmp + LuaSnip + lspkind |
| **Formatters/Linters** | black, isort, clang-format (via none-ls) |
| **Syntax** | nvim-treesitter + textobjects |
| **Debugging** | nvim-dap + dap-ui (debugpy for Python, java-debug-adapter for Java) |
| **Testing** | neotest (pytest, neotest-java) |
| **AI Assistants** | Avante (OpenRouter/Mistral), OpenCode CLI |
| **Git** | lazygit, diffview, gitsigns |
| **Navigation** | Telescope, Leap, Harpoon, Neo-tree |
| **UI/Theme** | Catppuccin Mocha, lualine, which-key, transparent.nvim, alpha-nvim |
| **Database** | vim-dadbod + UI |
| **HTTP Client** | kulala.nvim (REST client) |
| **Terminal** | toggleterm.nvim |

### Supported Languages

| Language | LSP | Formatter | Tests | Debugging |
|----------|-----|-----------|-------|-----------|
| **Python** | basedpyright + ruff | black + isort | pytest | debugpy |
| **C++** | clangd | clang-format | — | — |
| **Java** | JDTLS | — | neotest-java | java-debug-adapter |
| **Lua** | lua_ls | — | — | — |
| **Markdown** | marksman | — | — | — |
| **SQL** | sqls | — | — | — |

## Building & Running

### Prerequisites

- **Neovim 0.11+** (uses `vim.lsp.config` API)
- **Python tools**: `pip install black isort debugpy pytest`
- **JDK 25** for Java development
- **clang** for C++ (clangd + clang-format)
- **External utilities**: lazygit, lazydocker, opencode, ripgrep (rg), fd, fzf
- **Font**: JetBrainsMono Nerd Font

### First Run

```bash
nvim
```

On first launch, lazy.nvim will automatically install all plugins. Treesitter parsers are auto-installed when opening relevant file types.

### Running via Neovide (GUI)

```bash
neovide
```

Neovide-specific settings in `init.lua`:
- Font: JetBrainsMono Nerd Font 13pt
- Cursor: "railgun" VFX effect
- Refresh rate: 144Hz
- Window size: remembered between sessions

### Environment Variables (for AI)

Required for AI assistants:
```bash
export OPEN_ROUTER="sk-or-v1-..."      # OpenRouter API key
export MISTRAL_API_KEY="..."           # Mistral API key
```

## Key Bindings (Quick Reference)

### Leader Key
- `<leader>` = `Space`

### Navigation
| Binding | Action |
|---------|--------|
| `<C-p>` | Find files (Telescope) |
| `<C-f>` | Grep project (Telescope) |
| `<leader>e` | Toggle file explorer (Neo-tree) |
| `s` | Leap — jump to text |
| `<leader>ha` / `<leader>hm` | Harpoon — add / menu |

### LSP
| Binding | Action |
|---------|--------|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>f` | Format code |
| `[d` / `]d` | Previous / next diagnostic |

### AI
| Binding | Action |
|---------|--------|
| `<leader>aa` | Avante — ask question |
| `<leader>ae` | Avante — edit selection |
| `<leader>oc` | Toggle OpenCode |
| `<C-a>` | OpenCode — ask |

### Testing
| Binding | Action |
|---------|--------|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run all tests in file |
| `<leader>ts` | Toggle test summary |
| `<leader>td` | Debug nearest test |

### Debugging
| Binding | Action |
|---------|--------|
| `<F5>` | Continue / resume |
| `<leader>b` | Toggle breakpoint |

### Git
| Binding | Action |
|---------|--------|
| `<leader>gg` | Open LazyGit |
| `<leader>gd` | Diff view |
| `<leader>gh` | File history |

### Tools
| Binding | Action |
|---------|--------|
| `<C-t>` | Toggle terminal |
| `<leader>dk` | LazyDocker |
| `<leader>db` | Database UI |
| `<leader>hr` | Run HTTP request |

## Development Conventions

### Configuration Style
- All plugins are organized in **separate files** under `lua/plugins/`
- Each plugin file contains **detailed comments** with:
  - GitHub link to the plugin
  - Key bindings documentation
  - Required external dependencies
- Uses `vim.lsp.config()` API (Neovim 0.11+ native) instead of deprecated `lspconfig.*.setup()`
- Lazy loading is used extensively (`event`, `ft`, `cmd`, `keys` specifications)

### Java Setup
- JDTLS is configured for **JDK 25** at `/usr/lib/jvm/java-25-openjdk-amd64`
- Workspace stored in `~/.cache/jdtls/workspace/`
- Auto `organize_imports` on save
- Debug adapter and test bundles loaded from Mason packages

### Python Setup
- Uses **basedpyright** for type checking and **ruff** for linting
- Formatting via **black** + **isort** through none-ls
- Testing through **pytest** via neotest-python adapter
- Debugging via **debugpy** through nvim-dap

### Treesitter
- Parsers auto-installed for: Java, Kotlin, Groovy, XML, SQL, Dockerfile, Lua, Markdown, etc.
- Custom text objects: `af`/`if` (function), `ac`/`ic` (class)

### UI
- **Catppuccin Mocha** theme with transparent background
- **Alpha dashboard** with random ASCII art on startup
- **Which-key** for keybinding hints (`<leader>??`)
- **Indent lines** with `▏` character

## Notable Implementation Details

1. **CMP AI Toggle**: `cmp-ai` source is disabled by default (commented out). Can be enabled by uncommenting the block in `ai.lua` and toggling with `<leader>ai`.
2. **JDTLS is manually configured** (not auto-installed by Mason) due to complex launcher/configuration requirements.
3. **Increment/Decrement remapped**: `<C-a>` and `<C-x>` are remapped to OpenCode; original functionality moved to `+` and `-`.
4. **Transparent backgrounds**: Applied to nearly all UI groups (Neo-tree, Telescope, Trouble, Avante, DAP, etc.) except `Pmenu`, `PmenuSel`, `CursorColumn`, `ColorColumn`.
5. **LSP file operations**: Automatically syncs LSP when files are renamed/moved via Neo-tree.
