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
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, niri, stylix, ... }@inputs:
    let
      mkPkgs = system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            # Ren'Py pulls in python ecdsa which nixpkgs marks insecure; allow it explicitly.
            permittedInsecurePackages = [ "python3.12-ecdsa-0.19.1" ];
            allowInsecurePredicate = pkg:
              let
                name = nixpkgs.lib.getName pkg;
                fullName = pkg.name or "";
              in
              name == "broadcom-sta" || fullName == "python3.12-ecdsa-0.19.1";
          };
        };
    in
    {
    nixosConfigurations = {
      crest = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = mkPkgs "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          niri.nixosModules.niri
          stylix.nixosModules.stylix
          ./hosts/crest/disks.nix
          ./hosts/crest/default.nix
        ];
      };

      gluee = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = mkPkgs "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          niri.nixosModules.niri
          stylix.nixosModules.stylix
          ./hosts/gluee/disks.nix
          ./hosts/gluee/default.nix
        ];
      };

      ste = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = mkPkgs "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          niri.nixosModules.niri
          stylix.nixosModules.stylix
          ./hosts/ste/disks.nix
          ./hosts/ste/default.nix
        ];
      };
    };
  };
}
