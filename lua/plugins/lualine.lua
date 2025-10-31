
local function diff_source()
  -- use gitsigns counts if available
  local g = vim.b.gitsigns_status_dict
  if g then
    return { added = g.added, modified = g.changed, removed = g.removed }
  end
end

require('lualine').setup({
  options = {
    theme = 'auto',
    globalstatus = true,
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators   = { left = '', right = '' },
    disabled_filetypes   = { statusline = { 'alpha' } },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'branch', icon = '' },
      { 'diff', source = diff_source },               -- from gitsigns
      { 'diagnostics', sources = { 'nvim_diagnostic' } },
    },
    lualine_c = { { 'filename', path = 1 } },         -- 0=name, 1=relative, 2=absolute
    lualine_x = { 'encoding', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {}, lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'location' },
    lualine_y = {}, lualine_z = {},
  },
  extensions = { 'nvim-tree', 'quickfix', 'fugitive' },
})

