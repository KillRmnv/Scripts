-- testing.lua — запуск тестов через neotest
-- Адаптеры: Python (pytest), Java

-- ==========================================
-- NEOTEST — фреймворк для тестов в Neovim
-- https://github.com/nvim-neotest/neotest
-- Адаптеры:
--   neotest-python (pytest): https://github.com/nvim-neotest/neotest-python
--   neotest-java: https://github.com/rcasia/neotest-java
-- Бинды:
--   <leader>tt — запустить ближайший тест
--   <leader>tf — запустить все тесты файла
--   <leader>ts — toggle summary
--   <leader>to — toggle output panel
--   <leader>td — debug ближайший тест
-- ==========================================
return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- Адаптеры для языков
            "nvim-neotest/neotest-python",
            "rcasia/neotest-java",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        runner = "pytest",
                    }),
                    require("neotest-java")({
                        -- использует системный JDK
                    }),
                },
            })

            local set = vim.keymap.set
            local neotest = require("neotest")
            set("n", "<leader>tt", function() neotest.run.run() end, { desc = "Run nearest test" })
            set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
            set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
            set("n", "<leader>to", function() neotest.output_panel.toggle() end, { desc = "Toggle test output" })
            set("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, { desc = "Debug nearest test" })
        end,
    },
}
