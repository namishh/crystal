{ lib, pkgs }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions =
      let
        createChromiumExtensionFor = browserVersion: { id, sha256, version }:
          {
            inherit id;
            crxPath = builtins.fetchurl {
              url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit sha256;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
      in
      [
        (createChromiumExtension {
          # ublock origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          sha256 = "sha256:10slxkl5zsv0k8nfs9sj8hwhr6ybp0lxhw6nhm0r0w3505a6i95l";
          version = "1.37.2";
        })
        (createChromiumExtension {
          # dark reader
          id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
          sha256 = "sha256:1xw996dmkzsx2pmilb3ivyfnjckm2g1f2sx10yd4nllqbz5076mm";
          version = "4.9.34";
        })
      ];
  };
}
