-- Reset
vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.g.colors_name = 'mytheme'

-- Color palette - adjust these to your liking
local c = {
  bg       = '#0d0d0d',
  fg       = '#c5c8c6',
  subtle   = '#555555',
  keyword  = '#81a2be',  -- blue
  func     = '#b294bb',  -- purple
  string   = '#b5bd68',  -- green
  type     = '#de935f',  -- orange
  constant = '#f0c674',  -- yellow
  comment  = '#969896',  -- gray
  error    = '#cc6666',  -- red
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Basic UI (bg = 'NONE' allows terminal transparency to show through)
hl('Normal',       { fg = c.fg, bg = 'NONE' })
hl('Comment',      { fg = c.comment })
hl('LineNr',       { fg = c.subtle })
hl('CursorLineNr', { fg = c.fg })
hl('Visual',       { bg = '#2d2d2d' })
hl('Search',       { bg = '#373b41', fg = c.constant })
hl('IncSearch',    { bg = c.constant, fg = c.bg })

-- Syntax
hl('String',       { fg = c.string })
hl('Keyword',      { fg = c.keyword })
hl('Function',     { fg = c.func })
hl('Type',         { fg = c.type })
hl('Constant',     { fg = c.constant })
hl('Identifier',   { fg = c.fg })
hl('Statement',    { fg = c.keyword })
hl('PreProc',      { fg = c.type })
hl('Special',      { fg = c.constant })
hl('Error',        { fg = c.error })

-- Treesitter (for modern syntax highlighting)
hl('@keyword',            { fg = c.keyword })
hl('@keyword.function',   { fg = c.keyword })
hl('@keyword.return',     { fg = c.keyword })
hl('@function',           { fg = c.func })
hl('@function.call',      { fg = c.func })
hl('@function.builtin',   { fg = c.func })
hl('@method',             { fg = c.func })
hl('@method.call',        { fg = c.func })
hl('@string',             { fg = c.string })
hl('@type',               { fg = c.type })
hl('@type.builtin',       { fg = c.type })
hl('@variable',           { fg = c.fg })
hl('@variable.builtin',   { fg = c.keyword })
hl('@constant',           { fg = c.constant })
hl('@constant.builtin',   { fg = c.constant })
hl('@comment',            { fg = c.comment })
hl('@decorator',          { fg = c.type })      -- Python decorators
hl('@attribute',          { fg = c.type })      -- Rust/other attributes
hl('@constructor',        { fg = c.type })      -- Class constructors
hl('@tag',                { fg = c.keyword })   -- HTML/JSX tags
hl('@tag.attribute',      { fg = c.type })

-- LSP
hl('DiagnosticError',     { fg = c.error })
hl('DiagnosticWarn',      { fg = c.constant })
hl('DiagnosticInfo',      { fg = c.keyword })
hl('DiagnosticHint',      { fg = c.comment })
