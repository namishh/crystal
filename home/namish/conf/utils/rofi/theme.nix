{ config, colors, ... }:

let inherit (config.lib.formats.rasi) mkLiteral; in
with colors;
{

  "configuration" = {
    modi = "drun,run,filebrowser,window";
    show-icons = true;
    display-drun = "APPS";
    display-run = "RUN";
    display-filebrowser = "FILES";
    display-window = "WINDOW";
    drun-display-format = "{name}";
    window-format = "{w} · {c} · {t}";
  };

  "*" = {
    background = "#${background}";
    background-alt = "#${mbg}";
    foreground = "#${foreground}";
    selected = "#${color4}";
    active = "#${color2}";
    urgent = "#${color1}";
  };

  "window" = {
    transparency = "real";
    border-color = mkLiteral "@selected";
    border-radius = mkLiteral "0px";
    border = mkLiteral "2px";
    enabled = true;
    width = mkLiteral "1000px";
  };
  "mainbox" = {
    enabled = true;
    orientation = "horizontal";
    children = [ "imagebox" "listbox" ];
  };
  "imagebox" = {
    padding = "20px";
    background-color = "transparent";
    # background-image = "url(\"~/.config/rofi/menu.png\", height)";
    orientation = "vertical";
    children = [ "inputbar" "dummy" "mode-switcher" ];
  };
  "listbox" = {
    spacing = "20px";
    padding = "20px";
    background-color = "transparent";
    orientation = "vertical";
    children = [ "message" "listview" ];
  };

  "dummy" = {
    background-color = "transparent";
  };

  "inputbar" = {
    enabled = true;
    spacing = "10px";
    padding = "15px";
    border-radius = "10px";
    background-color = "@background-alt";
    text-color = "@foreground";
    children = [ "textbox-prompt-colon" "entry" ];
  };

  "textbox-prompt-colon" = {
    enabled = true;
    expand = false;
    str = "";
    background-color = "inherit";
    text-color = "inherit";
  };
  "entry" = {
    enabled = true;
    background-color = "inherit";
    text-color = "inherit";
    cursor = "text";
    placeholder = "Search";
    placeholder-color = "inherit";
  };

  "mode-switcher" = {
    enabled = true;
    spacing = "20px";
    background-color = "transparent";
    text-color = "@foreground";
  };
  "button" = {
    padding = "15 px";
    border-radius = "10 px";
    background-color = "@background-alt";
    text-color = "inherit";
    cursor = "pointer";
  };
  "button selected" = {
    background-color = "@selected";
    text-color = "@foreground";
  };
  "listview" = {
    enabled = true;
    columns = 1;
    lines = 8;
    cycle = true;
    dynamic = true;
    scrollbar = false;
    layout = "vertical";
    reverse = false;
    fixed-height = true;
    fixed-columns = true;

    spacing = "10px";
    background-color = "transprent";
    text-color = "@foreground";
    cursor = "default";
  };

  "element" = {
    enabled = true;
    spacing = "15px";
    padding = "8px";
    border-radius = "10px";
    background-color = "transprent";
    text-color = "@foreground";
    cursor = "pointer";
  };
  "element normal.normal" = {
    background-color = "inherit";
    text-color = "inherit";
  };
  "element normal.urgent" = {
    background-color = "@urgent";
    text-color = "@foreground";
  };
  "element normal.active" = {
    background-color = "active";
    text-color = "@foreground";
  };
  "element selected.normal" = {
    background-color = "@selected";
    text-color = "@foreground";
  };
  "element selected.urgent " = {
    background-color = "@urgent";
    text-color = "@foreground";
  };
  "element selected.active" =
    {
      background-color = "@urgent";
      text-color = "@foreground";
    };
  "element-icon" = {
    background-color = "transprent";
    text-color = "inherit";
    size = "32px";
    cursor = "inherit";
  };
  "element-text" = {
    background-color = "transprent";
    text-color = "inherit";
    cursor = "inherit";
    vertical-align = "0.5";
    horizontal-align = "0.0";
  };
  "message" = {
    background-color = "transprent";
  };
  "textbox" = {
    padding = "15px";
    border-radius = "10px";
    background-color = "@background-alt";
    text-color = "@foreground";
    vertical-align = "0.5";
    horizontal-align = "0.0";
  };
  "error-message" = {
    padding = "15px";
    border-radius = "20px";
    background-color = "@background";
    text-color = "@foreground";
  };
}

