{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./noctalia
    ./dms
  ];

  config = lib.mkIf (config.smi.desktop.enable && config.smi.desktop.environment == "hyprland") {
    programs.hyprland = {
      enable = true;
      withUWSM = false;
    };
    security.polkit.enable = true;
    documentation.nixos.enable = false;

    services = {
      gvfs.enable = true;
      udisks2.enable = true;
    };

    services.displayManager = lib.mkIf (config.smi.desktop.shell != "dms") {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        theme = "elarun";
        wayland = {
          enable = true;
          # weston-kiosk (Default) hat keinen Cursor und keine Layer-
          # Shell — kwin rendert beides nativ.
          compositor = "kwin";
        };
        settings = {
          Theme = {
            CursorTheme = "Adwaita";
            CursorSize = "24";
          };
          # kwin liest das Keyboard-Layout aus libxkbcommon-Env, nicht
          # aus /etc/X11/xorg.conf.d, daher hier explizit setzen.
          General.GreeterEnvironment = lib.concatStringsSep "," [
            "XKB_DEFAULT_LAYOUT=${config.smi.keyboard.layout}"
            "XKB_DEFAULT_VARIANT=${config.smi.keyboard.variant}"
          ];
        };
      };
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "hyprland" ];
          "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        };
        hyprland = {
          default = [ "hyprland" ];
          "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
      wl-clipboard
      nautilus
      gnome-calculator
      gnome-text-editor
      papers
      loupe
      adwaita-icon-theme # liefert den Adwaita-Cursor system-weit (SDDM/Greeter)
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
