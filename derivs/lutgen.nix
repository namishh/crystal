{ lib, fetchFromGitHub, rustPlatform, pkgs }:
rustPlatform.buildRustPackage rec {
  pname = "lutgen";
  name = "lutgen";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    rev = "621db41b10e5a1a923ef67094ce1fc05c618d6ae";
    sha256 = "0dwj3cksf62z89ihqnhhxj1wgzjqqwlc40hwdfw18yqwr3byzfxf";
  };
  nativeBuildInputs = with pkgs;[
    cargo
    rustc
  ];
  cargoSha256 = "sha256-s5ejGEFMxDg+ENLg0Y1ZXgk2bDyy4H5C7tNMjVEp8kY=";
}
