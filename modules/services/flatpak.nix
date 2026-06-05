{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.smi.services.flatpak;
in
{
  options.smi.services.flatpak = {
    enable = lib.mkEnableOption "Flatpak (declarative via nix-flatpak)";

    packages = lib.mkOption {
      type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
      default = [ ];
      example = [
        "com.spotify.Client"
        {
          appId = "us.zoom.Zoom";
          origin = "flathub";
        }
      ];
      description = "Flatpaks to install; plain strings resolve against Flathub";
    };

    autoUpdate = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Auto-update Flatpaks weekly via systemd timer";
    };
  };

  config = lib.mkIf cfg.enable {
    services.flatpak = {
      enable = true;

      remotes = lib.mkOptionDefault [
        {
          name = "flathub";
          location = "https://flathub.org/repo/flathub.flatpakrepo";
        }
      ];

      inherit (cfg) packages;

      update.auto = {
        enable = cfg.autoUpdate;
        onCalendar = "weekly";
      };
    };

    environment.systemPackages = lib.mkIf (config.smi.desktop.environment == "gnome") [
      pkgs.gnome-software
    ];
  };
}
