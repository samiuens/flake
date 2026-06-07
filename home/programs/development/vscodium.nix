{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "vscodium";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;

    profiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "VSCodium profiles (extensions and user settings)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      inherit (cfg) profiles;
    };
  };
}
