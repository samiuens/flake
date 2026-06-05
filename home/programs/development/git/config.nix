{ config, lib, ... }:
let
  name = "git";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Git commit author name";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Git commit author email";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user.name = cfg.user.name;
        user.email = cfg.user.email;
        alias.unstage = "reset HEAD --";
        init.defaultBranch = "main";
        color.ui = true;
        push = {
          autoSetupRemote = true;
          default = "current";
          rebase = true;
        };
        rebase = {
          autoStash = true;
          autoSquash = true;
        };
        diff.algorithm = "histogram";
        merge.conflictStyle = "zdiff3";
        fetch.prune = true;
        rerere.enabled = true;
        branch.sort = "-committerdate";
      };
    };
  };
}
