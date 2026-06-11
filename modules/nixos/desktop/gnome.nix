{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.smi.desktop.enable && config.smi.desktop.environment == "gnome") {
    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };

    programs.dconf.enable = true;
    environment = {
      systemPackages = with pkgs; [
        dconf-editor
      ];

      gnome.excludePackages = with pkgs; [
        gnome-photos
        gnome-music
        totem
        cheese

        epiphany
        gnome-maps
        gnome-weather
        gnome-contacts
        gnome-online-accounts

        gnome-calendar
        gnome-clocks
        gnome-characters
        gnome-font-viewer
        gnome-logs
        simple-scan
        yelp
        gnome-tour
        gnome-user-docs
        snapshot
        gnome-terminal
      ];
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
      };
    };
    documentation.nixos.enable = false;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "gnome";
    };
  };
}
