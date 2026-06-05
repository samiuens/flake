{ config, lib, ... }:
let
  cfg = config.smi.programs.git.gitlab;
in
{
  options.smi.programs.git.gitlab = {
    enable = lib.mkEnableOption "GitLab";
    username = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "GitLab username";
    };
    insteadOf = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "URLs/prefixes to rewrite to SSH";
    };
  };

  config = lib.mkIf cfg.enable {
    smi.programs.ssh.providers.gitlab = {
      enable = true;
      username = cfg.username;
      insteadOf = [ "https://gitlab.com/" "gl:/" ] ++ cfg.insteadOf;
    };
  };
}
