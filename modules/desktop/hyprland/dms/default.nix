{
  config,
  lib,
  ...
}:
let
  active =
    config.smi.desktop.enable
    && config.smi.desktop.environment == "hyprland"
    && config.smi.desktop.shell == "dms";
in
{
  imports = [
    ./packages.nix
    ./greeter.nix
  ];

  options.smi.desktop.dms.greeter = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "DMS-Greeter (greetd) statt SDDM verwenden, wenn shell = \"dms\".";
    };
    configHome = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/home/smi";
      description = "Home des Users, dessen DMS-Settings/Wallpaper der Greeter übernimmt.";
    };
  };

  config = lib.mkIf active {
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = true;
      accounts-daemon.enable = true;
    };
    programs.dconf.enable = true;
    hardware.i2c.enable = true;
    environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
