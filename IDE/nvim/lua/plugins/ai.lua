-- ai.lua — AI-ассистенты: Avante, OpenCode, cmp-ai
return {
    -- ==========================================
    -- AVANTE.NVIM — AI coding assistant (аналог Cursor)
    -- https://github.com/yetone/avante.nvim
    -- Провайдеры: OpenRouter, Mistral, Claude, Moonshot
    -- Бинды: <leader>aa (ask), <leader>ae (edit), <leader>ar (refresh)
    -- Переменные окружения: OPEN_ROUTER, MISTRAL_API_KEY, ANTHROPIC_API_KEY
    -- ==========================================
    {
        "yetone/avante.nvim",
        build = vim.fn.has("win32") ~= 0
            and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        event = "VeryLazy",
        opts = {
            provider = "openrouter", -- дефолтный провайдер
            mappings = {
                ask = "<leader>aa",      -- задать вопрос
                edit = "<leader>ae",     -- редактировать код
                refresh = "<leader>ar",  -- обновить ответ
            },
            providers = {
                -- Mistral Large
                mistral = {
                    __inherited_from = "openai",
                    endpoint = "https://api.mistral.ai/v1/",
                    api_key_name = "MISTRAL_API_KEY",
                    model = "mistral-large-latest",
                    timeout = 120000,
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 32768,
                    },
                },
                -- OpenRouter (бесплатная модель по умолчанию)
                openrouter = {
                    __inherited_from = "openai",
                    endpoint = "https://openrouter.ai/api/v1/",
                    api_key_name = "OPEN_ROUTER",
                    model = "arcee-ai/trinity-large-preview:free",
                    timeout = 120000,
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 32768,
                    },
                },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-mini/mini.pick",
            "nvim-telescope/telescope.nvim",
            "hrsh7th/nvim-cmp",
            "ibhagwan/fzf-lua",
            "stevearc/dressing.nvim",
            "folke/snacks.nvim",
            "nvim-tree/nvim-web-devicons",
            "zbirenbaum/copilot.lua",
            {
                "HakonHarnes/img-clip.nvim", -- вставка изображений в буфер
                event = "VeryLazy",
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        drag_and_drop = { insert_mode = true },
                    },
                },
            },
            {
                'MeanderingProgrammer/render-markdown.nvim', -- рендер markdown в Avante
                opts = { file_types = { "markdown", "Avante" } },
                ft = { "markdown", "Avante" },
            },
        },
    },

    -- ==========================================
    -- OPENCODE.NVIM — интеграция с opencode CLI
    -- https://github.com/nickjvandyke/opencode.nvim
    -- Требует установленный opencode: https://github.com/sst/opencode
    -- Бинды: <leader>oc (toggle), <C-a> (ask), <C-x> (select)
    -- ==========================================
    {
        "nickjvandyke/opencode.nvim",
        version = "*",
        dependencies = { "folke/snacks.nvim" },
        config = function()
            vim.g.opencode_opts = {}
            vim.o.autoread = true -- нужно для автообновления буферов при редактировании opencode

            local set = vim.keymap.set
            set("n", "<leader>oc", function() require("opencode").toggle() end, { desc = "Toggle OpenCode" })
            set({"n", "x"}, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask OpenCode" })
            set({"n", "x"}, "<C-x>", function() require("opencode").select() end, { desc = "OpenCode actions" })

            -- Переназначаем стандартный increment/decrement (т.к. C-a и C-x заняты opencode)
            set("n", "+", "<C-a>", { noremap = true, desc = "Increment" })
            set("n", "-", "<C-x>", { noremap = true, desc = "Decrement" })
        end
    },

    -- ==========================================
    -- CMP-AI — локальное AI автодополнение (LM Studio / llama.cpp)
    -- https://github.com/tzachar/cmp-ai
    -- Требует запущенный LM Studio на localhost:1234
    -- Переключение: <leader>ai (ON/OFF)
    -- Раскомментируй блок ниже для активации
    -- ==========================================
    -- {
    --     "tzachar/cmp-ai",
    --     dependencies = { "hrsh7th/nvim-cmp" },
    --     config = function()
    --         require("cmp_ai.config").setup({
    --             provider = "OpenAI",
    --             provider_options = {
    --                 endpoint = "http://127.0.0.1:1234/v1", -- LM Studio
    --                 model = "local-model",
    --                 api_key = "EMPTY", -- обязательно, но не используется
    --             },
    --             max_lines = 500,
    --             notify = false,
    --             run_on_every_keystroke = false,
    --             request_timeout = 1000,
    --         })
    --         vim.keymap.set("n", "<leader>ai", function()
    --             vim.g.cmp_ai_enabled = not vim.g.cmp_ai_enabled
    --             vim.notify("cmp-ai: " .. (vim.g.cmp_ai_enabled and "ON" or "OFF"), vim.log.levels.INFO)
    --             vim.api.nvim_exec_autocmds("User", { pattern = "CmpAiToggle" })
    --         end, { desc = "Toggle AI completions" })
    --     end
    -- },
}
