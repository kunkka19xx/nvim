{
  description = "Kunkka nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util"; # show UI app in spotlight search
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, home-manager, ... }:
    let
      # define any local vars for inner expressions
      pkgs = nixpkgs.legacyPackages.${nixpkgs.system};
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs;
          [
            neovim
            tmux
            wezterm
            git
          ];

        # fonts
        fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
        ];

        nix.settings.experimental-features = "nix-command flakes";
        programs.zsh.enable = true; # i am using zshell
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;
        nixpkgs.hostPlatform = "aarch64-darwin"; # aarch for M apple chipset

        #
        # home-manager.users.kunkka = { pkgs, ... }: {
        #   home.username = "haovanngyuen";
        #   home.homeDirectory = "/Users/haovanngyuen"; # Cập nhật cho đúng với user của bạn
        #   programs.zsh.enable = true;
        # };
      };
    in
    # end of the "let" expression, below is the output of the inner expression
      # note: a flake can provide multiple outputs 
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."com-mac" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          mac-app-util.darwinModules.default
        ];
      };

      # Expose the package set, including overlays, for convenience
      darwinPackages = self.darwinConfigurations."com-mac".pkgs;
    };
}
