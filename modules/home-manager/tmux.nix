{ config, pkgs, lib, ... }:

{
  programs.tmux.enable = true;
  programs.tmux.extraConfig = builtins.readFile ../../dotfiles/tmux/tmux.conf;
}

# TODO: install plugins

