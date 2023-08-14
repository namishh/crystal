{ pkgs, ... }:
let
  t-smart-tmux-session-manager = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "t-smart-tmux-session-manager";
    version = "2023-08-04";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "t-smart-tmux-session-manager";
      rev = "8c887534d0f59cdde2aef873052d59efacdb7b2a";
      sha256 = "sha256-PGemYYjyWbHmNvEflK51PdY8oKI/1DZMU5OBjKH9DLw=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    extraConfig = ''
      set -g history-file "~/.cache/tmux/.tmuxhistory"
      set -g repeat-time 700
      set -g mouse on
      set -g status on
      set -g focus-events on
      set -g automatic-rename on
      set -g renumber-windows on
      set -g monitor-activity on
      set -g visual-activity off
      set -g bell-action none
      set -g mode-keys vi
      set -g status-keys vi
      set -g base-index 1
      set -g pane-base-index 1
      set -g escape-time 0
      set -g history-limit 10000
      set -g pane-border-style "bg=default,fg=black"
      set -g pane-active-border-style "bg=default,fg=green"

      set-option -sa terminal-features ",wezterm:RGB"
      set -g default-terminal "xterm-256color"

      # make colors inside tmux look the same as outside of tmux
      # see https://github.com/tmux/tmux/issues/696
      # see https://stackoverflow.com/a/41786092
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      bind-key R source-file "~/.config/tmux/tmux.conf" \; display-message "Reloaded configurations!"
      bind-key B set status

      set -g prefix C-a
      unbind C-b
      bind-key C-a send-prefix
      set -g detach-on-destroy off

      unbind-key up
      unbind-key down
      unbind-key left
      unbind-key t
      unbind-key up
      unbind-key x
      unbind-key <
      unbind-key >

      unbind %
      bind-key - split-window -v
      unbind '"'
      bind-key | split-window -h

      bind-key x kill-pane
      bind-key & kill-window

      bind-key > swap-pane -D
      bind-key < swap-pane -U

      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5
      bind -r m resize-pane -Z

      set -g mode-style "bg=default,fg=default"
      set -g status-position bottom
      set -g status-interval 5
      set -g @emulate-scroll-for-no-mouse-alternate-buffer on
      set -sa terminal-overrides ",*:dim=\\E[2m"
      set -g status-justify centre
      set -g status-left "#[fg=black,bg=green]   #[fg=green,bg=red]#{prefix_highlight}#[bg=default]"
      set -g window-status-format "#[fg=magenta,bg=black] #I:#W #[bg=default,fg=black]"
      set -g window-status-current-format "#[bg=magenta,fg=black] #I:#W #[bg=default,fg=black] #[bg=black,fg=red] #S #[bg=red,fg=black]   "
      set -g status-right "#[bg=black,fg=green] %I:%M %p #[fg=green,bg=black]█"

      set -g status-bg default
      set -g status-fg white
      set -g status-style "fg=white,bg=default"

    '';
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_prefix_prompt "MOD"
          set -g @prefix_highlight_copy_prompt "COPY"
          set -g @prefix_highlight_sync_prompt " "
          set -g @prefix_highlight_bg "black"
          set -g @prefix_highlight_fg "red"
          set -g @prefix_highlight_empty_attr "fg=black,bg=red"
          set -g @prefix_highlight_copy_mode_attr "fg=blue,bg=black"
          set -g @prefix_highlight_sync_mode_attr "fg=black,bg=green"
          set -g @prefix_highlight_show_copy_mode on
          set -g @prefix_highlight_show_sync_mode on
          set -g @prefix_highlight_empty_has_affixes off
          set -g @prefix_highlight_output_prefix ""
          set -g @prefix_highlight_output_suffix ""
          set -g @prefix_highlight_empty_prompt ""
        '';
      }
      {
        plugin = t-smart-tmux-session-manager;
        extraConfig = "set -g @t-bind 'T'";
      }
      {
        plugin = tmuxPlugins.vim-tmux-navigator;
      }
    ];
  };
  home.packages = with pkgs; [
    t-smart-tmux-session-manager.src
  ];
}
