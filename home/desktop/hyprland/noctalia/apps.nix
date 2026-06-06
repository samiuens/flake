{
  osConfig,
  config,
  lib,
  ...
}:
let
  active =
    osConfig.smi.desktop.enable
    && osConfig.smi.desktop.environment == "hyprland"
    && osConfig.smi.desktop.shell == "noctalia";
in
{
  programs = lib.mkIf active {
    zen-browser.profiles.default.settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = lib.mkDefault true;
      "widget.use-xdg-desktop-portal.appearance" = lib.mkDefault 1;
      "layout.css.prefers-color-scheme.content-override" = lib.mkDefault 2;
    };
    firefox.profiles.default.settings = {
      "widget.use-xdg-desktop-portal.appearance" = lib.mkDefault 1;
      "layout.css.prefers-color-scheme.content-override" = lib.mkDefault 2;
    };
    ghostty.settings.config-file = "?${config.xdg.configHome}/ghostty/noctalia-colors";
    tmux.extraConfig = lib.mkAfter ''
      source-file -q ~/.config/tmux/noctalia-colors.conf
    '';
    zed-editor.userSettings.theme = lib.mkForce "Noctalia";
  };
}
