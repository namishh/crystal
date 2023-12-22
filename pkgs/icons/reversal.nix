{ lib, stdenv, fetchFromGitHub, pkg-config, gdk-pixbuf, optipng, librsvg, gtk3, pantheon, gnome, gnome-icon-theme, hicolor-icon-theme, pkgs }:
stdenv.mkDerivation rec {
  pname = "reversal";
  name = "reversal";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Reversal-icon-theme";
    rev = "bdae2ea365731b25a869fc2c8c6a1fb849eaf5b2";
    sha256 = "0hfhsqpi3c569gx34vkbn70lx0g0vhkwwffcjf98vycj1j1bbpq9";
  };
  nativeBuildInputs = [
    pkg-config
    gdk-pixbuf
    librsvg
    pkgs.gnused
    optipng
    gtk3
  ];

  dontPatchELF = true;
  dontRewriteSymlinks = true;
  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    ./install.sh -d $out/share/icons -blue
    runHook postInstall
  '';
}

