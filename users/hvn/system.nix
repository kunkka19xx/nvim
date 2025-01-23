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
  ];
  homebrew = {
    enable = true;
    casks = [
      "firefox"
    ];
    brews = [
      "staticcheck"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };

  system.stateVersion = 5;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}

