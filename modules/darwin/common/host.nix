{ config, lib, ... }:
{
  options.smi.host.name = lib.mkOption {
    type = lib.types.str;
    description = "Machine hostname";
  };

  config = {
    networking.hostName = config.smi.host.name;
    networking.computerName = config.smi.host.name;
  };
}
