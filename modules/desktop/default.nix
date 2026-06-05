{ lib, helpers, ... }:
{
  imports = helpers.importDir ./.;

  options.smi.desktop = {
    enable = lib.mkEnableOption "graphical desktop environment";

    environment = lib.mkOption {
      type = lib.types.enum [
        "gnome"
        "hyprland"
      ];
      default = "gnome";
      description = "Desktop environment to use";
    };

    shell = lib.mkOption {
      type = lib.types.enum [
        "default"
        "noctalia"
      ];
      default = "default";
      description = "Hyprland shell variant; only applies when environment = \"hyprland\"";
    };
  };
}
