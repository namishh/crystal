{ config, colors, ... }:

let inherit (config.lib.formats.rasi) mkLiteral; in
with colors; {
  "*" = {
    bg = mkLiteral "#${background}";
    fg = mkLiteral "#${foreground}";
    button = mkLiteral "#${contrast}";
    background-color = mkLiteral "@bg";
    text-color = mkLiteral "@fg";
  };

  "#window" = {
    transparency = "real";
    border-color = mkLiteral "@button";
    border-radius = mkLiteral "0px";
    border = mkLiteral "2px";
    width = mkLiteral "600px";
  };
  "#mainbox" = {
    children = map mkLiteral [ "inputbar" "listview" ];
  };

  "#inputbar" = {
    children = map mkLiteral [ "prompt" "entry" ];
    border-radius = mkLiteral "0px 0px 8px 8px";
    padding = mkLiteral "10px";
    background-color = mkLiteral "@button";
  };
  "#prompt" = {
    enabled = false;
  };
  "#entry" = {
    placeholder = "Search";
    placeholder-color = mkLiteral "@fg";
    expand = false;
    border-radius = mkLiteral "8px";
    padding = mkLiteral "1.5%";
    background-color = mkLiteral "@button";
  };

  "#listview" = {
    columns = 1;
    lines = 6;
    cycle = true;
    dynamic = true;
    layout = mkLiteral "vertical";
    padding = mkLiteral "3% 1.5% 3% 1.5%";
  };

  "#element" = {
    orientation = mkLiteral "horizontal";
    border-radius = mkLiteral "8px";
    padding = mkLiteral "1.5% 0% 1.5% 0%";
  };
  "#element-text" = {
    expand = true;
    vertical-align = mkLiteral "0.5";
    margin = mkLiteral "5px 2px";
    background-color = mkLiteral "inherit";
    text-color = mkLiteral "inherit";
  };
  "#element-icon" = {
    background-color = mkLiteral "transparent";
    size = mkLiteral "30px";
    margin = mkLiteral "0 6px 0 12px";
  };
  "#element selected" = {
    background-color = mkLiteral "@button";
    border-radius = mkLiteral "8px";
  };
}

