{ lib, fetchFromGitHub, rustPlatform, pkgs }:
rustPlatform.buildRustPackage rec {
  pname = "lutgen";
  name = "lutgen";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    rev = "628fe661169f1939a8fd81abb2d53d4d4c7064b6";
    sha256 = "1k2lcqpplw3i6babsx0pvmf2rzknfc0kizd2qhp57pxb2i93axcv";
  };
  nativeBuildInputs = with pkgs;[
    cargo
    rustc
  ];
  cargoSha256 = "sha256-BvhEDI2mUtCgmP6hRPniZmxdohaElG/vq/MrLHZgHbU=";
}
