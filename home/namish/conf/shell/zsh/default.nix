{ config, colors, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = {
      la = "run exa -l";
      ls = "ls --color=auto";
      v = "nvim";
      nf = "run neofetch";
      sa = "pkill ags ; ags & disown";
      suda = "sudo -E -s";
      sh = "swayhide";
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
      export COLS=${colors.background}\ ${colors.foreground}\ ${colors.color1}\ ${colors.color2}\ ${colors.color3}\ ${colors.color4}\ ${colors.color5}\ ${colors.color6}\ ${colors.color7}\ ${colors.color8}\ ${colors.color9}\ ${colors.color10}\ ${colors.color11}\ ${colors.color12}\ ${colors.color13}\ ${colors.color14}\ ${colors.color15}\ ${colors.mbg}\ ${colors.color0}\ ${colors.comment}
      export LD_LIBRARY_PATH=${config.home.homeDirectory}/.config/awesome:${pkgs.lua54Packages.lua}/lib/:${pkgs.pam}/lib
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration\n[ ](fg:blue)  ";
      git_branch.format = "via [$symbol$branch(:$remote_branch)]($style) ";
      command_timeout = 1000;
    };
  };
}
