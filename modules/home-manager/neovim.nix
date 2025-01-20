{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.within.neovim;
in
{
  options.within.neovim.enable = mkEnableOption "Enables Within's Neovim config";

  config = mkIf cfg.enable {
    programs.neovim.enable = true;
    programs.neovim.viAlias = true;
    programs.neovim.vimAlias = true;
    programs.neovim.vimdiffAlias = true;
    programs.neovim.plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
    programs.neovim.extraPackages = [
      pkgs.nodePackages_latest.vscode-json-languageserver
      pkgs.lua-language-server
      pkgs.luajitPackages.jsregexp
      pkgs.nil
      pkgs.go
      pkgs.gopls
      pkgs.gofumpt
      pkgs.stylua
      pkgs.python3
      pkgs.basedpyright
      pkgs.pyright
      pkgs.ruff
      pkgs.nixfmt-rfc-style
      pkgs.zls
      pkgs.ripgrep
      # fix bug lazy-luarocks
      # pkgs.luarocks
      pkgs.lua51Packages.lua
      pkgs.lua51Packages.luarocks
      pkgs.cargo #install mason
      pkgs.unzip #install java
    ];
    home.file = {
      ".config/nvim" = {
        source = ../../dotfiles/nvim;
        recursive = true;
      };
      /*       ".config/nvim/lazy-lock.json" = {
        source = ../../dotfiles/nvim/lazy-lock.json;
        recursive = true;
      */
    };
  };
}
# TODO: add conditions for nixos
