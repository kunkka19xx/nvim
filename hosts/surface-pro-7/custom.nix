{
	config, pkgs, inputs, lib, ...
}: 
{
	imports = [./../../modules/home-manager/default.nix
	inputs.home-manager.nixosModules.home-manager];
	within.neovim.enable = true;
	within.tmux.enable = true;
nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  users.users.kunkka07xx.packages = lib.mkDefault [
    pkgs.vim
    pkgs.alsa-tools
    pkgs.home-manager
  ];

  # Shell Envs
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = [
    pkgs.zig
  ];
    nixpkgs.config.allowUnfreePredicate = (_: true);
  boot.loader.systemd-boot.configurationLimit = 5;
  # Garbage Collector Setting
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";
}
