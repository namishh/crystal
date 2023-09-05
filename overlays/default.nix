{ inputs }:
{
  additions = final: _prev: import ../pkgs { pkgs = final; inherit inputs; };
  modifications = final: prev: {
    imgclr = prev.callPackage ../derivs/imagecolorizer.nix {
      buildPythonPackage = prev.python310Packages.buildPythonPackage;
    };
    spotdl = prev.callPackage ../derivs/spotdl.nix {
      buildPythonApplication = prev.python311Packages.buildPythonApplication;
    };
    lutgen = prev.callPackage ../derivs/lutgen.nix { };
    st = prev.st.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ prev.harfbuzz ];
      src = prev.fetchFromGitHub {
        owner = "chadcat7";
        repo = "st";
        rev = "3d9eb51d43981963638a1b5a8a6aa1ace4b90fbb";
        sha256 = "007pvimfpnmjz72is4y4g9a0vpq4sl1w6n9sdjq2xb2igys2jsyg";
      };
    });
    steam = prev.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          keyutils
          libkrb5
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
        ];
    };

  };
}

