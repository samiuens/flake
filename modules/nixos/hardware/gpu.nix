{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.smi.hardware.gpu = lib.mkOption {
    type = lib.types.enum [
      "amd"
      "intel"
      "nvidia"
      "unknown"
    ];
    default = "unknown";
    description = "GPU type; \"unknown\" applies no specific configuration";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.smi.hardware.gpu == "amd") {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })
    (lib.mkIf (config.smi.hardware.gpu == "intel") {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [ pkgs.intel-media-driver ];
      };
    })
    (lib.mkIf (config.smi.hardware.gpu == "nvidia") {
      hardware.graphics.enable = true;
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = lib.mkDefault false;
        open = lib.mkDefault false;
        nvidiaSettings = lib.mkDefault true;
        package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
      };
      services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
    })
  ];
}
