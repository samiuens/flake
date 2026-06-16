{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.smi.programs.valent.enable = lib.mkEnableOption "Valent";

  config = lib.mkIf config.smi.programs.valent.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.valent;
    };
  };
}
