{ stdenvNoCC
, fetchFromGitHub
, pkgs
, colors
,
}:
stdenvNoCC.mkDerivation rec {
  pname = "liblua_pam";
  version = "482071137257e55dac62a510f792104a9d910ea1";

  src = fetchFromGitHub {
    owner = "RMTT";
    repo = "lua-pam";
    rev = version;
    sha256 = "0g5n055gj2ii1pxjfykn3xr0q9knl4hbk0irylsip0r6r76jhz9a";
  };

  installPhase = ''
    cmake . -B build
    cd build
    make
  '';

  nativeBuildInputs = [ pkgs.cmake ];
}
