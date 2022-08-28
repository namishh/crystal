-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/namish/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/namish/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/namish/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/namish/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/namish/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["alpha-nvim"] = {
    config = { "\27LJ\2\nT\0\0\4\0\3\0\a5\0\0\0006\1\1\0009\1\2\1\21\3\0\0B\1\2\0028\1\1\0L\1\2\0\vrandom\tmath\1\5\0\0\vString\15Identifier\fKeyword\vNumber�\1\0\0\t\0\r\0\0216\0\0\0009\0\1\0006\2\2\0B\0\2\2\21\0\0\0006\1\3\0009\1\4\1'\3\5\0B\1\2\0026\2\0\0009\2\6\2B\2\1\2'\3\a\0009\4\b\2'\5\t\0009\6\n\2'\a\t\0009\b\v\2&\3\b\3'\4\f\0L\4\2\0\6 \npatch\nminor\6.\nmajor\f   v\fversion\31 %d-%m-%Y   %H:%M:%S\tdate\aos\19packer_plugins\rtbl_keys\bvim�\20\1\0\f\0&\1L6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\3\0009\2\4\0026\4\5\0009\4\6\4B\4\1\0A\2\0\0013\2\a\0003\3\b\0005\4\t\0009\5\n\0019\5\v\5=\4\f\0059\5\n\0019\5\v\0059\5\r\5\18\6\2\0B\6\1\2=\6\14\0059\5\n\0019\5\15\0054\6\6\0009\a\16\1'\t\17\0'\n\18\0'\v\19\0B\a\4\2>\a\1\0069\a\16\1'\t\20\0'\n\21\0'\v\22\0B\a\4\2>\a\2\0069\a\16\1'\t\23\0'\n\24\0'\v\25\0B\a\4\2>\a\3\0069\a\16\1'\t\26\0'\n\27\0'\v\28\0B\a\4\2>\a\4\0069\a\16\1'\t\29\0'\n\30\0'\v\31\0B\a\4\0?\a\0\0=\6\f\0059\5\n\0019\5 \5\18\6\3\0B\6\1\2=\6\f\0059\5\n\0019\5 \0059\5\r\5'\6!\0=\6\14\0059\5\"\0009\a\r\1B\5\2\0016\5#\0009\5$\5'\a%\0B\5\2\1K\0\1\0003 autocmd FileType alpha setlocal nofoldenable \bcmd\bvim\nsetup\rConstant\vfooter\f:qa<cr>\14  Quit\6q#:e ~/.config/nvim/init.lua<cr>\21  Edit Config\15Leader + E\29:Telescope live_grep<cr>\19  Find Word\15Leader + R\31:Telescope find_files <cr>\19  Find File\15Leader + F\24:NvimTreeToggle<cr>\23  File Explorer\rCtrl + B\vbutton\fbuttons\ahl\topts\bval\vheader\fsection\1\16\0\0_                                    ██████                                    o                                ████▒▒▒▒▒▒████                                w                              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                                          ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                            w                          ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒                                                        ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓                                                    ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓                                                  ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██                        �\1                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        �\1                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        �\1                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        �\1                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        �\1                        ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██                        �\1                        ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██                        k                        ██      ██      ████      ████                        \0\0\ttime\aos\15randomseed\tmath\27alpha.themes.dashboard\nalpha\frequire\v����\4\0" },
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["bufferline.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-vsnip"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/cmp-vsnip",
    url = "https://github.com/hrsh7th/cmp-vsnip"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["lsp-colors.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/lsp-colors.nvim",
    url = "https://github.com/folke/lsp-colors.nvim"
  },
  ["lsp-format.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/lsp-format.nvim",
    url = "https://github.com/lukas-reineke/lsp-format.nvim"
  },
  ["lspkind.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/lspkind.nvim",
    url = "https://github.com/onsails/lspkind.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag",
    url = "https://github.com/windwp/nvim-ts-autotag"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["presence.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/presence.nvim",
    url = "https://github.com/andweeb/presence.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["toggleterm.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  ["which-key.nvim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  },
  ["yuck.vim"] = {
    loaded = true,
    path = "/home/namish/.local/share/nvim/site/pack/packer/start/yuck.vim",
    url = "https://github.com/elkowar/yuck.vim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
try_loadstring("\27LJ\2\nT\0\0\4\0\3\0\a5\0\0\0006\1\1\0009\1\2\1\21\3\0\0B\1\2\0028\1\1\0L\1\2\0\vrandom\tmath\1\5\0\0\vString\15Identifier\fKeyword\vNumber�\1\0\0\t\0\r\0\0216\0\0\0009\0\1\0006\2\2\0B\0\2\2\21\0\0\0006\1\3\0009\1\4\1'\3\5\0B\1\2\0026\2\0\0009\2\6\2B\2\1\2'\3\a\0009\4\b\2'\5\t\0009\6\n\2'\a\t\0009\b\v\2&\3\b\3'\4\f\0L\4\2\0\6 \npatch\nminor\6.\nmajor\f   v\fversion\31 %d-%m-%Y   %H:%M:%S\tdate\aos\19packer_plugins\rtbl_keys\bvim�\20\1\0\f\0&\1L6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\3\0009\2\4\0026\4\5\0009\4\6\4B\4\1\0A\2\0\0013\2\a\0003\3\b\0005\4\t\0009\5\n\0019\5\v\5=\4\f\0059\5\n\0019\5\v\0059\5\r\5\18\6\2\0B\6\1\2=\6\14\0059\5\n\0019\5\15\0054\6\6\0009\a\16\1'\t\17\0'\n\18\0'\v\19\0B\a\4\2>\a\1\0069\a\16\1'\t\20\0'\n\21\0'\v\22\0B\a\4\2>\a\2\0069\a\16\1'\t\23\0'\n\24\0'\v\25\0B\a\4\2>\a\3\0069\a\16\1'\t\26\0'\n\27\0'\v\28\0B\a\4\2>\a\4\0069\a\16\1'\t\29\0'\n\30\0'\v\31\0B\a\4\0?\a\0\0=\6\f\0059\5\n\0019\5 \5\18\6\3\0B\6\1\2=\6\f\0059\5\n\0019\5 \0059\5\r\5'\6!\0=\6\14\0059\5\"\0009\a\r\1B\5\2\0016\5#\0009\5$\5'\a%\0B\5\2\1K\0\1\0003 autocmd FileType alpha setlocal nofoldenable \bcmd\bvim\nsetup\rConstant\vfooter\f:qa<cr>\14  Quit\6q#:e ~/.config/nvim/init.lua<cr>\21  Edit Config\15Leader + E\29:Telescope live_grep<cr>\19  Find Word\15Leader + R\31:Telescope find_files <cr>\19  Find File\15Leader + F\24:NvimTreeToggle<cr>\23  File Explorer\rCtrl + B\vbutton\fbuttons\ahl\topts\bval\vheader\fsection\1\16\0\0_                                    ██████                                    o                                ████▒▒▒▒▒▒████                                w                              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                                          ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                            w                          ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒                                                        ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓                                                    ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓                                                  ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██                        �\1                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        �\1                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        �\1                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        �\1                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        �\1                        ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██                        �\1                        ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██                        k                        ██      ██      ████      ████                        \0\0\ttime\aos\15randomseed\tmath\27alpha.themes.dashboard\nalpha\frequire\v����\4\0", "config", "alpha-nvim")
time([[Config for alpha-nvim]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
