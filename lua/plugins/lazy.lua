-- Install lazylazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

    -- Theme
    -- { 'catppuccin/nvim',                 name = 'catppuccin', priority = 1000 },
    --  {
    --   "navarasu/onedark.nvim",
    --   priority = 1000, -- make sure to load this before all the other start plugins
    --   config = function()
    --     require('onedark').setup {
    --       style = 'darker'
    --     }
    --     -- Enable theme
    --     require('onedark').load()
    --   end
    -- },
    -- {
    --   "cpea2506/one_monokai.nvim",
    --   config = function()
    --     require("one_monokai").setup()
    --   end,
    --   lazy = false,
    -- },
    {
      "rose-pine/neovim",
      name = "rose-pine",
      config = function()
        vim.cmd("colorscheme rose-pine")
      end
    },
    -- Telescope (fuzzy finder)
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- nvim-tree
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        requires = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end
    },


    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",  -- auto update parsers when plugin updates
      config = function()
        require("plugins.treesitter")  -- loads your config file
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects", -- optional but useful
      },
    },
    -- Bufferline
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

    -- Comment
   {
        'terrortylor/nvim-comment',
        dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
        config = function()
          require("nvim_comment").setup({
            create_mappings = false,
          })
        end
    },

    -- QOL plugins
    { 'mbbill/undotree' },


    -- git
 {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
  },

    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end,
        lazy = false,
    },

     {
      "rmagatti/auto-session",
      opts = {
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        log_level = 'error',
      },
    },

    -- review these below
    {
        'Bekaboo/dropbar.nvim',
        dependencies = {
            -- requires → dependencies; run → build
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }, -- opt is unnecessary in lazy
    },


    { 'tpope/vim-dadbod',                     lazy = false },
    { 'kristijanhusak/vim-dadbod-completion', lazy = false },
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = { 'tpope/vim-dadbod' },
    },


    -- debugger using DAP
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "leoluz/nvim-dap-go",
            "mfussenegger/nvim-dap-python",
            "theHamsta/nvim-dap-virtual-text"
        },
    },

    -- smooth scroll
   {
      "karb94/neoscroll.nvim",
      opts = {},
    },
    { 'gen740/SmoothCursor.nvim',
      config = function()
        require('smoothcursor').setup()
      end
    },
    -- venv - python
    {
      "linux-cultist/venv-selector.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
      cmd = { "VenvSelect", "VenvSelectCached" },  -- creates the commands and lazy-loads on use
      opts = {
        fd_binary_name = "fd" },
    },


    {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      lazy = true,
      config = false,
      init = function()
        -- Disable automatic setup, we are doing it manually
        vim.g.lsp_zero_extend_cmp = 0
        vim.g.lsp_zero_extend_lspconfig = 0
      end,
    },
    {
      'williamboman/mason.nvim',
      config = true,
    },

    -- Supermaven
    {
      "supermaven-inc/supermaven-nvim",
      config = function()
        require("supermaven-nvim").setup({})
      end,
    },
    -- Autocompletion
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        {'L3MON4D3/LuaSnip'},
        {'saadparwaiz1/cmp_luasnip'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
      },
    },

    -- LSP
    {
      'neovim/nvim-lspconfig',
      cmd = {'LspInfo', 'LspInstall', 'LspStart'},
      event = {'BufReadPre', 'BufNewFile'},
      dependencies = {
        {'hrsh7th/cmp-nvim-lsp'},
        {'williamboman/mason-lspconfig.nvim'},
      },
    },

})
