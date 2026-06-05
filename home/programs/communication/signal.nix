{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "signal";
in
{
  options.smi.programs.${name}.enable = lib.mkEnableOption name;

  config = lib.mkIf config.smi.programs.${name}.enable {
    home.packages = with pkgs; [ signal-desktop ];
  };
}
