{ config, lib, ... }:
{
  options.smi.host = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Machine hostname";
    };

    useLocalTime = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use local time for the hardware clock (Windows dual-boot)";
    };
  };

  config = {
    networking.hostName = config.smi.host.name;
    time.hardwareClockInLocalTime = config.smi.host.useLocalTime;
  };
}
