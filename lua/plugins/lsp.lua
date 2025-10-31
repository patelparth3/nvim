local lsp_zero = require('lsp-zero')
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
    sources = {
        {name = 'nvim_lsp'},
        {name = 'luasnip'},
        {name = 'buffer'},
        {name = 'path'},
    },
    formatting = lsp_zero.cmp_format({details = true}),
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- accept selected suggestion
        ['<C-Space>'] = cmp.mapping.complete(),        -- trigger completion menu
        ['<Tab>'] = cmp.mapping.select_next_item(),    -- cycle next
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),  -- cycle prev
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),       -- scroll up in docs
        ['<C-d>'] = cmp.mapping.scroll_docs(4),        -- scroll down in docs
        ['<C-f>'] = cmp_action.luasnip_jump_forward(), -- jump forward in snippet
        ['<C-b>'] = cmp_action.luasnip_jump_backward(), -- jump backward in snippet
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})


lsp_zero.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    -- Go to definition
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    -- Show references
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    -- Show hover docs
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    -- Show signature help (function params)
    vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)

    -- Show diagnostic message in a float
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

    -- Show all diagnostics in location list
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
end)

-- inline diagnostics (virtual text)
vim.diagnostic.config({
    virtual_text = { -- inline at end of line
        prefix = "●", -- any symbol you like
        spacing = 2,
    },
    signs = true,           -- gutter signs
    underline = true,       -- underline offending text
    update_in_insert = false, -- usually less noisy
    severity_sort = true,
})

-- small popup when you pause on an error
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor", border = "rounded" })
    end,
})


-- Extend lspconfig
lsp_zero.extend_lspconfig()

-- capabilities from nvim-cmp (recommended)
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

-- Setup mason-lspconfig with handlers
require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        -- Default handler for all servers
        function(server_name)
            lspconfig[server_name].setup({
                capabilities = capabilities,
            })
        end,

        -- Custom handler for lua_ls
        -- not sure how to resolve 'undefinded global vim' error
        lua_ls = function()
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
        end,

        -- Custom handler for gopls with gofumpt formatting
        gopls = function()
            lspconfig.gopls.setup({
                capabilities = capabilities,
                settings = {
                    gopls = {
                        gofumpt = true,           -- stricter formatting style
                        staticcheck = true,
                        analyses = { unusedparams = true, shadow = true },
                        completeUnimported = true,
                    },
                },
            })
        end,

        -- Handlers for other servers to ensure they use capabilities
        pyright = function()
            lspconfig.pyright.setup({ capabilities = capabilities })
        end,
        ts_ls = function()
            lspconfig.ts_ls.setup({ capabilities = capabilities })
        end,
        eslint = function()
            lspconfig.eslint.setup({ capabilities = capabilities })
        end,
        tailwindcss = function()
            lspconfig.tailwindcss.setup({ capabilities = capabilities })
        end,
        sqls = function()
            lspconfig.sqls.setup({ capabilities = capabilities })
        end,
    }
})

lsp_zero.setup()
