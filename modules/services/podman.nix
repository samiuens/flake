{
  config,
  lib,
  ...
}:
{
  options.smi.services.podman.enable = lib.mkEnableOption "Podman";

  config = lib.mkIf config.smi.services.podman.enable {
    virtualisation.podman = {
      enable = true;
    };
  };
}
