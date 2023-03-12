{ inputs }:
{
  additions = final: _prev: import ../pkgs { pkgs = final; inherit inputs; };
  modifications = final: prev: {
    aster = prev.callPackage ../derivs/aster.nix { };
    st = prev.st.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ prev.harfbuzz ];
      src = prev.fetchFromGitHub {
        owner = "chadcat7";
        repo = "best";
        rev = "b4e13bd68a4dd6e89d691c7a0721ae4c8ffc4908";
        sha256 = "0mjba15phjm4rnwz6ni6731zqw3j3wb6w9pvw0nv8ikj4ncih8r6";
      };
    });
  };
}
