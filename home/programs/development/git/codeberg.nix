{ config, lib, ... }:
let
  cfg = config.smi.programs.git.codeberg;
in
{
  options.smi.programs.git.codeberg = {
    enable = lib.mkEnableOption "Codeberg";
    username = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Codeberg username";
    };
    insteadOf = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "URLs/prefixes to rewrite to SSH";
    };
  };

  config = lib.mkIf cfg.enable {
    smi.programs.ssh.providers.codeberg = {
      enable = true;
      inherit (cfg) username;
      insteadOf = [
        "https://codeberg.org/"
        "cb:"
      ]
      ++ cfg.insteadOf;
    };
  };
}
