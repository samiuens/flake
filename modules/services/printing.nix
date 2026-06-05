{ config, lib, ... }:
{
  options.smi.services.printing.enable = lib.mkEnableOption "CUPS Druckdienst";

  config = lib.mkIf config.smi.services.printing.enable {
    services.printing.enable = true;
  };
}
