{ pkgs, ... }:

{
  home.username = "haovanngyuen";
  home.homeDirectory = "/Users/haovanngyuen";
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g prefix C-a
      bind C-a send-prefix
      set -g mouse on
      bind '"' split-window -v
      bind '%' split-window -h
      unbind C-b
      setw -g mode-keys vi
    '';
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
  };
}

