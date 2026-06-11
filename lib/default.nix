{ lib }:
rec {
  importDir =
    dir:
    let
      go =
        d: isRoot:
        lib.concatLists (
          lib.mapAttrsToList (
            name: type:
            if type == "directory" then
              let
                subDir = d + "/${name}";
                hasDefault = builtins.pathExists (subDir + "/default.nix");
              in
              if hasDefault then [ (subDir + "/default.nix") ] else go subDir false
            else if type == "regular" && lib.hasSuffix ".nix" name && !(isRoot && name == "default.nix") then
              [ (d + "/${name}") ]
            else
              [ ]
          ) (builtins.readDir d)
        );
    in
    go dir true;

  importPlatformDir =
    platform: dir:
    let
      load =
        path:
        let
          raw = import path;
        in
        if lib.isAttrs raw && raw ? platforms && raw ? module then
          {
            keep = lib.elem platform raw.platforms;
            module = raw.module;
          }
        else
          {
            keep = true;
            module = raw;
          };
      loaded = map load (importDir dir);
    in
    map (x: x.module) (lib.filter (x: x.keep) loaded);

  mkSimpleProgram =
    {
      config,
      lib,
      name,
      packages,
    }:
    {
      options.smi.programs.${name}.enable = lib.mkEnableOption name;
      config = lib.mkIf config.smi.programs.${name}.enable {
        home.packages = packages;
      };
    };

  mkGitProvider =
    {
      config,
      lib,
      name,
      displayName,
      defaultInsteadOf,
    }:
    let
      cfg = config.smi.programs.git.${name};
    in
    {
      options.smi.programs.git.${name} = {
        enable = lib.mkEnableOption displayName;
        username = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "${displayName} username";
        };
        insteadOf = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "URLs/prefixes to rewrite to SSH";
        };
      };
      config = lib.mkIf cfg.enable {
        smi.programs.ssh.providers.${name} = {
          enable = true;
          inherit (cfg) username;
          insteadOf = defaultInsteadOf ++ cfg.insteadOf;
        };
      };
    };
}
