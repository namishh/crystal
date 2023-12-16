{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, gtk3
, librsvg
, withWayland ? true
, gtk-layer-shell
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "eww-wayland";
  name = "eww-wayland";

  src = fetchFromGitHub {
    owner = "ralismark";
    repo = "eww";
    rev = "850f18567cbefea3ffc78cdeed978ab2bbd4226e";
    sha256 = "0vvcr220jzsqanz5mgvzkp6k70i60hck91hx9fjvhxd3qb39g2gw";
  };

  cargoHash = "sha256-xT6Z+4QmrSNjTN1cQe9YvwrTXRBnmR8mJoo+OFefM38=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 librsvg ] ++ lib.optional withWayland gtk-layer-shell;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    (if withWayland then "wayland" else "x11")
  ];

  cargoBuildFlags = [ "--bin" "eww" ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda lom ];
    mainProgram = "eww";
    broken = stdenv.isDarwin;
  };
}
