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

    keyboard = {
      layout = lib.mkOption {
        type = lib.types.str;
        default = "de";
        description = "Keyboard layout";
      };

      variant = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Keyboard variant";
      };
    };
  };

  config = {
    time.timeZone = cfg.timeZone;

    i18n.defaultLocale = cfg.defaultLocale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.extraLocale;
      LC_IDENTIFICATION = cfg.extraLocale;
      LC_MEASUREMENT = cfg.extraLocale;
      LC_MONETARY = cfg.extraLocale;
      LC_NAME = cfg.extraLocale;
      LC_NUMERIC = cfg.extraLocale;
      LC_PAPER = cfg.extraLocale;
      LC_TELEPHONE = cfg.extraLocale;
      LC_TIME = cfg.extraLocale;
    };

    services.xserver.xkb = {
      inherit (cfg.keyboard) layout;
      inherit (cfg.keyboard) variant;
    };

    console.keyMap = cfg.keyboard.layout;
  };
}
