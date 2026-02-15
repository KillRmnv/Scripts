return {
    -- Файловый менеджер 1 (Nvim Tree)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')
        end
    },

    -- Файловый менеджер 2 (Neo-tree)
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        visible = false,
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        hide_by_name = { ".git", "target", "build" },
                    },
                    follow_current_file = { enabled = true },
                    use_libuv_file_watcher = true,
                },
            })
            vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
            vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<CR>", { desc = "Focus file explorer" })
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<C-p>', builtin.find_files, {})
            vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
        end
    },

    -- Навигация Leap
    {
        "ggandor/leap.nvim",
        dependencies = { "ggandor/flit.nvim" },
        config = function()
            require("leap").add_default_mappings()
            require("flit").setup({ labeled_modes = "nv" })
        end,
    },

    -- Терминал
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<c-t>]],
                direction = 'float',
            })
        end
    },
}
