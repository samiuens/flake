{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.smi.services.localsend.enable = lib.mkEnableOption "LocalSend";

  config = lib.mkIf config.smi.services.localsend.enable {
    programs.localsend.enable = true;
  };
}
