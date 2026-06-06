{
  config,
  lib,
  ...
}:
{
  options.smi.programs.zen.spaces = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        id = lib.mkOption { type = lib.types.str; };
        icon = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
        position = lib.mkOption {
          type = lib.types.int;
          default = 1000;
        };
        container = lib.mkOption {
          type = lib.types.int;
          default = 1;
        };
      };
    });
    default = { };
    description = "Zen Browser spaces";
  };

  config = lib.mkIf config.smi.programs.zen.enable {
    programs.zen-browser.profiles.default = {
      spacesForce = true;
      spaces = config.smi.programs.zen.spaces;
    };
  };
}
