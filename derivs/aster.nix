{ lib, stdenv, fetchFromGitHub, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "aster";
  version = "git";

  src = fetchFromGitHub {
    repo = "Aster";
    owner = "TorchedSammy";
    rev = "e00dd55d3200f5b87d7cad6d17005b474b0d4a2d";
    sha256 = "0wyj4y8bzlicr617r2mrdrw81rpz0v4s0xb3nk0g22k5vxnsipln";
  };

  buildInputs = [
    pkgs.go
  ];

  installPhase = ''
    go get -d
    go build -o $out/bin/aster
  '';

  meta = {
    description = "Simple command line tool to recolor images into a specific palette.";
    homepage = "https://github.com/TorchedSammy/aster";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
