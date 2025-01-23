# system.nix
{ config, pkgs, ... }:
# Import homebrew packages from the separate file
{
  # TODO: Add system pks and setting
  # migrate some settings from home to here
  environment.systemPackages = with pkgs; [
    pre-commit
    tldr
    git
    colima
    docker
    docker-compose
  ];
  homebrew = {
    enable = true;
    casks = [
      "firefox"
      "obsidian"
      "obs"
    ];
    brews = [
      "staticcheck"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };

  system.stateVersion = 5;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}

