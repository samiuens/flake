{
  config,
  lib,
  ...
}:
let
  active =
    config.smi.desktop.enable
    && config.smi.desktop.environment == "hyprland"
    && config.smi.desktop.shell == "noctalia";
in
{
  imports = [
    ./packages.nix
  ];

  config = lib.mkIf active {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    programs.dconf.enable = true;
    hardware.i2c.enable = true;
    environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
