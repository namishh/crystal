{ inputs }:
{
  additions = final: _prev: import ../pkgs { pkgs = final; inherit inputs; };
  modifications = final: prev: {
    spotdl = prev.callPackage ../derivs/spotdl.nix {
      buildPythonApplication = prev.python311Packages.buildPythonApplication;
    };

    st = prev.st.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ prev.harfbuzz ];
      src = prev.fetchFromGitHub {
        owner = "chadcat7";
        repo = "st";
        rev = "3d9eb51d43981963638a1b5a8a6aa1ace4b90fbb";
        sha256 = "007pvimfpnmjz72is4y4g9a0vpq4sl1w6n9sdjq2xb2igys2jsyg";
      };
    });

    dockbarx = prev.dockbarx.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "xuzhen";
        repo = "dockbarx";
        rev = "31209c2f96eeb97e8755893c7b026bec8b2d53bd";
        sha256 = "1v92fshpzf2762kgk841q4cbakhyf726wl35s3y94ar5drk604pw";
      };
      postPatch = ''
        substituteInPlace setup.py \
          --replace /usr/ "" \
          --replace '"/", "usr", "share",' '"share",'

        for f in \
          utils/dbx_preference \
          dockbarx/applets.py \
          dockbarx/dockbar.py \
          dockbarx/iconfactory.py \
          dockbarx/theme.py
        do
          substituteInPlace $f --replace /usr/share/ $out/share/
        done
      '';
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
