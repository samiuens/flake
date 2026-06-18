{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.smi.shell;
  accent = cfg.tmux.accentColor;

  tn = {
    bg = "#1a1b26";
    bgDark = "#16161e";
    bgHl = "#292e42";
    fg = "#c0caf5";
    comment = "#565f89";
    cyan = "#7dcfff";
    magenta = "#bb9af7";
    green = "#9ece6a";
    red = "#f7768e";
    yellow = "#e0af68";
  };

  gitmuxConfig = pkgs.writeText "gitmux.conf" ''
    tmux:
      styles:
        branch: "#[fg=${accent},bold]"
        remote: "#[fg=${tn.cyan}]"
        staged: "#[fg=${tn.green}]"
        modified: "#[fg=${tn.yellow}]"
        untracked: "#[fg=${tn.magenta}]"
        conflict: "#[fg=${tn.red},bold]"
        clean: "#[fg=${tn.green}]"
      options:
        branch_max_len: 20
        hide_clean: false
  '';

  smoothScrollPlugin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "smooth-scroll";
    rtpFilePath = "smooth-scroll.tmux";
    version = "unstable-2024";
    src = pkgs.fetchFromGitHub {
      owner = "azorng";
      repo = "tmux-smooth-scroll";
      rev = "2d686bc5b696c0e66173997e5141b14c8bedd973";
      sha256 = "0ycvy0v41ihvrs6giw1kw0cam693frfqrx0zc47k1m8f2g94lfzq";
    };
    postInstall = "patchShebangs $out";
  };

  tmuxPicker = pkgs.writeShellScript "tmux-session-picker" ''
    result="$(${pkgs.tmux}/bin/tmux list-sessions -F '#{session_name}' | ${pkgs.fzf}/bin/fzf \
      --ansi --reverse --no-sort --cycle \
      --border rounded --border-label ' tmux sessions ' \
      --prompt 'session ❯ ' --pointer '▌' \
      --header 'enter: wechseln · ctrl-n: neu · ctrl-x: schließen' \
      --preview '${pkgs.tmux}/bin/tmux capture-pane -ep -t {}' \
      --preview-window 'right,60%,border-left' \
      --color 'bg+:${tn.bgHl},fg+:${tn.fg},hl:${accent},hl+:${tn.cyan},border:${tn.comment},label:${accent},preview-border:${tn.comment},prompt:${tn.magenta},pointer:${tn.red},header:${tn.comment},info:${tn.comment}' \
      --bind 'ctrl-x:execute-silent(${pkgs.tmux}/bin/tmux kill-session -t {})+reload(${pkgs.tmux}/bin/tmux list-sessions -F "#{session_name}")' \
      --print-query --expect=ctrl-n)" || true

    query="$(printf '%s\n' "$result" | sed -n 1p)"
    key="$(printf '%s\n' "$result" | sed -n 2p)"
    choice="$(printf '%s\n' "$result" | sed -n 3p)"

    if [ "$key" = "ctrl-n" ]; then
      name="$(printf '%s' "$query" | tr ' .:' '---')"
      if [ -n "$name" ]; then
        ${pkgs.tmux}/bin/tmux new-session -d -s "$name" 2>/dev/null || true
        exec ${pkgs.tmux}/bin/tmux switch-client -t "$name"
      fi
    elif [ -n "$choice" ]; then
      exec ${pkgs.tmux}/bin/tmux switch-client -t "$choice"
    fi
  '';
in
{
  config.programs.tmux = lib.mkIf cfg.tmux.enable {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
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
      smoothScrollPlugin
    ];

    extraConfig = ''
      # tmux-sensible überschreibt default-shell auf macOS mit zsh; Fish danach
      # wieder erzwingen, da extraConfig nach den Plugins geladen wird.
      set -g default-command "${pkgs.fish}/bin/fish -l"

      setw -g pane-base-index 1

      bind c new-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      unbind t
      bind t display-popup -E -w 70% -h 70% "${tmuxPicker}"
      bind T display-popup -E -w 70% -h 70% "${tmuxPicker}"

      bind N command-prompt -p "Neue Session:" "{ if-shell -F \"#{==:%%,}\" \"display-message \\\"Name erforderlich\\\"\" \"new-session -d -s \\\"%%\\\" ; switch-client -t \\\"%%\\\"\" }"
      bind X confirm-before -p "Session #S schließen? (y/n)" kill-session

      set-option -g allow-rename off

      set -g visual-activity off
      set -g visual-bell off
      set -g bell-action none

      set -g status-position bottom
      set -g status-interval 5
      set -g status-justify left
      set -g status-style bg=${tn.bgDark},fg=${tn.fg}

      set -g status-left " #[fg=${tn.cyan},bold]#{pane_title}#[default]   "
      set -g status-left-length 200

      set -g status-right "#(PATH=${pkgs.git}/bin:$PATH ${pkgs.gitmux}/bin/gitmux -cfg ${gitmuxConfig} '#{pane_current_path}') "
      set -g status-right-length 200

      set -g pane-border-style fg=${tn.bgHl}
      set -g pane-active-border-style fg=${accent}
      set -g message-style bg=${tn.bg},fg=${tn.fg}

      setw -g window-status-separator ""
      setw -g window-status-format " #[fg=${tn.comment}]○ #W #[default]"
      setw -g window-status-current-format " #[fg=${accent},bold]● #W #[default]"

      set -as terminal-features ",xterm-256color:RGB"

      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '1'
    '';
  };
}
