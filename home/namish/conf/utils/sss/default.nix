{ colors, inputs }:
{
  imports = [
    inputs.sss.nixosModules.home-manager
  ];

  programs.sss = {
    enable = true;

    # General Config
    general = with colors;{
      author = "${name}";
      # copy = true;
      colors = {
        background = "#${darker}";
        author = "#${foreground}";
        shadow = "#${darker}";
      };
      fonts = "Product Sans=12.0";
      radius = 8;
      save-format = "jpeg";
      shadow = true;
      shadow-image = true;
    };
  };
}
