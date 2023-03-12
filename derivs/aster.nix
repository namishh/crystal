{ lib, stdenv, fetchFromGitHub, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "aster";
  version = "git";

  src = fetchFromGitHub {
    repo = "Aster";
    owner = "TorchedSammy";
    rev = "e00dd55d3200f5b87d7cad6d17005b474b0d4a2d";
    sha256 = "0xa8a8m8bi0b3crs36qh72hnryhjr6r7dzy202sdrvpd29jjgh35";
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
