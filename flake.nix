{
  description = "i have no idea how this works";

  inputs = {
    # Package sources.
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-22.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    # Channel to follow.
    home-manager.inputs.nixpkgs.follows = "unstable";
    nixpkgs.follows = "unstable";
  };
  outputs = { self, nixpkgs, home-manager, ... } @inputs:
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
        starfall = nixpkgs.lib.nixosSystem
          {
            specialArgs = {
              inherit inputs outputs home-manager;
            };
            modules = [
              # > Our main nixos configuration file <
	            home-manager.nixosModule
              ./hosts/starfall/configuration.nix
            ];
          };
      };
      home-manager = home-manager.packages.${nixpkgs.system}."home-manager";
      # user configurations
      homeConfigurations = {
        namish = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs home-manager self; };
          modules = [
            ./home/namish/home.nix
          ];
        };
      };
      starfall = self.nixosConfigurations.starfall.config.system.build.toplevel;
    };
}
