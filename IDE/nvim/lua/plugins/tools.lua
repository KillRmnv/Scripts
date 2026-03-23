-- tools.lua — HTTP, Git, Docker, Database
return {

    -- ==========================================
    -- KULALA.NVIM — HTTP/REST клиент (аналог Postman)
    -- https://github.com/mistweaverco/kulala.nvim
    -- Требует: .http или .rest файлы
    -- Бинды: <leader>hr (run), <leader>hp (run all), <leader>hi (inspect)
    -- ==========================================
    {
        "mistweaverco/kulala.nvim",
        ft = { "http", "rest" },
        config = function()
            require("kulala").setup({
                default_view = "body",
                split_direction = "vertical",
            })
            vim.keymap.set("n", "<leader>hr", "<cmd>lua require('kulala').run()<cr>",       { desc = "Run HTTP request" })
            vim.keymap.set("n", "<leader>hp", "<cmd>lua require('kulala').run_all()<cr>",   { desc = "Run all requests" })
            vim.keymap.set("n", "<leader>hi", "<cmd>lua require('kulala').inspect()<cr>",   { desc = "Inspect request" })
            vim.keymap.set("n", "<leader>hn", "<cmd>lua require('kulala').jump_next()<cr>", { desc = "Next request" })
            vim.keymap.set("n", "<leader>hb", "<cmd>lua require('kulala').jump_prev()<cr>", { desc = "Prev request" })
        end,
    },

    -- ==========================================
    -- LAZYGIT.NVIM — Git TUI в Neovim
    -- https://github.com/kdheepak/lazygit.nvim
    -- Требует установленный lazygit: https://github.com/jesseduffield/lazygit
    -- Бинд: <leader>gg
    -- ==========================================
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
        config = function()
            vim.g.lazygit_floating_window_scaling_factor = 0.95
        end,
    },

    -- ==========================================
    -- DIFFVIEW.NVIM — Git diff и история
    -- https://github.com/sindrets/diffview.nvim
    -- Бинды: <leader>gd (diff), <leader>gh (история файла), <leader>gD (закрыть)
    -- ==========================================
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<cr>",            desc = "Diff view" },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",   desc = "File history" },
            { "<leader>gD", "<cmd>DiffviewClose<cr>",           desc = "Close diff" },
        },
    },

    -- ==========================================
    -- TOGGLETERM.NVIM — терминал в Neovim
    -- https://github.com/akinsho/toggleterm.nvim
    -- Бинды: <C-t> (toggle терминал), <leader>dk (lazydocker)
    -- Требует установленный lazydocker: https://github.com/jesseduffield/lazydocker
    -- ==========================================
    {
        "akinsho/toggleterm.nvim",
        opts = {
            size = 20,
            open_mapping = [[<c-t>]],
            direction = "float",
            float_opts = { border = "curved" },
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            -- LazyDocker в отдельном float окне
            local Terminal = require("toggleterm.terminal").Terminal
            local lazydocker = Terminal:new({
                cmd = "lazydocker",
                direction = "float",
                hidden = true,
                float_opts = { border = "curved" },
            })
            vim.keymap.set("n", "<leader>dk", function() lazydocker:toggle() end, { desc = "LazyDocker" })
        end,
    },

    -- ==========================================
    -- VIM-DADBOD — работа с базами данных
    -- https://github.com/tpope/vim-dadbod
    -- UI: https://github.com/kristijanhusak/vim-dadbod-ui
    -- Бинды: <leader>db (toggle UI), <leader>da (добавить подключение)
    -- Автодополнение для SQL буферов
    -- ==========================================
    {
        "tpope/vim-dadbod",
        lazy = true,
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            "tpope/vim-dadbod",
            "kristijanhusak/vim-dadbod-completion",
        },
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
        keys = {
            { "<leader>db", "<cmd>DBUIToggle<cr>",        desc = "Database UI" },
            { "<leader>da", "<cmd>DBUIAddConnection<cr>", desc = "Add DB connection" },
        },
        config = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
            vim.g.db_ui_auto_execute_table_helpers = 1

            -- Автодополнение для SQL буферов
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "plsql" },
                callback = function()
                    require("cmp").setup.buffer({
                        sources = {
                            { name = "vim-dadbod-completion" },
                            { name = "buffer" },
                        },
                    })
                end,
            })
        end,
    },
}
