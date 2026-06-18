{ pkgs, ... }:
{
  config.programs = {
    fish = {
      enable = true;

      shellAbbrs = {
        ll = "eza -lah --icons --git";
        ls = "eza --icons";
      };

      interactiveShellInit = ''
        set -g fish_greeting ""

        # Beim Start außerhalb von tmux: an die zuletzt genutzte Session
        # anhängen, falls eine läuft, sonst eine neue namens "main" starten.
        if status is-interactive && not set -q TMUX
          if tmux has-session 2>/dev/null
            exec tmux attach
          else
            exec tmux new-session -s main
          end
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

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
