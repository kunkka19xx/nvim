{ pkgs, ... }:

{
  imports = [
    ./../modules/home-manager/default.nix
    ./langs.nix
  ];
  home.username = "kunkka07xx";
  home.homeDirectory = "/Users/kunkka07xx";

  within.neovim.enable = true;
  within.zsh.enable = true;
  home.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.vim
    pkgs.git
    pkgs.nerd-fonts.inconsolata
    # pkgs.nerd-fonts.maple-mono
    pkgs.rcm
  ];

  home.file = {
    ".config/rcm/bindings.conf".text = ''
      .txt = ${pkgs.neovim}/bin/nvim
    '';
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
