{ config, lib, ... }:
{
  options.smi.network.networkManager.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable NetworkManager";
  };

  config = lib.mkIf config.smi.network.networkManager.enable {
    networking.networkmanager.enable = true;
  };
}
