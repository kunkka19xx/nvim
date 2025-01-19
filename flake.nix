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
  };

  outputs =
    { self
    , nix-darwin
    , nixpkgs
    , mac-app-util
    , home-manager
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
    # end of the "let" expression, below is the output of the inner expression
      # note: a flake can provide multiple outputs 
    {
      darwinConfigurations = {
        com-mac = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users."haovanngyuen" = import ./users/haovanngyen.nix;
            }
          ];
        };
      };
      nixosConfigurations = {
        surface = mkNixosConfig "x86_64-linux" [
          ./nixos/surface-pro-7/configuration.nix
        ];
      };
      homeConfigurations = {
        "com-mac" = home-manager.lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages.${nixpkgs.system};
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./users/haovanngyuen.nix
          ];
        };
        "kunkka07xx-linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./users/kunkka07xx-linux.nix
          ];
        };
      };
    };
}
