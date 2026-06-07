{
  config,
  lib,
  pkgs,
  ...
}:
let
  active =
    config.smi.desktop.enable
    && config.smi.desktop.environment == "hyprland"
    && config.smi.desktop.shell == "dms";
in
{
  config = lib.mkIf active {
    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      fastfetch
      grim
      slurp
      hyprpicker
      wl-clipboard
      tesseract
      imagemagick
      zbar
      curl
      translate-shell
      wl-screenrec
      ffmpeg
      gifski
      jq
      python3
      python3Packages.pygobject3
      xdg-desktop-portal
      ddcutil
      qt6Packages.qt6ct
      glib
      gsettings-desktop-schemas
    ];
  };
}
