{ config, lib, ... }:
let
  name = "direnv";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
