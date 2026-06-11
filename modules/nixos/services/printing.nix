{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.smi.services.printing.enable = lib.mkEnableOption "CUPS Druckdienst";

  config = lib.mkIf config.smi.services.printing.enable {
    services.printing.enable = true;
    services.dbus.packages = [ pkgs.cups-pk-helper ];
    environment.systemPackages = [ pkgs.cups-pk-helper ];
  };
}
