local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Lua
require("lsp-colors").setup({
  Error = "#df5b61",
  Warning = "#deb26a",
  Information = "#659bdb",
  Hint = "#6ec587"
})
