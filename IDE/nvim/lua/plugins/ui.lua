-- ui.lua — визуальные настройки: тема, статус-бар, иконки, which-key, отступы

return {
    -- ==========================================
    -- CATPPUCCIN — цветовая схема (mocha flavour)
    -- https://github.com/catppuccin/nvim
    -- ==========================================
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({ flavour = "mocha" })
            vim.cmd.colorscheme("catppuccin")
        end
    },

    -- ==========================================
    -- NVIM-WEB-DEVICONS — иконки для файлов
    -- https://github.com/nvim-tree/nvim-web-devicons
    -- ==========================================
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- ==========================================
    -- LUALINE — статус-бар
    -- https://github.com/nvim-lualine/lualine.nvim
    -- ==========================================
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({ options = { theme = "catppuccin" } })
        end
    },

    -- ==========================================
    -- GITSIGNS — git индикаторы в gutter
    -- https://github.com/lewis6991/gitsigns.nvim
    -- ==========================================
    { "lewis6991/gitsigns.nvim", config = true },

    -- ==========================================
    -- WHICH-KEY — подсказки keybindings при нажатии <leader>
    -- https://github.com/folke/which-key.nvim
    -- Бинд: <leader>? — показать все буферные бинды
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
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    -- Подсвечивает текущий scope (блок кода)
    -- ==========================================
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "▏" },    -- тонкая вертикальная линия
            scope = { enabled = true },   -- подсветка текущего блока
        },
    },

    -- ==========================================
    -- LSPKIND — иконки в автодополнении (nvim-cmp)
    -- https://github.com/onsails/lspkind.nvim
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
}
