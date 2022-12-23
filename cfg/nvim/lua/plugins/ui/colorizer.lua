require'colorizer'.setup()

vim.defer_fn(function()
  require("colorizer").attach_to_buffer(0)
end, 0)
