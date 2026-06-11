{ config, lib, ... }:
let
  cfg = config.smi.nh;
in
{
  options.smi.nh = {
    enable = lib.mkEnableOption "nh, a quality-of-life wrapper for nixos-rebuild, home-manager, and GC";

    flakeDir = lib.mkOption {
      type = lib.types.str;
      description = "Absolute path to the flake directory";
    };

    clean = {
      keepSince = lib.mkOption {
        type = lib.types.str;
        default = "7d";
        description = "Keep generations newer than this value";
      };

      keepCount = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = "Minimum number of generations to always keep";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = cfg.flakeDir;
      clean = {
        enable = true;
        extraArgs = "--keep-since ${cfg.clean.keepSince} --keep ${toString cfg.clean.keepCount}";
      };
    };

    nix.gc.automatic = lib.mkForce false;
  };
}
