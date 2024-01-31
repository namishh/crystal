{
  description = "i have no idea how this works";

  inputs =
    {
      # Package sources.
      master.url = "github:nixos/nixpkgs/master";
      stable.url = "github:nixos/nixpkgs/nixos-22.11";
      unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager";
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      spicetify-nix.url = "github:the-argus/spicetify-nix";

      nur.url = "github:nix-community/NUR";

      nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
      nix-gaming.url = "github:fufexan/nix-gaming";

      hyprland-plugins = {
        url = "github:hyprwm/hyprland-plugins";
      };
      hyprland.url = "github:hyprwm/Hyprland";

      ags.url = "github:ozwaldorf/ags";

      darkmatter.url = "gitlab:VandalByte/darkmatter-grub-theme";

      matugen = {
        url = "github:/InioX/Matugen";
      };

      swayfx.url = "github:/WillPower3309/swayfx";

      sss.url = "github:/SergioRibera/sss";
    };
  outputs = { self, nixpkgs, ... } @inputs:
    let
      inherit (self) outputs;
      forSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      overlays = import ./overlays { inherit inputs; };
      # host configurations
      nixosConfigurations = {
        frostbyte = nixpkgs.lib.nixosSystem
          {
            specialArgs = {
              inherit inputs outputs;
            };
            modules = [
              # > Our main nixos configuration file <
              inputs.home-manager.nixosModule
              inputs.darkmatter.nixosModule
              ./hosts/frostbyte/configuration.nix
            ];
          };
      };

      homeConfigurations = {
        namish = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs self; };
          modules = [
            ./home/namish/home.nix
          ];
        };
      };

      frostbyte = self.nixosConfigurations.frostbyte.config.system.build.toplevel;
    };
}
