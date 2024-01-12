# in home.nix
{ pkgs, inputs, ... }:
{
  programs.ags = {
    enable = true;
    # packages to add to gjs's runtime
    extraPackages = [ pkgs.libsoup_3 ];
  };
}
