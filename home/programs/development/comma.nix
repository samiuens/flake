{ config, lib, ... }:
let
  name = "comma";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {
    programs.nix-index-database.comma.enable = true;
  };
}
