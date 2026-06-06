{
  config,
  lib,
  ...
}:
{
  options.smi.programs.zen.containers = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          color = lib.mkOption { type = lib.types.str; };
          icon = lib.mkOption {
            type = lib.types.str;
            default = "circle";
          };
          id = lib.mkOption { type = lib.types.int; };
        };
      }
    );
    default = { };
    description = "Zen Browser containers";
  };

  config = lib.mkIf config.smi.programs.zen.enable {
    programs.zen-browser.profiles.default = {
      containersForce = true;
      inherit (config.smi.programs.zen) containers;
    };
  };
}
