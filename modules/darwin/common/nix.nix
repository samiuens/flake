{
  config,
  lib,
  inputs,
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

    gc = {
      automatic = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable automatic garbage collection";
      };

      interval = lib.mkOption {
        type = lib.types.attrs;
        default = {
          Weekday = 0;
          Hour = 3;
          Minute = 0;
        };
        description = "launchd calendar interval for nix-gc";
      };

      keepDays = lib.mkOption {
        type = lib.types.int;
        default = 30;
        description = "Keep generations newer than this many days";
      };
    };
  };

  config = {
    nixpkgs.config.allowUnfree = lib.mkDefault cfg.allowUnfree;
    nixpkgs.overlays = [ inputs.nix4vscode.overlays.default ];

    # Determinate Nix manages the Nix installation itself, so nix-darwin must
    # not manage nix.conf or the gc launchd job. The settings/gc below only
    # apply on hosts that opt back in with `nix.enable = true`.
    nix = lib.mkMerge [
      { enable = lib.mkDefault false; }
      (lib.mkIf config.nix.enable {
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
      })
    ];
  };
}
