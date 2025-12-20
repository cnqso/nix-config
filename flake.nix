{
  description = "5starcrest NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, niri, ... }@inputs: {
    nixosConfigurations = {
      crest = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          niri.nixosModules.niri
          ./hosts/crest/disks.nix
          ./hosts/crest/default.nix
        ];
      };

      ste = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          niri.nixosModules.niri
          ./hosts/ste/disks.nix
          ./hosts/ste/default.nix
        ];
      };
    };
  };
}
