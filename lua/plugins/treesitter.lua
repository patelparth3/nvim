-- lua/plugins/treesitter.lua
-- Use git instead of curl for parser downloads
require("nvim-treesitter.install").prefer_git = true

local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = {
    "python", "go", "sql", "typescript", "javascript",
    "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline"
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
