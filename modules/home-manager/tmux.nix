{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    # need cargo for some plugins???
    plugins = [
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.catppuccin
      # pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.weather
      pkgs.tmuxPlugins.cpu
    ];
    enable = true;
    extraConfig = builtins.readFile ../../dotfiles/tmux/tmux.conf;
  };
}

# TODO: install plugins

