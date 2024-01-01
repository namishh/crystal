{ pkgs, colors }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      dotenv.dotenv-vscode
      christian-kohler.path-intellisense
      formulahendry.auto-rename-tag
      formulahendry.auto-close-tag
      pkief.material-icon-theme
      zhuangtongfa.material-theme
      ms-python.python
      jnoortheen.nix-ide
      vspacecode.whichkey
      unifiedjs.vscode-mdx
      astro-build.astro-vscode
      bradlc.vscode-tailwindcss
      ritwickdey.liveserver
      oderwat.indent-rainbow
      naumovs.color-highlight
    ];
    userSettings = with colors;{
      "editor.fontFamily" = "'Iosevka Nerd Font', 'monospace', monospace";
      "editor.fontSize" = 16;
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "files.autoSave" = "afterDelay";
      "editor.wordWrap" = "on";
      "editor.cursorBlinking" = "phase";
      "workbench.list.smoothScrolling" = true;
      "editor.smoothScrolling" = true;
      "editor.lineHeight" = 1.6;
      "editor.fontLigatures" = true;
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.tokenColorCustomizations" = {
        "comments" = "#${comment}";
        "functions" = "#${color9}";
        "numbers" = "#${color11}";
        "variables" = "#${color5}";
        "keywords" = "#${color14}";
        "strings" = "#${color10}";
        "types" = "#${color6}";
        "textMateRules" = [
          {
            "scope" = [ "invalid" "invalid.illegal" ];
            "settings" = {
              "foreground" = "#${color1}";
            };
          }
          {
            "scope" = [ "keyword" "storage.type" "storage.modifier" ];
            "settings" = {
              "foreground" = "#${color5}";
            };
          }
          {
            "scope" = [
              "keyword.control"
              "constant.other.color"
              "punctuation"
              "meta.tag"
              "punctuation.definition.tag"
              "punctuation.separator.inheritance.php"
              "punctuation.definition.tag.html"
              "punctuation.definition.tag.begin.html"
              "punctuation.definition.tag.end.html"
              "punctuation.section.embedded"
            ];
            "settings" = {
              "foreground" = "#${color3}";
            };
          }
          {
            "scope" = [
              "entity.name.tag"
              "meta.tag.sgml"
              "markup.deleted.git_gutter"
            ];
            "settings" = {
              "foreground" = "#${color4}";
            };
          }
          {
            "scope" = [
              "entity.name.function"
              "meta.function-call"
              "variable.function"
              "support.function"
              "keyword.other.special-method"
            ];
            "settings" = {
              "foreground" = "#${color9}";
            };
          }
          {
            "scope" = [
              "meta.block variable.other"
            ];
            "settings" = {
              "foreground" = "#${color4}";
            };
          }
          {
            "scope" = [
              "meta.block variable.other"
            ];
            "settings" = {
              "foreground" = "#${color4}";
            };
          }
          {
            "scope" = [
              "constant.numeric"
              "constant.language"
              "support.constant"
              "constant.character"
              "constant.escape"
              "variable.parameter"
              "keyword.other.unit"
              "keyword.other"
            ];
            "settings" = {
              "foreground" = "#${color6}";
            };
          }
          {
            "scope" = [
              "string"
              "constant.other.symbol"
              "constant.other.key"
              "entity.other.inherited-class"
              "markup.heading"
              "markup.inserted.git_gutter"
              "meta.group.braces.curly constant.other.object.key.js string.unquoted.label.js"
            ];
            "settings" = {
              "foreground" = "#${color2}";
            };
          }
          {
            "scope" = [
              "entity.name"
              "support.type"
              "support.class"
              "support.other.namespace.use.php"
              "meta.use.php"
              "support.other.namespace.php"
              "markup.changed.git_gutter"
              "support.type.sys-types"
            ];
            "settings" = {
              "foreground" = "#${color4}";
            };
          }
        ];
      };
      "workbench.colorCustomizations" = {
        "list.activeSelectionBackground" = "#${mbg}";
        "list.hoverBackground" = "#${mbg}";
        "editorWidget.background" = "#${mbg}";
        "panel.background" = "#${mbg}";
        "titleBar.activeBackground" = "#${mbg}";
        "breadcrumbPicker.background" = "#${mbg}";
        "settings.dropdownBackground" = "#${mbg}";
        "settings.numberInputBackground" = "#${mbg}";
        "settings.textInputBackground" = "#${mbg}";
        "settings.checkboxBackground" = "#${mbg}";
        "editor.background" = "#${background}";
        "tab.activeBackground" = "#${darker}";
        "tab.inactiveBackground" = "#${background}";
        "sideBar.background" = "#${darker}";
        "sideBar.dropBackground" = "#${darker}";
        "sideBarSectionHeader.background" = "#${darker}";
        "activityBar.background" = "#${darker}";
        "statusBar.background" = "#${darker}";
        "scrollbarSlider.activeBackground" = "#${darker}";
        "tab.activeBorder" = "#${background}00";
        "editorGroupHeader.tabsBackground" = "#${background}";
        "statusBar.noFolderBackground" = "#${background}";
        "tab.border" = "#${background}";
        "editorHoverWidget.background" = "#${background}";
        "menu.background" = "#${background}";
        "debugToolBar.background" = "#${background}";
        "editorBracketMatch.background" = "#${background}";
        "quickInput.background" = "#${background}";
        "editorOverviewRuler.border" = "#${background}";
        "notifications.background" = "#${background}";
        "breadcrumb.background" = "#${background}";
        "terminal.background" = "#${background}";
        "terminal.foreground" = "#${foreground}";
        "terminal.selectionBackground" = "#${color0}";
        "terminal.ansiBlack" = "#${color8}";
        "terminal.ansiRed" = "#${color1}";
        "terminal.ansiGreen" = "#${color2}";
        "terminal.ansiYellow" = "#${color3}";
        "terminal.ansiBlue" = "#${color4}";
        "terminal.ansiMagenta" = "#${color5}";
        "terminal.ansiCyan" = "#${color6}";
        "terminal.ansiWhite" = "#${color7}";
        "terminal.ansiBrightBlack" = "#${color8}";
        "terminal.ansiBrightRed" = "#${color9}";
        "terminal.ansiBrightGreen" = "#${color10}";
        "terminal.ansiBrightYellow" = "#${color11}";
        "terminal.ansiBrightBlue" = "#${color12}";
        "terminal.ansiBrightMagenta" = "#${color13}";
        "terminal.ansiBrightCyan" = "#${color14}";
        "terminal.ansiBrightWhite" = "#${color15}";
      };
    };
  };
}
