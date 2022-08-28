vim.cmd('filetype plugin indent on')
vim.o.hidden = true
vim.o.pumheight = 2
vim.o.fileencoding = 'utf-8'
vim.o.cmdheight = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.opt.termguicolors = true
vim.o.conceallevel = 0
vim.o.showtabline = 2
vim.o.showmode = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 300
vim.o.timeoutlen = 100
vim.o.clipboard = "unnamedplus"
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.scrolloff = 3
vim.o.sidescrolloff = 5
vim.o.mouse = "a"
vim.wo.wrap = false
vim.wo.number = true
vim.o.cursorline = true
vim.o.tabstop = 2
vim.bo.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 0
vim.bo.shiftwidth = 0
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.expandtab = true
vim.opt.fillchars:append('eob: ')
vim.bo.expandtab = true
vim.cmd('colorscheme warm')
vim.opt_local.bufhidden = 'wipe'
vim.opt_local.buflisted = false
vim.cmd('set lazyredraw')
