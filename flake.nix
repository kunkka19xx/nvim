{
  description = "Kunkka nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util"; # show UI app in spotlight search
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware"; # Add nixos-hardware
  };

  outputs =
    { self
    , nix-darwin
    , nixpkgs
    , mac-app-util
    , home-manager
    , nixos-hardware
    , ...
    }@inputs:
    let
      mkNixosConfig =
        system: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs system; };
          modules = extraModules;
        };
      mkHmConfig =
        pkgs: extraModules:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = extraModules;
        };
    in
    {
      darwinConfigurations = {
        com-mac = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            mac-app-util.darwinModules.default
            ./users/hvn/system.nix
          ];
        };
      };
      nixosConfigurations = {
        surface = mkNixosConfig "x86_64-linux" [
          ./nixos/surface-pro-7/configuration.nix
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
          # nixos-hardware.nixosModules.microsoft-surface-common
        ];
        configuration = {
          microsoft-surface.ipts.enable = true;
          microsoft-surface.surface-control.enable = false;
        };
      };
      homeConfigurations = {
        "com-mac" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            mac-app-util.homeManagerModules.default
            ./users/hvn/haovanngyuen.nix
          ];
        };
        "kunkka07xx-linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./users/kunkka-linux/kunkka07xx-linux.nix
          ];
        };
      };
    };
}
