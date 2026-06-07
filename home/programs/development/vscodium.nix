{
  config,
  lib,
  ...
}:
let
  name = "vscodium";
  cfg = config.smi.programs.${name};

  mergeProfile =
    profile:
    profile
    // {
      extensions = cfg.extensions ++ (profile.extensions or [ ]);
      userSettings = cfg.userSettings // (profile.userSettings or { });
    };
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extensions shared across all VSCodium profiles";
    };

    userSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "User settings shared across all VSCodium profiles";
    };

    profiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "VSCodium profiles (extensions and user settings)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscodium = {
      enable = true;
      mutableExtensionsDir = false;
      profiles = lib.mapAttrs (_: mergeProfile) cfg.profiles;
    };
  };
}
