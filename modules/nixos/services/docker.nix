{
  config,
  lib,
  ...
}:
{
  options.smi.services.docker.enable = lib.mkEnableOption "Docker";

  config = lib.mkIf config.smi.services.docker.enable {
    virtualisation.docker.enable = true;
  };
}
