return {
    { "windwp/nvim-autopairs", config = true },
    { "numToStr/Comment.nvim", config = true },

    -- Treesitter
    -- Treesitter
    {

        "nvim-treesitter/nvim-treesitter",
        version = false, -- или можно поставить "v0.9.2"
        build = ":TSUpdate",
        tag = "v0.9.3",  -- Фиксируем на последней стабильной версии до v1.0
        -- ... остальной твой конфиг (config = function() и т.д. теперь должен заработать)

        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" }, -- Load when you actually open a file
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "java", "kotlin", "groovy", "xml", "properties",
                    "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline"
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                -- Text objects config...
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                },
            })
        end,
    },

    -- Spectre (Поиск и замена)
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("spectre").setup()
            vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").open()<CR>', { desc = "Open Spectre" })
        end,
    },

    -- Grug Far (Альтернативный поиск)
    {
        "MagicDuck/grug-far.nvim",
        config = function()
            require("grug-far").setup({ headerMaxWidth = 80 })
            vim.keymap.set("n", "<leader>sr", function() require("grug-far").open({ transient = true }) end)
        end,
    },
}
