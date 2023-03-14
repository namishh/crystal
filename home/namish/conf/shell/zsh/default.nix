{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;

    shellAliases = {
      la = "exa -l";
      ls = "ls --color=auto";
      v = "nvim";
      suda = "sudo -E -s";
      nix-pkgs = "nix --extra-experimental-features 'nix-command flakes' search nixpkgs";
    };
    history = {
      expireDuplicatesFirst = true;
      save = 512;
    };
    initExtra = ''
      bindkey  "^[[H"   beginning-of-line
      bindkey  "^[[4~"   end-of-line
      bindkey  "^[[3~"  delete-char
      export PATH=${config.home.homeDirectory}/.local/bin:${config.home.homeDirectory}/.local/share/nvim/mason/bin:$PATH
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$cmd_duration\n[ ](fg:blue)  ";
      git_branch.format = "via [$symbol$branch(:$remote_branch)]($style) ";
      command_timeout = 1000;
    };
  };
}
