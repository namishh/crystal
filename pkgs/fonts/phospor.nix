{ lib
, stdenvNoCC
, fetchzip
, pkgs
, util-linux
}:

stdenvNoCC.mkDerivation rec {
  pname = "phosphor-icons";
  version = "dev";

  src = fetchzip {
    url = "https://github.com/phosphor-icons/homepage/releases/download/v1.4.0/phosphor-icons.zip";
    sha256 = "sha256-Jhk5yiGHEygFF7oruVpwQXXLjlj1enpv9a9pK2ptZ6w=";
    stripRoot = false;
  };

  nativeBuildInputs = [ util-linux ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/
    install -Dm755 $src/"Icon Font"/Font/Phosphor.ttf $out/share/fonts
    runHook postInstall
  '';

  meta = {
    description = "Phosphor icons";
    homepage = "https://github.com/phosphor-icons/homepage";
    maintainers = [ lib.maintainers.phosphor-icons ];
  };
}
