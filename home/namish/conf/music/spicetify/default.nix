{ colors, spicetify-nix, pkgs }:
let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in

{
  imports = [ spicetify-nix.homeManagerModule ];
  programs.spicetify =
    let
      # use a different version of spicetify-themes than the one provided by
      # spicetify-nix
      officialThemesOLD = pkgs.fetchgit {
        url = "https://github.com/spicetify/spicetify-themes";
        rev = "7e9e898124c96f115dc61fb91d0499ae81f56892";
        sha256 = "06xp6vlbd4kj6vafkc3z2a81xpcwmz62cxilahjsj28110s0hxby";
      };
      # pin a certain version of the localFiles custom app
      localFilesSrc = pkgs.fetchgit {
        url = "https://github.com/hroland/spicetify-show-local-files/";
        rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
        sha256 = "01gy16b69glqcalz1wm8kr5wsh94i419qx4nfmsavm4rcvcr3qlx";
      };
    in
    with colors; {
      spotifyPackage = pkgs.spotify;
      enable = true;
      colorScheme = "custom";
      theme = {
        name = "Dribbblish";
        src = officialThemesOLD;
        requiredExtensions = [
          # define extensions that will be installed with this theme
          {
            # extension is "${src}/Dribbblish/dribbblish.js"
            filename = "dribbblish.js";
            src = "${officialThemesOLD}/Dribbblish";
          }
        ];
        appendName = true; # theme is located at "${src}/Dribbblish" not just "${src}"

        # changes to make to config-xpui.ini for this theme:
        patches = {
          "xpui.js_find_8008" = ",(\\w+=)32,";
          "xpui.js_repl_8008" = ",$\{1}56,";
        };
        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
        sidebarConfig = true;
      };

      customColorScheme = {
        text = "${foreground}";
        subtext = "${color15}";
        sidebar-text = "${color7}";
        main = "${background}";
        sidebar = "${mbg}";
        player = "${bg2}";
        card = "${color0}";
        shadow = "${color8}";
        selected-row = "${color8}";
        button = "${color4}";
        button-active = "${mbg}";
        button-disabled = "${color5}";
        tab-active = "${color4}";
        notification = "${color3}";
        notification-error = "${color1}";
        misc = "${comment}";
      };
      enabledExtensions = with spicePkgs.extensions; [
        playlistIcons
        lastfm
        genre
        historyShortcut
        spicetify-nix.packages.${pkgs.system}.default.extensions.adblock
        hidePodcasts
        fullAppDisplay
        shuffle
      ];
    };
}

