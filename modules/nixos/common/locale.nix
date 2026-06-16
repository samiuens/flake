{ config, lib, ... }:

let
  cfg = config.smi.locale;
in
{
  options.smi.locale = {
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Berlin";
      description = "System time zone";
    };

    defaultLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Default system locale";
    };

    extraLocale = lib.mkOption {
      type = lib.types.str;
      default = cfg.defaultLocale;
      description = "Extra system locale";
    };
  };

  config = {
    time.timeZone = cfg.timeZone;

    i18n.defaultLocale = cfg.defaultLocale;

    i18n.extraLocaleSettings = lib.genAttrs [
      "LC_ADDRESS"
      "LC_IDENTIFICATION"
      "LC_MEASUREMENT"
      "LC_MONETARY"
      "LC_NAME"
      "LC_NUMERIC"
      "LC_PAPER"
      "LC_TELEPHONE"
      "LC_TIME"
    ] (_: cfg.extraLocale);
  };
}
