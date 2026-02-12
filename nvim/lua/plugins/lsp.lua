return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "b0o/schemastore.nvim",
            "saghen/blink.cmp",
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },

        config = function()
            local servers = {
                { name = "gopls" },
                { name = "clangd" },
                { name = "terraformls" },
                { name = "lua_ls" },
                { name = "intelephense" },
                { name = "laravel_ls" },
                {
                    name = "phpactor",
                    setup = {
                        init_options = {
                            ["completion_worse.completor.doctrine_annotation.enabled"] = false,
                            ["completion_worse.completor.imported_names.enabled"] = false,
                            ["completion_worse.completor.worse_parameter.enabled"] = false,
                            ["completion_worse.completor.named_parameter.enabled"] = false,
                            ["completion_worse.completor.constructor.enabled"] = false,
                            ["completion_worse.completor.class_member.enabled"] = false,
                            ["completion_worse.completor.scf_class.enabled"] = false,
                            ["completion_worse.completor.local_variable.enabled"] = false,
                            ["completion_worse.completor.subscript.enabled"] = false,
                            ["completion_worse.completor.declared_function.enabled"] = false,
                            ["completion_worse.completor.declared_constant.enabled"] = false,
                            ["completion_worse.completor.declared_class.enabled"] = false,
                            ["completion_worse.completor.expression_name_search.enabled"] = false,
                            ["completion_worse.completor.use.enabled"] = false,
                            ["completion_worse.completor.attribute.enabled"] = false,
                            ["completion_worse.completor.class_like.enabled"] = false,
                            ["completion_worse.completor.type.enabled"] = false,
                            ["completion_worse.completor.keyword.enabled"] = false,
                            ["completion_worse.completor.docblock.enabled"] = false,
                            ["completion_worse.completor.constant.enabled"] = false,
                        },
                    },
                },
                { name = "pyright" },
                {
                    name = "yamlls",
                    setup = {
                        settings = {
                            yaml = {
                                schemaStore = {
                                    -- You must disable built-in schemaStore support if you want to use
                                    -- this plugin and its advanced options like `ignore`.
                                    enable = false,
                                    -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                                    url = "",
                                },
                                schemas = require('schemastore').yaml.schemas(),
                            },
                        },
                    },
                },
            }

            vim.diagnostic.config({ virtual_text = { current_line = true } })
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            for _, server in pairs(servers) do
                local setup = server.setup or { capabilities = capabilities }
                setup.capabilities = setup.capabilities or capabilities
                vim.lsp.config(server.name, setup)
                vim.lsp.enable(server.name)
            end

            vim.keymap.set("n", "<leader>fo", function()
                vim.lsp.buf.format()
            end)

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.name == "phpactor" then
                        client.server_capabilities.definitionProvider = false
                    end

                    -- NOTE: Remember that lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself
                    -- many times.
                    --
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-T>.
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                    -- Find references for the word under your cursor.
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

                    -- Fuzzy find all the symbols in your current workspace
                    --  Similar to document symbols, except searches over your whole project.
                    map(
                        "<leader>ws",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[W]orkspace [S]ymbols"
                    )

                    -- Rename the variable under your cursor
                    --  Most Language Servers support renaming across files, etc.
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap
                    -- map("K", vim.lsp.buf.hover, "Hover Documentation")

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- TODO: added by me check if we keep this
                    map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    -- local client = vim.lsp.get_client_by_id(event.data.client_id)
                    -- if client and client.server_capabilities.documentHighlightProvider then
                    --     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    --         buffer = event.buf,
                    --         callback = vim.lsp.buf.document_highlight,
                    --     })
                    --
                    --     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    --         buffer = event.buf,
                    --         callback = vim.lsp.buf.clear_references,
                    --     })
                    -- end
                end,
            })
        end,
    },
}
