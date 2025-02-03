{ lib
, config
, pkgs
, ...
}:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    checkConfig = false;
    extraConfig = builtins.readFile ../../dotfiles/sway/config;
  };
  programs.waybar = {
    enable = true;
    # configFile = ./waybar-config.json;
    # styleFile = ./waybar-style.css; 
  };
}

