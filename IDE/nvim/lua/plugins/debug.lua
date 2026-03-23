-- debug.lua — отладка (DAP) через nvim-dap
-- Поддержка: Python (debugpy), Java (через java.lua)
-- ==========================================
-- NVIM-DAP — Debug Adapter Protocol
-- https://github.com/mfussenegger/nvim-dap
-- Бинды: <F5> (continue), <leader>b (breakpoint)
-- ==========================================
return {
    -- nvim-nio — async библиотека, нужна для dap-ui
    {
        "nvim-neotest/nvim-nio",
        lazy = true
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            -- Python отладка через debugpy
            -- Требует: pip install debugpy
            dap.adapters.python = {
                type = "executable",
                command = "python3",
                args = { "-m", "debugpy.adapter" },
            }
            dap.configurations.python = { {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
            } }

            vim.keymap.set('n', '<F5>', dap.continue)
            vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
        end
    },

    -- ==========================================
    -- NVIM-DAP-UI — визуальный интерфейс для отладки
    -- https://github.com/rcarriga/nvim-dap-ui
    -- ==========================================
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local ok, dapui = pcall(require, "dapui")
            if ok then dapui.setup() end
        end,
    },
}
