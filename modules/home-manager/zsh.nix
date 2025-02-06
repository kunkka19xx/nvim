{ lib
, config
, pkgs
, commands
, ...
}:

with lib;

let
  cfg = config.within.zsh;
in
{
  options.within.zsh.enable = mkEnableOption "Enables ZSH Settings";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.bat
      pkgs.ripgrep #grep string telescope
      pkgs.zsh-powerlevel10k
    ];
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      # autosuggestion Configuration Options
      autosuggestion.enable = true;
      autosuggestion.strategy = [
        "history"
        "completion"
      ];
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
        ];
      };
      history = {
        size = 50000;
        save = 50000;
        path = "${config.xdg.dataHome}/zsh/history";
        append = true;
        expireDuplicatesFirst = true;
        share = true;
      };
      shellAliases = {
        dc = "docker-compose";
        rm = "rm -i";
        k = "kubectl";
        v = "nvim";
        op = "cd ~/Documents/git && echo 'Went to the git folder'";
        fp = "fzf --preview='bat --color=always {}'";
        fv = "nvim $(fzf -m --preview='bat --color=always {}')";
        gcof = "git fetch && git checkout $(git branch | fzf | sed 's/^..//')";
      };
    };
  };
}
