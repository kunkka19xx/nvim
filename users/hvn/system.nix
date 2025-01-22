# system.nix
{ config, pkgs, ... }:

{
  # TODO: Add system pks and setting
  # migrate some settings from home to here
  environment.systemPackages = with pkgs; [
  ];
  system.stateVersion = 5;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  # inputs = {
  #   nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  #
  #   # Optional: Declarative tap management
  #   homebrew-core = {
  #     url = "github:homebrew/homebrew-core";
  #     flake = false;
  #   };
  #   homebrew-cask = {
  #     url = "github:homebrew/homebrew-cask";
  #     flake = false;
  #   };
  #   homebrew-bundle = {
  #     url = "github:homebrew/homebrew-bundle";
  #     flake = false;
  #   };
  #
  #   # (...)
  # };
}

