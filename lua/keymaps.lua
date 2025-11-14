vim.g.mapleader = " "

-- source
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

-- buffer navigation
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
vim.keymap.set("n", "<leader>c", ":bd<cr>")


-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- Plugin keymaps
-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- git fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- lazygit
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "Lazygit" })

-- gitsigns
vim.keymap.set('n', ']h', ":Gitsigns next_hunk<cr>")
vim.keymap.set('n', '[h', ":Gitsigns prev_hunk<cr>")
vim.keymap.set('n', '<leader>hp', ":Gitsigns preview_hunk<cr>")
vim.keymap.set('n', '<leader>hs', ":Gitsigns stage_hunk<cr>")
vim.keymap.set('n', '<leader>hr', ":Gitsigns reset_hunk<cr>")
vim.keymap.set('n', '<leader>hb', ":Gitsigns toggle_current_line_blame<cr>")

-- nvim-tree
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")

-- telescope
-- vim.keymap.set("n", "<leader>F", ":Telescope find_files<cr>")
vim.keymap.set("n", "<leader>ff", ":Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<cr>")
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<cr>")

-- nvim-comment
vim.keymap.set({'n', 'v'}, '<leader>/', ":CommentToggle<cr>")

-- format code using LSP
vim.keymap.set({'n', 'v'}, '<leader>fmd', ":silent !black %<cr>")

-- venv-selector.nvim
vim.keymap.set("n", "<leader>vs", ":VenvSelect<cr>")

-- vim-test
vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>', { desc = 'Test nearest' })
vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { desc = 'Test file' })
vim.keymap.set('n', '<leader>ts', ':TestSuite<CR>', { desc = 'Test suite' })
vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { desc = 'Test last' })
vim.keymap.set('n', '<leader>tv', ':TestVisit<CR>', { desc = 'Test visit' })
