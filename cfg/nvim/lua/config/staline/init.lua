require('staline').setup {
    defaults = {
        expand_null_ls = false,  -- This expands out all the null-ls sources to be shown
        left_separator  = "  ",
        right_separator = "",
        full_path       = false,
        line_column = "[%l/%L] :%c",


        fg              = "#0f0f0f",  -- Foreground text color.
        bg              = "#0f0f0f",     -- Default background is transparent.
        inactive_color  = "#212126",
        inactive_bgcolor = "none",
        true_colors     = true,      -- true lsp colors.
        font_active     = "none",     -- "bold", "italic", "bold,italic", etc

        mod_symbol      = "*",
        lsp_client_symbol = "",
        branch_symbol   = " ",
        cool_symbol     = "   ",       -- Change this to override default OS icon.
        null_ls_symbol = "",          -- A symbol to indicate that a source is coming from null-ls
    },
    mode_colors = {
        n = "#6d92b7",
        i = "#74be88",
        c = "#da696d",
        V = "#e1b56a",
        v = "#e1b56a",
    },
    mode_icons = {
        n = "  NORMAL ",
        i = "  INSERT ",
        c = "  COMMAND ",
        V = "  SELECT",
        v = "  BLOCK "
    },
    sections = {
        left = { '-mode','left_sep_double', {'StalineFilename', 'file_name'}, {"StalineBranch", "branch"}, ' ', 'lsp' },
        mid  = { ' ' },
        right = { {'StalineLogo', 'cool_symbol'}, {'StalineFolderSep', 'right_sep'}, {'StalineFolderIcon','  '}, {'StalineFolderText', 'cwd'}, ' ',  {"StalineProgressSep",'right_sep'}, {"StalineProgressSepIcon",'  '}, {'StalineProgress', 'line_column'} },
    },
    special_table = {
        NvimTree = { 'NvimTree', ' ' },
        packer = { 'Packer',' ' },
        toggleterm = {'Terminal', "  "}-- etc
    },
    lsp_symbols = {
        Error="  ",
        Info="  ",
        Warn="  ",
        Hint=" ",
    },
}
