-- navigation.lua — файловый менеджер, fuzzy finder, быстрая навигация, harpoon

return {
    -- ==========================================
    -- NEO-TREE — файловый менеджер (дерево)
    -- https://github.com/nvim-neo-tree/neo-tree.nvim
    -- Бинды: <leader>e (toggle), <leader>ef (focus)
    -- ==========================================
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
                        hide_by_name = { ".git", "target", "build" }, -- скрыть служебные папки
                    },
                    follow_current_file = { enabled = true }, -- автофокус на текущем файле
                    use_libuv_file_watcher = true,             -- автообновление при изменениях
                },
            })
            vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
            vim.keymap.set("n", "<leader>ef", "<cmd>Neotree focus<CR>", { desc = "Focus file explorer" })
        end,
    },

    -- ==========================================
    -- TELESCOPE — fuzzy finder
    -- https://github.com/nvim-telescope/telescope.nvim
    -- Бинды: <C-p> (файлы), <C-f> (grep по проекту)
    -- ==========================================
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

    -- ==========================================
    -- LEAP.NVIM — быстрая навигация по видимому тексту
    -- https://codeberg.org/andyg/leap.nvim (переехал с GitHub)
    -- Бинды: s (прыжок), S (прыжок между окнами)
    -- ==========================================
    {
        url = "https://codeberg.org/andyg/leap.nvim",
        name = "leap.nvim",
        dependencies = { "ggandor/flit.nvim" },
        config = function()
            vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
            vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
            require("flit").setup({ labeled_modes = "nv" })
        end,
    },

    -- ==========================================
    -- HARPOON 2 — быстрый доступ к часто используемым файлам
    -- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
    -- Бинды: <leader>ha (добавить), <leader>hm (меню), <leader>h1-4 (переключиться)
    -- ==========================================
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            local set = vim.keymap.set
            set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add file" })
            set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
            set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
            set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
            set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
            set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
        end,
    },
    -- {
    --     "nanotee/zoxide.vim",
    --     lazy = false,
    -- },
    -- {
    --     "christoomey/vim-tmux-navigator",
    --     lazy = false,
    -- },
    -- {
    --     "RyanMillerC/better-vim-tmux-resizer",
    --     lazy = false,
    -- },
    -- {
    --     "folke/flash.nvim",
    --     event = "VeryLazy",
    --     ---@type Flash.Config
    --     opts = {},
    --     keys = {
    --         { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    --         { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    --         { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    --         { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    --         { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    --     },
    -- }
}
