{ config, lib, ... }:
{
  options.smi.shell.fish.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable fish as the system shell";
  };

  config = lib.mkIf config.smi.shell.fish.enable {
    programs.fish.enable = true;
  };
}
