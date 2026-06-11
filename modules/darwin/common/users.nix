{
  config,
  pkgs,
  lib,
  userRegistry,
  ...
}:
let
  cfg = config.smi.users;
in
{
  options.smi.users = {
    defaultShell = lib.mkOption {
      type = lib.types.shellPackage;
      default = pkgs.fish;
      defaultText = lib.literalExpression "pkgs.fish";
      description = "Default shell for all managed users";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "26.05";
      description = "Home Manager state version for all managed users";
    };
  };

  config = {
    users.users = lib.mapAttrs (name: user: {
      home = "/Users/${name}";
      shell = cfg.defaultShell;
      inherit (user) description;
    }) userRegistry;

    home-manager.users = lib.mapAttrs (name: user: {
      imports = lib.optional (user ? hmConfig) user.hmConfig;

      home = {
        username = name;
        homeDirectory = "/Users/${name}";
        inherit (cfg) stateVersion;
        packages = (user.packages or (_: [ ])) pkgs;
      };
    }) userRegistry;
  };
}
