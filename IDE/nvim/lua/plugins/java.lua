return {
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
            "nvim-lua/plenary.nvim",
            "williamboman/mason.nvim",
        },
        config = function()
            local jdtls = require("jdtls")
            local home = os.getenv("HOME")
            local java_cmd = home .. "/.jdks/openjdk-23.0.2/bin/java"

            vim.notify("[JDTLS] Loading configuration...", vim.log.levels.INFO)

            -- Поиск корня проекта
            local function find_project_root()
                local markers = { "pom.xml", "build.gradle", "build.gradle.kts", ".git" }
                return require("jdtls.setup").find_root(markers) or vim.fn.getcwd()
            end

            local project_root = find_project_root()
            local project_name = vim.fn.fnamemodify(project_root, ":t")
            local workspace_folder = home .. "/.cache/jdtls/workspace/" .. project_name

            -- Путь к jdtls из Mason (без mason-registry API)
            local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
            local launcher_jar =
                vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
            local config_dir = jdtls_path .. "/config_linux"

            if launcher_jar == "" then
                vim.notify(
                    "[JDTLS] Launcher JAR not found. Install jdtls via :Mason",
                    vim.log.levels.ERROR
                )
                return
            end

            -- Debug adapter bundle
            local bundles = {}
            local java_debug_path =
                vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter"

            local debug_jar = vim.fn.glob(
                java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"
            )

            if debug_jar ~= "" then
                table.insert(bundles, debug_jar)
                vim.notify("[JDTLS] Debug adapter loaded.", vim.log.levels.INFO)
            end

            local config = {
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
                    "-configuration", config_dir,
                    "-data", workspace_folder,
                },
                root_dir = project_root,
                settings = {
                    java = {
                        home = java_cmd:gsub("/bin/java", ""),
                        configuration = {
                            runtimes = {
                                {
                                    name = "JavaSE-23",
                                    path = home .. "/.jdks/openjdk-23.0.2",
                                    default = true,
                                },
                            },
                        },
                    },
                },
                init_options = {
                    bundles = bundles,
                },
                on_attach = function(client, bufnr)
                    vim.notify(
                        "[JDTLS] Attached to project: " .. project_name,
                        vim.log.levels.INFO
                    )

                    local opts = { buffer = bufnr, silent = true }
                    vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)
                    vim.keymap.set("v", "<leader>em", function()
                        jdtls.extract_method(true)
                    end, opts)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        pattern = "*.java",
                        callback = function()
                            jdtls.organize_imports()
                        end,
                    })



                end,
            }

            jdtls.start_or_attach(config)
        end,
    },
}
