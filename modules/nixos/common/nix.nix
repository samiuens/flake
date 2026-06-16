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
    nixLd.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable nix-ld for running dynamically linked binaries";
    };

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

      dates = lib.mkOption {
        type = lib.types.str;
        default = "weekly";
        description = "Systemd calendar expression for the GC timer";
      };

      keepDays = lib.mkOption {
        type = lib.types.int;
        default = 30;
        description = "Keep generations newer than this many days";
      };
    };

    optimise = {
      automatic = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically deduplicate the Nix store";
      };

      dates = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "weekly" ];
        description = "Systemd calendar expressions for the optimise timer";
      };
    };
  };

  config = {
    programs.nix-ld.enable = lib.mkDefault cfg.nixLd.enable;

    nixpkgs.config.allowUnfree = lib.mkDefault cfg.allowUnfree;
    nixpkgs.overlays = [ inputs.nix4vscode.overlays.default ];

    nix = {
      settings = {
        experimental-features = lib.mkDefault [
          "nix-command"
          "flakes"
        ];
        trusted-users = lib.mkDefault [
          "root"
          "@wheel"
        ];
        warn-dirty = lib.mkDefault false;
        keep-outputs = lib.mkDefault true;
        keep-derivations = lib.mkDefault true;
        use-xdg-base-directories = lib.mkDefault true;
        download-buffer-size = lib.mkDefault 268435456;
      };

      optimise = {
        automatic = lib.mkDefault cfg.optimise.automatic;
        dates = lib.mkDefault cfg.optimise.dates;
      };

      gc = {
        automatic = lib.mkDefault cfg.gc.automatic;
        dates = lib.mkDefault cfg.gc.dates;
        options = lib.mkDefault "--delete-older-than ${toString cfg.gc.keepDays}d";
      };
    };
  };
}
