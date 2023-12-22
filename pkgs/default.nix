# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{ pkgs ? (import ../nixpkgs.nix) { }, inputs }: {
  # example = pkgs.callPackage ./example { };
  phospor = pkgs.callPackage ./fonts/phospor.nix { };
  material-symbols = pkgs.callPackage ./fonts/material-symbols.nix { };
  lutgen = pkgs.callPackage ./others/lutgen.nix { };
  imgclr = pkgs.callPackage ./others/imagecolorizer.nix {
    buildPythonPackage = pkgs.python310Packages.buildPythonPackage;
  };
}
