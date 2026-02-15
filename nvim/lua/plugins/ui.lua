return {
    -- Тема Catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({ flavour = "mocha" })
            vim.cmd.colorscheme("catppuccin")
        end
    },

    -- Иконки
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Статус-бар
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({ options = { theme = "catppuccin" } })
        end
    },

    -- Git Signs (добавил сюда из раздела "Дополнительно")
    { "lewis6991/gitsigns.nvim",     config = true },
}
