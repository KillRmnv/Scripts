return {
    {
        "nvim-neotest/nvim-nio",
        lazy = true
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            -- Python config
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
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local ok, dapui = pcall(require, "dapui")
            if ok then dapui.setup() end
        end,
    },
}
