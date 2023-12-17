{ lib, buildPythonPackage, fetchFromGitHub, pkgs, ... }:

buildPythonPackage rec {
  pname = "imagecolorizer";
  version = "git";
  preBuild = ''
    cat > setup.py << EOF
    from setuptools import setup
    setup(
        name='ImageColorizer',
        version='1.2',
        packages=['ImageColorizer'],
        entry_points={
            'console_scripts': ['ImageColorizer = ImageColorizer.__main__:main']
        }
    )
    EOF
  '';
  propagatedBuildInputs = with pkgs;[
    python310Packages.pillow
  ];
  src = fetchFromGitHub {
    repo = "ImageColorizer";
    owner = "kiddae";
    rev = "48623031e3106261093723cd536a4dae74309c5d";
    sha256 = "0ai4i3qmk55z3zc2gd8nicgx04pmfxl5wcq43ryy6l4c6gj2ik5r";
  };
  meta = {
    description = "ImageColorizer is a Python module and a CLI tool that you can easily use to colorize wallpapers for them to fit a terminal colorscheme.";
    homepage = "https://github.com/kiddae/ImageColorizer";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
