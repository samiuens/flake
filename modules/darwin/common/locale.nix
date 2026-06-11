{ config, lib, ... }:
let
  cfg = config.smi.locale;
in
{
  options.smi.locale.timeZone = lib.mkOption {
    type = lib.types.str;
    default = "Europe/Berlin";
    description = "System time zone";
  };

  config = {
    time.timeZone = cfg.timeZone;
  };
}
