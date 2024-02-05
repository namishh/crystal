{ colors, inputs }:
{
  imports = [
    inputs.sss.nixosModules.home-manager
  ];

  programs.sss = {
    enable = true;

    # General Config
    general = with colors;{
      author = "${name} | chadcat7";
      # copy = true;
      colors = {
        background = "#${accent}";
        author = "#${foreground}";
        shadow = "#${darker}";
      };
      fonts = "Product Sans=18.0";
      radius = 16;
      save-format = "jpeg";
      shadow = true;
      shadow-image = true;
    };
  };
}
