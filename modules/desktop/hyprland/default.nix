{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./noctalia.nix
  ];

  config = lib.mkIf (config.smi.desktop.enable && config.smi.desktop.environment == "hyprland") {
    programs.hyprland.enable = true;

    security.pam.services.hyprlock = { };
    security.polkit.enable = true;
    documentation.nixos.enable = false;

    services = {
      gvfs.enable = true;
      udisks2.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
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
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
