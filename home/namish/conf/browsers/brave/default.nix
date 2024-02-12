{ pkgs }:
{
  programs.brave = {
    enable = true;
    package = pkgs.brave.overrideAttrs (oldAttrs: {
      commandLineArgs = [
    "--ozone-platform-hint=auto"
  ];
    });
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "iaddfgegjgjelgkanamleadckkpnjpjc"; } # Auto Quality for YouTube
      { id = "annfbnbieaamhaimclajlajpijgkdblo"; } # Dark Theme
    ];

  };
}
