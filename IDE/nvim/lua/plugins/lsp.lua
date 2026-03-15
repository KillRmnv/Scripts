return {
    -- Mason
    {
        "williamboman/mason.nvim",
        config = true
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "clangd", "lua_ls" },
            })
        end
    },

    -- LSP Config
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            lspconfig.pyright.setup({ capabilities = capabilities })
            lspconfig.clangd.setup({ capabilities = capabilities })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } }
                    }
                }
            })

            vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
            vim.keymap.set("n", "<leader>f", function()
                vim.lsp.buf.format({ async = true })
            end)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover({
                    border = "rounded",
                    max_width = 100,
                    max_height = 30,
                })
            end)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        end
    },

    -- CMP
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local ok, cmp = pcall(require, "cmp")
            if not ok then return end
            local luasnip_ok, luasnip = pcall(require, "luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        if luasnip_ok then
                            luasnip.lsp_expand(args.body)
                        end
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),      -- Вызвать автодополнение
                    ['<C-e>'] = cmp.mapping.abort(),             -- Закрыть окно
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(), -- Предыдущий
                    
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }
            })
        end
    },

    -- UI
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        config = function()
            require("lsp_signature").setup({
                bind = true,
                handler_opts = { border = "rounded" },
                hint_enable = true,
                toggle_key = "<C-k>",
            })
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup({})
            vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
        end,
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neo-tree/neo-tree.nvim"
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
}
