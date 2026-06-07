{
  osConfig,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  active =
    osConfig.smi.desktop.enable
    && osConfig.smi.desktop.environment == "hyprland"
    && osConfig.smi.desktop.shell == "noctalia";
  syncColorScheme = pkgs.writeShellScript "noctalia-sync-color-scheme" ''
    set -eu
    state="$(noctalia-shell ipc call state all 2>/dev/null || true)"
    if [ -z "$state" ]; then
      exit 0
    fi
    if [ "$(printf '%s' "$state" | ${pkgs.jq}/bin/jq -r '.settings.colorSchemes.darkMode // false')" = "true" ]; then
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
    else
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
    fi
  '';
in
{
  programs.noctalia-shell = lib.mkIf active {
    enable = true;
    user-templates.templates = {
      hyprland = {
        input_path = "${inputs.noctalia}/Assets/Templates/hyprland.conf";
        output_path = "${config.xdg.configHome}/hypr/noctalia-colors.conf";
        post_hook = "hyprctl reload && ${syncColorScheme}";
      };
      gtk3 = {
        input_path = "${inputs.noctalia}/Assets/Templates/gtk3.css";
        output_path = "${config.xdg.configHome}/gtk-3.0/gtk.css";
      };
      gtk4 = {
        input_path = "${inputs.noctalia}/Assets/Templates/gtk4.css";
        output_path = "${config.xdg.configHome}/gtk-4.0/gtk.css";
      };
      qt6ct = {
        input_path = "${inputs.noctalia}/Assets/Templates/qtct.conf";
        output_path = "${config.xdg.configHome}/qt6ct/colors/noctalia.conf";
      };
      ghostty = {
        input_path = "${inputs.noctalia}/Assets/Templates/terminal/ghostty";
        output_path = "${config.xdg.configHome}/ghostty/noctalia-colors";
        post_hook = "pkill -SIGUSR2 -x ghostty || true";
      };
      tmux = {
        input_path = "${./templates/tmux.conf}";
        output_path = "${config.xdg.configHome}/tmux/noctalia-colors.conf";
        post_hook = "tmux source-file ${config.xdg.configHome}/tmux/noctalia-colors.conf 2>/dev/null || true";
      };
      zed = {
        input_path = "${./templates/zed.json}";
        output_path = "${config.xdg.configHome}/zed/themes/noctalia.json";
      };
      /*
        zen = {
          input_path = "${./templates/zen.css}";
          output_path = "${config.home.homeDirectory}/.config/zen/default/chrome/userChrome.css";
        };
      */
    };
  };
}
