{ pkgs, ... }:

{
  imports = [
    ./../modules/home-manager/default.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kunkka07xx";
  home.homeDirectory = "/Users/kunkka07xx";

  # Custom Modules that I'm enabling
  within.neovim.enable = true;
  within.zsh.enable = true;
  home.stateVersion = "24.05"; # Please read the comment before changing.
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.vim
    pkgs.git
    pkgs.nerd-fonts.inconsolata
    # pkgs.nerd-fonts.maple-mono
    pkgs.rcm
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
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
