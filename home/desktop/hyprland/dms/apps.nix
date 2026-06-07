{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  active =
    osConfig.smi.desktop.enable
    && osConfig.smi.desktop.environment == "hyprland"
    && osConfig.smi.desktop.shell == "dms";
in
{
  config = lib.mkIf active {
    smi.programs.vscodium = {
      extensions = pkgs.nix4vscode.forOpenVsx [ "DankLinux.dms-theme" ];
      userSettings."workbench.colorTheme" = lib.mkDefault "Dynamic Base16 DankShell";
    };

    # matugen-User-Template: tmux wird von DMS nicht nativ abgedeckt.
    # Input (Template + .toml) darf ein read-only Store-Symlink sein – matugen
    # liest nur. Der Output (dank-colors.conf) liegt bewusst NICHT in
    # home-manager, damit matugen ihn zur Laufzeit schreiben kann.
    xdg.configFile = {
      "matugen/dms/configs/tmux.toml".text = ''
        [templates.tmux]
        input_path = '${./templates/tmux.conf}'
        output_path = '${config.xdg.configHome}/tmux/dank-colors.conf'
        post_hook = 'tmux source-file ${config.xdg.configHome}/tmux/dank-colors.conf 2>/dev/null || true'
      '';

      "matugen/dms/configs/hypr-lua.toml".text = ''
        [templates.hyprlua]
        input_path = '${./templates/hypr-colors.lua}'
        output_path = '${config.xdg.configHome}/hypr/dms/colors.lua'
        post_hook = 'hyprctl reload'
      '';
    };

    programs = {
      tmux.extraConfig = lib.mkAfter ''
        source-file -q ~/.config/tmux/dank-colors.conf
      '';

      ghostty.settings.theme = "dankcolors";
      zed-editor.userSettings.theme = lib.mkForce {
        mode = "system";
        light = "DankShell Light";
        dark = "DankShell Dark";
      };
    };
  };
}
