{
  description = "Kunkka nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util"; #show UI app in spotlight search
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util }:
    let
      # define any local vars for inner expressions
      pkgs = nixpkgs.legacyPackages.${nixpkgs.system}.pkgs;
      tmux = import ./pkg/tmux.nix { inherit pkgs; };
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

        programs.tmux = {
          enable = true;
          plugins = tmux.plugins;
          extraConfig = tmux.extraConfig;
        };

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;
        programs.zsh.enable = true; # i am using zshell

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin"; # aarch for M apple chipset
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
