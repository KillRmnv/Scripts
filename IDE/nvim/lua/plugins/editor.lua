-- editor.lua — редактор: treesitter, автопары, комментарии, surround, поиск, TODO
return {
    -- ==========================================
    -- NVIM-AUTOPAIRS — автозакрытие скобок/кавычек
    -- https://github.com/windwp/nvim-autopairs
    -- ==========================================
    { "windwp/nvim-autopairs", config = true },

    -- ==========================================
    -- COMMENT.NVIM — комментирование кода
    -- https://github.com/numToStr/Comment.nvim
    -- Бинды: gcc (строка), gc (блок, визуальный режим)
    -- ==========================================
    { "numToStr/Comment.nvim", config = true },

    -- ==========================================
    -- TREESITTER — подсветка синтаксиса + text objects
    -- https://github.com/nvim-treesitter/nvim-treesitter
    -- Парсеры устанавливаются автоматически (auto_install = true)
    -- Text objects: af/if (функция), ac/ic (класс)
    -- ==========================================
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        tag = "v0.9.3",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "java", "kotlin", "groovy", "xml", "properties",
                    "sql", "dockerfile",
                    "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline"
                },
                sync_install = false,
                auto_install = true, -- автоустановка парсера при открытии файла
                highlight = { enable = true },
                indent = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer", -- выбрать функцию целиком
                            ["if"] = "@function.inner", -- выбрать тело функции
                            ["ac"] = "@class.outer",     -- выбрать класс целиком
                            ["ic"] = "@class.inner",     -- выбрать тело класса
                        },
                    },
                },
            })
        end,
    },

    -- ==========================================
    -- GRUG-FAR.NVIM — find & replace по проекту
    -- https://github.com/MagicDuck/grug-far.nvim
    -- Бинд: <leader>sr
    -- ==========================================
    {
        "MagicDuck/grug-far.nvim",
        config = function()
            require("grug-far").setup({ headerMaxWidth = 80 })
            vim.keymap.set("n", "<leader>sr", function() require("grug-far").open({ transient = true }) end)
        end,
    },

    -- ==========================================
    -- NVIM-SURROUND — управление окружающими символами
    -- https://github.com/kylechui/nvim-surround
    -- Бинды: ys{motion}{char} (добавить), ds{char} (удалить), cs{old}{new} (заменить)
    -- ==========================================
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },

    -- ==========================================
    -- TODO-COMMENTS.NVIM — подсветка и навигация по TODO/FIXME/HACK
    -- https://github.com/folke/todo-comments.nvim
    -- Бинды: ]t/[t (след/пред), <leader>st (поиск через Telescope)
    -- ==========================================
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("todo-comments").setup({})
            vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
            vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev TODO" })
            vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })
        end,
    },
}
