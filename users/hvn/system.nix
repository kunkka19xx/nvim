# system.nix
{ config, pkgs, ... }:
# Import homebrew packages from the separate file
{
  # TODO: Add system pks and setting
  # migrate some settings from home to here
  environment.systemPackages = with pkgs; [
  ];
  homebrew = {
    enable = true;
    casks = [ "firefox" ];
    onActivation.cleanup = "zap";
  };

  system.stateVersion = 5;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}

