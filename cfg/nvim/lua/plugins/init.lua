-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'norcalli/nvim-colorizer.lua'
  use {'nvim-treesitter/nvim-treesitter', run = ":TSUpdate"}
  use {'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}
  use {'windwp/nvim-ts-autotag'}
  use {'p00f/nvim-ts-rainbow'}
  use { "windwp/nvim-autopairs" }
  use {
  'kyazdani42/nvim-tree.lua',
  requires = {
    'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
  }
  use "folke/which-key.nvim"
  use 'nvim-lua/plenary.nvim'
  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup()
  end
  }
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'onsails/lspkind.nvim'
  use 'akinsho/toggleterm.nvim'
  use 'andweeb/presence.nvim'
  use "williamboman/nvim-lsp-installer"
  use "elkowar/yuck.vim"
  use "lukas-reineke/lsp-format.nvim"
  use 'folke/lsp-colors.nvim'
  use(
    {
        "goolord/alpha-nvim",
        requires = {"kyazdani42/nvim-web-devicons"},
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            math.randomseed(os.time())

            local function pick_color()
                local colors = {"String", "Identifier", "Keyword", "Number"}
                return colors[math.random(#colors)]
            end

            local function footer()
                local total_plugins = #vim.tbl_keys(packer_plugins)
                local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
                local version = vim.version()
                local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

                return " "
            end

            local logo = {
    [[                                    ██████                                    ]],
    [[                                ████▒▒▒▒▒▒████                                ]],
    [[                              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                              ]],
    [[                            ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                            ]],
    [[                          ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒                              ]],
    [[                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓                          ]],
    [[                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓                          ]],
    [[                        ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██                        ]],
    [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
    [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
    [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
    [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
    [[                        ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██                        ]],
    [[                        ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██                        ]],
    [[                        ██      ██      ████      ████                        ]],
            }

            dashboard.section.header.val = logo
            dashboard.section.header.opts.hl = pick_color()

            dashboard.section.buttons.val = {
                dashboard.button("Ctrl + B", "  File Explorer", ":NvimTreeToggle<cr>"),
                dashboard.button("Leader + F", "  Find File", ":Telescope find_files <cr>"),
                dashboard.button("Leader + R", "  Find Word", ":Telescope live_grep<cr>"),
                dashboard.button("Leader + E", "  Edit Config", ":e ~/.config/nvim/init.lua<cr>"),
                dashboard.button("q", "  Quit", ":qa<cr>")
            }

            dashboard.section.footer.val = footer()
            dashboard.section.footer.opts.hl = "Constant"

            alpha.setup(dashboard.opts)

            vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
        end
    }
  )
end)

