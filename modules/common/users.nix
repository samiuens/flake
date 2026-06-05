{
  config,
  pkgs,
  lib,
  userRegistry,
  ...
}:

let
  cfg = config.smi.users;

  activeUsers =
    let
      byGroup = lib.filterAttrs (_: u: builtins.elem u.group cfg.activeGroups) userRegistry;
      extraByName = lib.genAttrs cfg.extraUsers (name: userRegistry.${name});
    in
    byGroup // extraByName;

in
{
  options.smi.users = {
    activeGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "personal" ];
      description = "User groups active on this host";
    };

    extraUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra users from the registry, activated regardless of group";
    };

    defaultShell = lib.mkOption {
      type = lib.types.shellPackage;
      default = pkgs.fish;
      defaultText = lib.literalExpression "pkgs.fish";
      description = "Default shell for all managed users";
    };
  };

  config = {
    users.users = lib.mapAttrs (name: user: {
      isNormalUser = true;
      shell = cfg.defaultShell;
      inherit (user) description;
      extraGroups = [
        "networkmanager"
        "audio"
        "video"
      ]
      ++ lib.optional (user.permissionType == "admin") "wheel"
      ++ lib.optional config.smi.services.docker.enable "docker";
    }) activeUsers;

    home-manager.users = lib.mapAttrs (name: user: {
      imports =
        lib.optional (user ? hmConfig) user.hmConfig ++ lib.optional (user ? groupModule) user.groupModule;

      home = {
        username = name;
        homeDirectory = "/home/${name}";
        stateVersion = "26.05";
        packages = (user.packages or (_: [ ])) pkgs;
      };
    }) activeUsers;
  };
}
