{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "claude";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name}.enable = lib.mkEnableOption name;

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ claude-code ];
  };
}
