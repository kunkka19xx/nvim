{ pkgs, ... }:

let
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "v2.1.2";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "v2.1.2";
      sha256 = "sha256-....";
    };
  };

  vimTmuxNavigator = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "vim-tmux-navigator";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "christoomey";
      repo = "vim-tmux-navigator";
      rev = "master";
      sha256 = "sha256-....";
    };
  };

  tmuxResurrect = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-resurrect";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-resurrect";
      rev = "master";
      sha256 = "sha256-....";
    };
  };

  tmuxCpu = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-cpu";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cpu";
      rev = "master";
      sha256 = "sha256-....";
    };
  };

  tmuxWeather = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-weather";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "xamut";
      repo = "tmux-weather";
      rev = "master";
      sha256 = "sha256-....";
    };
  };
in
{
  programs.tmux = {
    enable = true;

    aggressiveResize = true;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    newSession = true;
    secureSocket = true;
    shell = "${pkgs.zsh}/bin/zsh";
    shortcut = "a";
    terminal = "screen-256color";

    # List of plugins
    plugins = [
      catppuccin
      vimTmuxNavigator
      tmuxResurrect
      tmuxCpu
      tmuxWeather
    ];

    # Tmux configuration
    extraConfig = ''
      # Set default terminal
      set -g default-terminal "screen-256color"

      # Prefix key configuration
      unbind C-b
      set -g prefix C-a
      bind-key C-a send-prefix

      # Mouse support
      set -g mouse on

      # Keybindings for splitting windows
      unbind %
      bind '\' split-window -h -c '#{pane_current_path}'
      unbind '"'
      bind - split-window -v -c '#{pane_current_path}'

      # Reload configuration
      unbind r
      bind r source-file ~/.tmux.conf

      # Resize panes
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r h resize-pane -L 5
      bind -r l resize-pane -R 5
      bind -r m resize-pane -Z

      # Vim-style copy mode
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection

      # New window with current path
      bind c new-window -c '#{pane_current_path}'

      # Start from 1 for windows
      set-option -g base-index 1
      set-option -g renumber-windows on

      # Open a note for billion $ idea
      bind -r e split-window -h "nvim ~/Documents/git/scratch/notes_$(date +'%Y%m%d%H').md"
      bind -r v split-window -h -c "#{pane_current_path}" "zsh -c 'nvim; exec zsh'"

      # Keybindings for pane navigation and switching windows
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind -n S-Left previous-window
      bind -n S-Right next-window
      bind -n M-H previous-window
      bind -n M-L next-window

      # Status bar setup for Catppuccin plugin
      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_window_status_style "basic"
      set -g @catppuccin_window_current_text_color "#{@thm_surface_1}"
      set -g @catppuccin_window_current_number_color "#{@thm_peach}"
      set -g @catppuccin_window_current_text "#[bg=#{@thm_mantle}] #{b:pane_current_path}"

      set -g status-left "#[bg=#{@thm_green},fg=#{@thm_crust}]#[reverse]█#[noreverse]#S "
      set -g status-style fg=default,bg=default
      set -g status-interval 60
      set -g status-right-length 80
      set -g status-right 'Kunkka 😛 '
      set -agF status-right "#{E:@catppuccin_status_weather}"
      set -agF status-right "#{E:@catppuccin_status_cpu}"
      set -agF status-right "#[bg=#{@thm_green},fg=#{@thm_crust}]#[reverse]#[noreverse]󰘛 "
      set -agF status-right "#[fg=#{@thm_fg},bg=#{@thm_mantle}] #(memory_pressure | awk '{print 100 - $5}')"\%%" "
      set -agF status-right "#[bg=#{@thm_green},fg=#{@thm_crust}]#[reverse]#[noreverse]󰢗 "
      set -agF status-right "#[fg=#{@thm_fg},bg=#{@thm_mantle}] %y/%m/%d:%H"

      # Load the Catppuccin plugin
      run-shell ${catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
    '';
  };
}

