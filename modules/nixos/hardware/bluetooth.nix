{ config, lib, ... }:
{
  options.smi.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth";

  config = lib.mkIf config.smi.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    #services.blueman.enable = true;
  };
}
