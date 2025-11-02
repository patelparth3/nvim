-- lua/plugins/telescope.lua
require('telescope').setup({
    defaults = {
        -- You can set winblend for transparency (0-100, 0 is opaque, 100 is fully transparent)
        winblend = 20,  -- Some transparency with black background
    },
})

-- Custom highlight groups for telescope background (dark/black)
vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = '#000000' })  -- Black background
vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = '#000000', fg = '#89b4fa' })  -- Black with colored border
vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = '#0a0a0a' })  -- Slightly lighter black for prompt
vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = '#0a0a0a', fg = '#89b4fa' })
vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = '#000000' })  -- Black results
vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { bg = '#000000', fg = '#89b4fa' })
vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = '#000000' })  -- Black preview
vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { bg = '#000000', fg = '#89b4fa' })
