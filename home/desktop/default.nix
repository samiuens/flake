{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config.smi.desktop;
in
{
  options.smi.desktop.cursor = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bibata-cursors;
      description = "Cursor theme package";
    };
    name = lib.mkOption {
      type = lib.types.str;
      default = "Bibata-Modern-Classic";
      description = "Cursor theme name";
    };
    size = lib.mkOption {
      type = lib.types.int;
      default = 16;
      description = "Cursor size in pixels";
    };
  };

  config = lib.mkIf osConfig.smi.desktop.enable {
    home.pointerCursor = {
      inherit (cfg.cursor) package;
      inherit (cfg.cursor) name;
      inherit (cfg.cursor) size;
      gtk.enable = true;
    };
  };
}
