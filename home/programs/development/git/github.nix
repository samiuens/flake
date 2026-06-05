{ config, lib, ... }:
let
  cfg = config.smi.programs.git.github;
in
{
  options.smi.programs.git.github = {
    enable = lib.mkEnableOption "GitHub";
    username = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "GitHub username";
    };
    insteadOf = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "URLs/prefixes to rewrite to SSH";
    };
  };

  config = lib.mkIf cfg.enable {
    smi.programs.ssh.providers.github = {
      enable = true;
      username = cfg.username;
      insteadOf = [ "https://github.com/" "gh:" ] ++ cfg.insteadOf;
    };
  };
}
