local wezterm = require("wezterm")

local function font_with_fallback(name, params)
  local names = { name }
  return wezterm.font_with_fallback(names, params)
end

local font_name = "Fantasque Sans M Nerd Font"

return {
  -- OpenGL for GPU acceleration, Software for CPU
  front_end = "OpenGL",
  cell_width = 0.9,

  -- Font config
  font = font_with_fallback(font_name),
  font_rules = {
    {
      italic = true,
      font = font_with_fallback(font_name, { italic = true }),
    },
    {
      italic = true,
      intensity = "Bold",
      font = font_with_fallback(font_name, { italic = true, bold = true }),
    },
    {
      intensity = "Bold",
      font = font_with_fallback(font_name, { bold = true }),
    },
    {
      italic = true,
      font = font_with_fallback(font_name, { italic = true }),
    },
  },
  initial_rows = 18,
  initial_cols = 85,
  dpi = 96.0,
  bold_brightens_ansi_colors = true,
  warn_about_missing_glyphs = false,
  font_size = 14,
  line_height = 1.25,

  -- Cursor style
  default_cursor_style = "BlinkingUnderline",

  -- X11
  enable_wayland = false,

  colors = {
    foreground = "#575279",
    background = "#faf4ed",
    cursor_bg = "#575279",
    cursor_fg = "#faf4ed",
    cursor_border = "#faf4ed",
    selection_fg = "#faf4ed",
    selection_bg = "#575279",
    scrollbar_thumb = "#575279",
    split = "#faf4ed",
    ansi = { "#f2e9e1", "#b4637a", "#286983", "#ea9d34", "#56949f", "#907aa9", "#d7827e", "#9893a5" },
    brights = { "#f2e9e1", "#b4637a", "#286983", "#ea9d34", "#56949f", "#907aa9", "#d7827e", "#9893a5" },
    indexed = { [136] = "#575279" },
    tab_bar = {
      active_tab = {
        bg_color = "#dfdad9",
        fg_color = "#575279",
        italic = true,
      },
      inactive_tab = { bg_color = "#dfdad9", fg_color = "#f2e9e1" },
      inactive_tab_hover = { bg_color = "#f2e9e1", fg_color = "#dfdad9" },
      new_tab = { bg_color = "#f2e9e1", fg_color = "#dfdad9" },
      new_tab_hover = { bg_color = "#6791c9", fg_color = "#dfdad9" },
    },
  },

  -- Padding
  window_padding = {
    left = 32,
    right = 32,
    top = 32,
    bottom = 32,
  },

  -- Tab Bar
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  show_tab_index_in_tab_bar = false,
  tab_bar_at_bottom = true,

  -- General
  automatically_reload_config = true,
  inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
  window_background_opacity = 1.0,
  window_close_confirmation = "NeverPrompt",
  window_frame = { active_titlebar_bg = "#faf4ed", font = font_with_fallback(font_name, { bold = true }) },
}
