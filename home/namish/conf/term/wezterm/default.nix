{ pkgs, colors, inputs, ... }:

with colors; {
  programs.wezterm = {
    enable = true;
    colorSchemes = import ./colors.nix {
      inherit colors;
    };
    package = inputs.nixpkgs-f2k.packages.${pkgs.system}.wezterm-git;
    extraConfig = ''
      local wez = require('wezterm')
      return {
        default_prog     = { 'zsh' },
        cell_width = 0.85,
        -- Performance
        --------------
        front_end        = "WebGpu",
        enable_wayland   = true,
        scrollback_lines = 1024,
        -- Fonts
        --------
        font         = wez.font_with_fallback({ 
          "Iosevka Nerd Font",
          "Material Design Icons",
        }),
        initial_rows = 18,
        initial_cols = 85,
        dpi = 96.0,
        bold_brightens_ansi_colors = true,
        font_rules    = {
          {
            italic = true,
            font   = wez.font("Iosevka Nerd Font", { italic = true })
          }
        },
        --font_antialias = "Subpixel",
        --font_hinting = "VerticalSubpixel",
        font_size         = 14.0,
        line_height       = 1.15,
        harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
        -- Bling
        --------
        color_scheme   = "followSystem",
        window_padding = {
          left = "32pt", right = "32pt",
          bottom = "32pt", top = "32pt"
        },
        default_cursor_style = "SteadyUnderline",
        enable_scroll_bar    = false,
        warn_about_missing_glyphs = false,
        -- Tabbar
        ---------
        enable_tab_bar               = true,
        use_fancy_tab_bar            = false,
        hide_tab_bar_if_only_one_tab = true,
        show_tab_index_in_tab_bar    = false,
        -- Miscelaneous
        ---------------
        window_close_confirmation = "NeverPrompt",
        inactive_pane_hsb         = { 
          saturation = 1.0, brightness = 0.8
        },
        check_for_updates = false,
        window_background_opacity = 1
      }
    '';
  };
}
