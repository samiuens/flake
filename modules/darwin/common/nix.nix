{
  config,
  lib,
  ...
}:
let
  cfg = config.smi.nix;
in
{
  options.smi.nix = {
    allowUnfree = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow unfree packages";
    };

    gc.automatic = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable automatic garbage collection";
    };

    gc.interval = lib.mkOption {
      type = lib.types.attrs;
      default = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
      description = "launchd calendar interval for nix-gc";
    };

    gc.keepDays = lib.mkOption {
      type = lib.types.int;
      default = 30;
      description = "Keep generations newer than this many days";
    };
  };

  config = {
    nixpkgs.config.allowUnfree = lib.mkDefault cfg.allowUnfree;

    nix = {
      settings = {
        experimental-features = lib.mkDefault [
          "nix-command"
          "flakes"
        ];
        trusted-users = lib.mkDefault [
          "root"
          "@admin"
        ];
        warn-dirty = lib.mkDefault false;
        keep-outputs = lib.mkDefault true;
        keep-derivations = lib.mkDefault true;
        download-buffer-size = lib.mkDefault 268435456;
      };

      gc = {
        automatic = lib.mkDefault cfg.gc.automatic;
        interval = lib.mkDefault cfg.gc.interval;
        options = lib.mkDefault "--delete-older-than ${toString cfg.gc.keepDays}d";
      };
    };
  };
}
