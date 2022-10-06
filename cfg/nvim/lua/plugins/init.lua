vim.cmd [[packadd packer.nvim]]
return require('packer').startup({ function(use)
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    event = "UIEnter",
    branch = "dev",
    config = "require('plugins.ui.bufferline')"
  }
  use {
    'wbthomason/packer.nvim',
    cmd = 'require("plugins.commands").packer'
  }
  use {
    'lewis6991/impatient.nvim'
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = "require('plugins.ui.colorizer')",
    event = { "UIEnter" }
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ":TSUpdate",
    module = "nvim-treesitter",
    event = "BufRead",
    cmd = 'require("plugins.commands").treesitter',
    config = "require('plugins.treesitter.treesitter')"
  }
  use {
    'windwp/nvim-ts-autotag',
    event = "InsertEnter",
    after = "nvim-treesitter"
  }
  use {
    'kyazdani42/nvim-tree.lua',
    cmd = "NvimTreeToggle",
    config = "require('plugins.utils.nvim-tree')"
  }
  use { "kyazdani42/nvim-web-devicons", event = "BufWinEnter", config = "require('plugins.ui.devicons')",
    module = "nvim-web-devicons", }
  use {
    'windwp/nvim-autopairs',
    config = "require('plugins.treesitter.autopair')",
    after = "nvim-cmp"
  }
  use {
    "folke/which-key.nvim",
    module = "which-key",
    keys = { "<leader>", '"', "'", "`" },
    config = "require('plugins.utils.which-key')"
  }
  use {
    'nvim-lua/plenary.nvim',
    event = "BufWinEnter",
  }
  use {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    config = "require('plugins.utils.telescope')"
  }
  use {
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = "require('plugins.ui.alpha')",
    cmd = {
      "Alpha",
      "AlphaRedraw"
    },
    event = "BufWinEnter"
  }
  use {
    'neovim/nvim-lspconfig',
    opt = true,
    config = "require('plugins.lsp.lspconfig')",
    event = "BufEnter"
  }
  use {
    'rafamadriz/friendly-snippets',
    event = "InsertEnter"
  }
  use { 'hrsh7th/nvim-cmp',
    after = "friendly-snippets",
    config = "require('plugins.lsp.cmp')"
  }
  use {
    'L3MON4D3/LuaSnip',
    after = "nvim-cmp",
    config = "require('plugins.lsp.luasnip')"
  }
  use {
    'saadparwaiz1/cmp_luasnip',
    after = "LuaSnip"
  }
  use {
    'hrsh7th/cmp-nvim-lua',
    after = "cmp_luasnip"
  }
  use {
    'hrsh7th/cmp-nvim-lsp',
    after = "cmp-nvim-lua"
  }
  use {
    'hrsh7th/cmp-buffer',
    after = "cmp-nvim-lsp"
  }
  use {
    'hrsh7th/cmp-path',
    after = "cmp-buffer"
  }
  use { "dstein64/vim-startuptime", cmd = "StartupTime" }
  use { "williamboman/mason.nvim",
    cmd = {
      "MasonInstall",
      "MasonUninstall",
      "Mason",
      "MasonUninstallAll",
      "MasonLog",
    },
    config = "require('plugins.lsp.mason')",
  }
  use {
    "akinsho/toggleterm.nvim",
    config = "require('plugins.utils.toggleterm')",
    event = "BufWinEnter"
  }
  use { "lewis6991/gitsigns.nvim",
    event = "BufWinEnter",
    ft = "gitcommit",
    config = function()
      require('gitsigns').setup()
    end }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = "require('plugins.ui.indentlines')",
    event = "BufWinEnter"
  }
  use {
    "terrortylor/nvim-comment",
    config = "require('plugins.utils.comments')",
    event = "BufWinEnter"
  }
  -- End Of Plugins
end,
})
