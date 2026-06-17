{
  config,
  pkgs,
  lib,
  userRegistry,
  ...
}:
let
  cfg = config.smi.users;
  adminUsers = lib.filter (
    name: (userRegistry.${name}.permissionType or null) == "admin"
  ) (lib.attrNames userRegistry);
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
    # nix-darwin requires a primary user for user-scoped activation; use the
    # admin from the user registry (mirrors the nixos wheel-group logic).
    system.primaryUser = lib.mkIf (adminUsers != [ ]) (lib.mkDefault (lib.head adminUsers));

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
