-- ui.lua — визуальные настройки: тема, статус-бар, иконки, which-key, отступы

return {
    -- ==========================================
    -- CATPPUCCIN — цветовая схема (mocha flavour)
    -- ==========================================
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({ 
                flavour = "mocha",
                transparent_background = true, -- Включаем поддержку прозрачности в теме
            })
            vim.cmd.colorscheme("catppuccin")
        end
    },

    -- ==========================================
    -- NVIM-WEB-DEVICONS — иконки для файлов
    -- ==========================================
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- ==========================================
    -- LUALINE — статус-бар
    -- ==========================================
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({ options = { theme = "catppuccin" } })
        end
    },

    -- ==========================================
    -- GITSIGNS — git индикаторы в gutter
    -- ==========================================
    { "lewis6991/gitsigns.nvim", config = true },

    -- ==========================================
    -- WHICH-KEY — подсказки keybindings
    -- ==========================================
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            spec = {
                { "<leader>a", group = "AI (Avante)" },
                { "<leader>f", desc = "Format Code" },
                { "<leader>c", group = "Code Actions" },
                { "<leader>x", group = "Diagnostics (Trouble)" },
                { "<leader>h", group = "Harpoon" },
                { "<leader>t", group = "Tests (Neotest)" },
                { "<leader>s", group = "Search" },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    -- ==========================================
    -- INDENT-BLANKLINE — вертикальные линии отступов
    -- ==========================================
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "▏" },
            scope = { enabled = true },
        },
    },

    -- ==========================================
    -- LSPKIND — иконки в автодополнении
    -- ==========================================
    {
        "onsails/lspkind.nvim",
        config = function()
            require("lspkind").init({
                mode = "symbol_text",
                maxwidth = 50,
                ellipsis_char = "...",
            })
        end
    },

    -- ==========================================
    -- TRANSPARENT.NVIM — прозрачность фона
    -- ==========================================
    {
        "xiyaowong/transparent.nvim",
        lazy = false,
        config = function()
            require("transparent").setup({
                extra_groups = {
                    "Normal", "NormalNC", "Comment", "Constant", "Special", "Identifier",
                    "Statement", "PreProc", "Type", "Underlined", "Todo", "String", "Function",
                    "Conditional", "Repeat", "Operator", "Structure", "LineNr", "NonText",
                    "SignColumn", "CursorLine", "CursorLineNr", "StatusLine", "StatusLineNC",
                    "EndOfBuffer",
                    "NeoTreeNormal", "NeoTreeNormalNC",
                    "NvimTreeNormal", "NvimTreeNormalNC",
                    "TelescopeNormal", "TelescopePromptNormal", "TelescopeResultsNormal",
                    "TroubleNormal", "TroubleNormalNC",
                    "AvanteSidebarNormal", "AvanteNormal", "AvanteBorder", "AvanteTitle", "AvanteReversed",
                    "NormalFloat", "FloatBorder", "FloatTitle", "FloatFooter",
                    "WhichKeyFloat",
                    "ToggleTermNormal", "ToggleTermBorder",
                    "AlphaHeader", "AlphaButtons", "AlphaFooter", "AlphaShortcut",
                    "DiffviewNormal", "DiffviewStatusLine", "DiffviewEndOfBuffer",
                    "DiffviewFilePanelTitle", "DiffviewFilePanelCounter",
                    "DiffviewFilePanelFileName", "DiffviewFilePanelPath", "DiffviewSignColumn",
                    "DapUIPlayPause", "DapUIRestart", "DapUIStop", "DapUIStepOver",
                    "DapUIStepInto", "DapUIStepOut", "DapUIBreakpoints", "DapUIScope",
                    "DapUIType", "DapUIValue", "DapUIModifiedValue", "DapUIWatches", "DapUIWinSelect",
                    "WinBar", "WinBarNC",
                },
                exclude_groups = {
                    "Pmenu",
                    "PmenuSel",
                    "CursorColumn",
                    "ColorColumn",
                },
            })
            vim.cmd("TransparentEnable") 
        end,
    },

    -- ==========================================
    -- ALPHA-NVIM — стартовый экран
    -- ==========================================
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            -- Подключаем наш файл с артами (убедитесь, что файл создан)
            local ok, art_module = pcall(require, "utils.ascii_art")
            if ok then
                -- Устанавливаем случайный арт
                dashboard.section.header.val = art_module.get_random()
            else
                -- Fallback, если файл не найден
                dashboard.section.header.val = "NVIM"
            end

            -- Настройка цвета заголовка
            dashboard.section.header.opts.hl = "Keyword"

            -- Кнопки меню
            dashboard.section.buttons.val = {
                dashboard.button("f", "  Найти файл", ":Telescope find_files <CR>"),
                dashboard.button("n", "  Новый файл", ":ene <BAR> startinsert <CR>"),
                dashboard.button("r", "  Недавние файлы", ":Telescope oldfiles <CR>"),
                dashboard.button("c", "  Настройки", ":e $MYVIMRC <CR>"),
                dashboard.button("q", "  Выйти", ":qa<CR>"),
            }

            -- Отправка настроек в alpha
            alpha.setup(dashboard.opts)

            -- Отключить статуслайн на стартовом экране
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    vim.opt.showtabline = 0
                    vim.opt.laststatus = 0
                    vim.opt.fillchars = 'eob: '
                end,
            })
            vim.api.nvim_create_autocmd("BufUnload", {
                buffer = 0,
                callback = function()
                    vim.opt.showtabline = 2
                    vim.opt.laststatus = 3
                end,
            })
        end,
    }
}