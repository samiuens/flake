{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.smi.shell;
in
{
  options.smi.shell = {
    tmux.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable tmux";
    };

    neovim.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neovim as the default editor";
    };

    starship.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Starship prompt";
    };
  };

  config = {
    programs = {
      fish = {
        enable = true;

        shellAbbrs = {
          ll = "eza -lah --icons --git";
          ls = "eza --icons";
        };

        interactiveShellInit = ''
          set -g fish_greeting ""

          # Tmux auto-attach: neue Session falls keine existiert, sonst attach
          if status is-interactive && not set -q TMUX
            exec tmux new-session -A -s main
          end
        '';

        plugins = [
          {
            name = "done";
            inherit (pkgs.fishPlugins.done) src;
          }
          {
            name = "sponge";
            inherit (pkgs.fishPlugins.sponge) src;
          }
        ];
      };

      eza = {
        enable = true;
        enableFishIntegration = false;
      };

      starship = lib.mkIf cfg.starship.enable {
        enable = true;
        enableFishIntegration = true;
      };

      neovim = lib.mkIf cfg.neovim.enable {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
      };

      tmux = lib.mkIf cfg.tmux.enable {
        enable = true;
        mouse = true;
        prefix = "C-b";
        terminal = "tmux-256color";
        historyLimit = 10000;
        keyMode = "vi";
        escapeTime = 0;
        baseIndex = 1;

        plugins = with pkgs.tmuxPlugins; [
          sensible
          resurrect
          continuum
          yank
          open
        ];

        extraConfig = ''
          setw -g pane-base-index 1

          # Fenster und Panes mit aktuellem Pfad öffnen
          bind c new-window -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"
          bind '"' split-window -v -c "#{pane_current_path}"

          # Intuitivere Split-Shortcuts (| = vertikal, - = horizontal)
          bind | split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"

          # Pane-Navigation mit vim-Tasten (mit Prefix)
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          # Pane-Navigation mit Alt+Pfeiltasten (ohne Prefix)
          bind -n M-Left select-pane -L
          bind -n M-Right select-pane -R
          bind -n M-Up select-pane -U
          bind -n M-Down select-pane -D

          # Automatisches Umbenennen von Fenstern verhindern
          set-option -g allow-rename off

          # Bell-/Aktivitätsbenachrichtigungen deaktivieren
          set -g visual-activity off
          set -g visual-bell off
          set -g bell-action none

          # Status Bar
          set -g status-position bottom
          set -g status-interval 1
          set -g status-left "#{pane_title} "
          set -g status-left-length 50
          set -g status-right "#{host}"
          set -g status-right-length 50

          # Theme (TmuxAI)
          set -g status-style bg=black,fg=green
          set -g pane-border-style fg=colour237
          set -g pane-active-border-style fg=green
          set -g message-style bg=black,fg=green
          setw -g window-status-format "#[fg=colour237,bg=black]#[fg=white,bg=colour237] #I #[fg=white,bg=colour237] #W #[fg=colour237,bg=black]"
          setw -g window-status-current-format "#[fg=black,bg=green]#[fg=black,bg=green] #I #[fg=black,bg=green,bold] #W #[fg=green,bg=black]"

          # True-Color-Support
          set -as terminal-features ",xterm-256color:RGB"

          # Continuum: automatisch speichern und nach Reboot wiederherstellen.
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '1'
        '';
      };
    };
  };
}
