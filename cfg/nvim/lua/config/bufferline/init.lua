require("bufferline").setup{}

vim.cmd[[
nnoremap <silent>[b :BufferLineCycleNext<CR>
nnoremap <silent>]b :BufferLineCyclePrev<CR>
]]

