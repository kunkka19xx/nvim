{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.within.tmux;
in
{
  options.within.tmux.enable = mkEnableOption "Enable Tmux configuration with plugins and customizations";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      # Cấu hình trực tiếp trong tmux
      extraConfig = ''
        set -g default-terminal "screen-256color"

        unbind C-b
        set -g prefix C-a
        bind-key C-a send-prefix

        set -g mouse on

        unbind %
        bind '\' split-window -h -c '#{pane_current_path}'

        unbind '"'
        bind - split-window -v -c '#{pane_current_path}'

        unbind r 
        bind r source-file ~/.tmux.conf

        bind -r j resize-pane -D 5
        bind -r k resize-pane -U 5
        bind -r h resize-pane -L 5
        bind -r l resize-pane -R 5

        bind -r m resize-pane -Z

        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection
        unbind -T copy-mode-vi MouseDragEnd1Pane

        bind c new-window -c '#{pane_current_path}'

        set-option -g base-index 1
        set-option -g renumber-windows on

        bind -r e split-window -h "nvim ~/Documents/git/scratch/notes_$(date +'%Y%m%d%H').md"
        bind -r v split-window -h -c "#{pane_current_path}" "zsh -c 'nvim; exec zsh'"

        # Configure the catppuccin plugin
        set -g @catppuccin_flavor "mocha"
        set -g @catppuccin_window_status_style "basic"
        set -g window-status-separator ""  # Removes the space between windows
        set -g @catppuccin_window_current_text_color "#{@thm_surface_1}"
        set -g @catppuccin_window_current_number_color "#{@thm_peach}"
        set -g @catppuccin_window_current_text "#[bg=#{@thm_mantle}] #{b:pane_current_path}"
        set -g @catppuccin_window_text " #W"
        set -g @catppuccin_window_default_text "#W"
        set -g @catppuccin_window_number_color "#{@thm_lavender}"
        set -g status-left "#[bg=#{@thm_green},fg=#{@thm_crust}]#[reverse]█#[noreverse]#S "
        set -g status-style fg=default,bg=default 
        set -g status-interval 60
        set -g status-right-length 80
        set -g status-right 'Kunkka 😛 '
        set -agF status-right "#{E:@catppuccin_status_weather}"
        set -agF status-right "#{E:@catppuccin_status_cpu}"
        set -agF status-right "#[bg=#{@thm_green},fg=#{@thm_crust}]#[reverse]#[noreverse]󰘛 "
        set -agF status-right "#[fg=#{@thm_fg},bg=#{@thm_mantle}] #(memory_pressure | awk '{print 100 - $5}')%\%"
        set -agF status-right "#[bg=#{@thm_green},fg=#{@thm_crust}]#[reverse]#[noreverse]󰢗 "
        set -agF status-right "#[fg=#{@thm_fg},bg=#{@thm_mantle}] %y/%m/%d:%H"

        set -g status-bg default
        set -g status-style bg=default
      '';

      # Plugins
      plugins = with pkgs.tmuxPlugins; [
        tmux-navigator
        tmux-resurrect
        tmux-cpu
        tmux-weather
      ];
    };
  };
}

