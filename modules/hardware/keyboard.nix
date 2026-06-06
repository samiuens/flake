{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.smi.keyboard;
in
{
  options.smi.keyboard = {
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
    qmk.enable = lib.mkEnableOption "Enable qmk keyboard support";
  };

  config = {
    services.xserver.xkb = {
      inherit (cfg) layout;
      inherit (cfg) variant;
    };

    console.keyMap = cfg.layout;

    hardware.keyboard.qmk.enable = lib.mkIf cfg.qmk.enable true;
  };
}
