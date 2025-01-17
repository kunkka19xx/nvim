{ lib
, config
, pkgs
, ...
}:

{
  home.packages = [
    pkgs.wezterm
  ];
  programs.wezterm.enable = true;
  programs.wezterm.extraConfig = builtins.readFile ../../dotfiles/wezterm/wezterm.lua;
}

# with lib;
#
# let
#   cfg = config.within.wezterm;
# in
# {
#   options.within.wezterm.enable = mkEnableOption "Enables Within's wezterm config";
#
#   config = mkIf cfg.enable {
#     nixpkgs = {
#       overlays = [
#         inputs.brew-nix.overlays.default
#       ];
#     };
#     home.packages = [
#       pkgs.wezterm
#     ];
#     home.file = {
#       ".wezterm.lua" = {
#         source = ../../dotfiles/wezterm/wezterm.lua;
#       };
#     };
#   };
# }
