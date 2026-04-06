-- lsp.lua — Language Server Protocol, автодополнение, диагностика
-- LSP серверы: basedpyright, ruff (Python), clangd (C++), lua_ls (Lua), marksman (Markdown), sqls (SQL)
-- Автодополнение: nvim-cmp + LuaSnip
-- Линтеры/форматтеры: none-ls (black, isort, clang-format)

return {
    -- ==========================================
    -- MASON — менеджер LSP серверов и инструментов
    -- https://github.com/williamboman/mason.nvim
    -- Автоустанавливает: java-debug-adapter, java-test
    -- ==========================================
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()

            -- Автоустановка не-LSP пакетов (debug адаптеры и тд)
            local mason_registry = require("mason-registry")
            local packages = { "java-debug-adapter", "java-test" }

            mason_registry.refresh(function()
                for _, pkg_name in ipairs(packages) do
                    local ok, pkg = pcall(mason_registry.get_package, pkg_name)
                    if ok and not pkg:is_installed() then
                        vim.notify("Mason: installing " .. pkg_name, vim.log.levels.INFO)
                        pkg:install()
                    end
                end
            end)
        end
    },

    -- ==========================================
    -- MASON-LSPCONFIG — мост между Mason и LSP
    -- https://github.com/williamboman/mason-lspconfig.nvim
    -- Устанавливает LSP серверы автоматически
    -- ==========================================
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "basedpyright", "ruff",  -- Python
                    "clangd",                 -- C/C++
                    "lua_ls",                 -- Lua
                    "marksman",               -- Markdown
                    "sqls",                   -- SQL
                },
            })
        end
    },

    -- ==========================================
    -- NVIM-LSPCONFIG — конфигурация LSP серверов
    -- https://github.com/neovim/nvim-lspconfig
    -- Использует vim.lsp.config (Neovim 0.11+) вместо deprecated lspconfig.*.setup()
    -- Бинды: gd (definition), gr (references), gi (implementation), K (hover)
    --        <leader>rn (rename), <leader>ca (code action), <leader>f (format)
    --        [d/]d (prev/next diagnostic)
    -- ==========================================
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Глобальные capabilities для всех серверов
            vim.lsp.config('*', { capabilities = capabilities })

            vim.lsp.config('marksman', {}) -- Markdown
            vim.lsp.config('sqls', {})     -- SQL
            vim.lsp.config('basedpyright', {}) -- Python типы

            -- Ruff: отключаем hover (конфликтует с pyright)
            vim.lsp.config('ruff', {
                on_attach = function(client)
                    client.server_capabilities.hoverProvider = false
                end
            })

            -- Clangd с background indexing и clang-tidy
            vim.lsp.config('clangd', {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                }
            })

            -- Lua: разрешаем глобал vim
            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = { diagnostics = { globals = { "vim" } } }
                }
            })

            -- JDTLS отключён здесь (управляется nvim-jdtls отдельно)
            -- Не создаём даже конфиг — чтобы lspconfig не пытался его запустить
            vim.lsp.enable({ 'basedpyright', 'ruff', 'clangd', 'lua_ls', 'marksman', 'sqls' })

            -- Глобальные LSP бинды
            local set = vim.keymap.set
            set('n', 'gd', vim.lsp.buf.definition)
            set('n', 'gr', vim.lsp.buf.references)
            set('n', 'gi', vim.lsp.buf.implementation)
            set('n', 'K', function() vim.lsp.buf.hover({ border = "rounded" }) end)
            set('n', '<leader>rn', vim.lsp.buf.rename)
            set('n', '<leader>ca', vim.lsp.buf.code_action)
            set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end)
            set('n', '[d', vim.diagnostic.goto_prev)
            set('n', ']d', vim.diagnostic.goto_next)
        end
    },

    -- ==========================================
    -- NVIM-JDTLS — полноценный Java LSP (Eclipse JDT)
    -- https://github.com/mfussenegger/nvim-jdtls
    -- Требует: JDK 25, Maven/Gradle проект
    -- Бинды: <leader>oi (organize imports), <leader>em (extract method)
    -- Авто: organize imports при сохранении
    -- ==========================================
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            local jdtls = require("jdtls")
            local home = os.getenv("HOME")
            local java_cmd = "/usr/lib/jvm/java-25-openjdk-amd64/bin/java"

            -- Глобальный флаг: JDTLS уже запущен для текущего проекта
            local jdtls_initialized = false

            local function setup_java()
                -- Если JDTLS уже запущен для этого буфера — пропускаем
                if jdtls_initialized then return end

                local root_dir = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", ".git" })
                    or vim.fn.getcwd()

                -- Для мультимодульных Maven-проектов ищем корневой pom.xml
                -- Поднимаемся вверх, пока не найдём родительский pom.xml
                local current_dir = root_dir
                while true do
                    local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
                    if parent_dir == current_dir then break end -- достигли корня
                    if vim.fn.glob(parent_dir .. "/pom.xml") ~= "" then
                        root_dir = parent_dir
                        current_dir = parent_dir
                    else
                        break
                    end
                end

                -- Один workspace для всего проекта (не на модуль)
                local project_name = vim.fn.fnamemodify(root_dir, ":t")
                local workspace_folder = home .. "/.cache/jdtls/workspace/" .. project_name

                local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
                local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

                if launcher_jar == "" then return end

                -- Сборка бандлов для debug адаптера
                local bundles = {}
                local debug_jar = vim.fn.glob(
                    vim.fn.stdpath("data") ..
                    "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
                )
                if debug_jar ~= "" then
                    table.insert(bundles, debug_jar)
                end
                vim.list_extend(bundles, vim.split(
                    vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar"),
                    "\n", { trimempty = true }
                ))

                jdtls.start_or_attach({
                    cmd = {
                        java_cmd,
                        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                        "-Dosgi.bundles.defaultStartLevel=4",
                        "-Declipse.product=org.eclipse.jdt.ls.core.product",
                        "-Dlog.protocol=true",
                        "-Dlog.level=ALL",
                        "-Xmx4g",
                        "--add-modules=ALL-SYSTEM",
                        "--add-opens", "java.base/java.util=ALL-UNNAMED",
                        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                        "--add-opens", "java.base/java.nio.file=ALL-UNNAMED",
                        "-jar", launcher_jar,
                        "-configuration", jdtls_path .. "/config_linux",
                        "-data", workspace_folder,
                    },
                    root_dir = root_dir,
                    settings = {
                        java = {
                            configuration = {
                                runtimes = {
                                    {
                                        name = "JavaSE-25",
                                        path = "/usr/lib/jvm/java-25-openjdk-amd64",
                                        default = true,
                                    },
                                },
                            },
                            -- Включаем скачивание исходников зависимостей (для go to definition)
                            eclipse = {
                                downloadSources = true,
                            },
                            maven = {
                                downloadSources = true,
                            },
                        },
                    },
                    init_options = { bundles = bundles },
                    on_attach = function(client, bufnr)
                        local opts = { buffer = bufnr, silent = true }
                        vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)
                        vim.keymap.set("v", "<leader>em", function() jdtls.extract_method(true) end, opts)
                        -- Авто organize imports при сохранении
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function() jdtls.organize_imports() end,
                        })
                        jdtls.setup_dap({ hotcodereplace = "auto" })
                    end,
                })

                jdtls_initialized = true
            end

            -- Запускаем при открытии Java файлов
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                callback = setup_java,
            })
        end,
    },

    -- ==========================================
    -- LUASNIP — сниппеты (кодовые шаблоны)
    -- https://github.com/L3MON4D3/LuaSnip
    -- Загружает VSCode-совместимые сниппеты из friendly-snippets
    -- ==========================================
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets", -- коллекция сниппетов
        },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },

    -- ==========================================
    -- NVIM-CMP — автодополнение
    -- https://github.com/hrsh7th/nvim-cmp
    -- Источники: LSP, сниппеты, буфер, путь (+ cmp_ai если включён)
    -- Бинды: Tab/S-Tab (навигация), CR (подтвердить), C-Space (вызвать), C-e (закрыть)
    -- ==========================================
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",    -- источник LSP
            "L3MON4D3/LuaSnip",        -- источник сниппетов
            "saadparwaiz1/cmp_luasnip", -- мост cmp <-> luasnip
            "hrsh7th/cmp-buffer",       -- источник из буфера
            "hrsh7th/cmp-path",         -- источник путей
            "onsails/lspkind.nvim",     -- иконки в автодополнении
        },

        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            -- Построение списка источников (динамически, чтобы поддерживать cmp_ai toggle)
            local function get_sources()
                local sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }
                if vim.g.cmp_ai_enabled then
                    table.insert(sources, 1, { name = "cmp_ai" }) -- AI в приоритете
                end
                return cmp.config.sources(sources)
            end

            -- Функция настройки CMP (вызывается при init и при toggle cmp_ai)
            local function setup_cmp()
                cmp.setup({
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },

                    -- Иконки и форматирование
                    formatting = {
                        format = lspkind.cmp_format({
                            mode = "symbol_text",
                            maxwidth = 50,
                        }),
                    },

                    mapping = cmp.mapping.preset.insert({
                        -- Tab: следующий элемент или прыжок по сниппету
                        ['<Tab>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            elseif luasnip.expand_or_locally_jumpable() then
                                luasnip.expand_or_jump()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),

                        -- Shift-Tab: предыдущий элемент или прыжок назад по сниппету
                        ['<S-Tab>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            elseif luasnip.jumpable(-1) then
                                luasnip.jump(-1)
                            else
                                fallback()
                            end
                        end, { "i", "s" }),

                        ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- подтвердить
                        ['<C-Space>'] = cmp.mapping.complete(),              -- вызвать вручную
                        ['<C-e>'] = cmp.mapping.abort(),                     -- закрыть
                    }),
                    sources = get_sources(),
                })
            end

            setup_cmp()

            -- Перезагрузка CMP при toggle cmp_ai
            vim.api.nvim_create_autocmd("User", {
                pattern = "CmpAiToggle",
                callback = setup_cmp,
            })
        end
    },

    -- ==========================================
    -- LSP-SIGNATURE.NVIM — подсказки сигнатур функций
    -- https://github.com/ray-x/lsp_signature.nvim
    -- Показывает параметры функции при вводе
    -- Бинд: <C-k> toggle
    -- ==========================================
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

    -- ==========================================
    -- TROUBLE.NVIM — список диагностики в боковой панели
    -- https://github.com/folke/trouble.nvim
    -- Бинды: <leader>xx (все диагностики), <leader>xw (текущий буфер)
    -- ==========================================
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup({
                position = "right", -- справа, а не снизу
                width = 50,
            })
            vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
            vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
        end,
    },

    -- ==========================================
    -- NVIM-LSP-FILE-OPERATIONS — синхронизация LSP с файловыми операциями
    -- https://github.com/antosha417/nvim-lsp-file-operations
    -- Автоматически обновляет LSP при переименовании/перемещении файлов через neo-tree
    -- ==========================================
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

    -- ==========================================
    -- NONE-LS.NVIM — внешние линтеры/форматтеры через LSP
    -- https://github.com/nvimtools/none-ls.nvim
    -- Требует установленные бинарники: pip install black isort
    -- ==========================================
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black,        -- Python форматирование
                    null_ls.builtins.formatting.isort,        -- Python сортировка импортов
                    null_ls.builtins.formatting.clang_format, -- C++ форматирование
                },
            })
            vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end)
        end,
    },
}
