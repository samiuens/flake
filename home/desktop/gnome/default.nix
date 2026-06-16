{
  lib,
  config,
  osConfig,
  helpers,
  platform,
  ...
}:
let
  cfg = config.smi.desktop;
  gnomeActive = osConfig.smi.desktop.enable && osConfig.smi.desktop.environment == "gnome";
in
{
  imports = helpers.importPlatformDir platform ./.;

  options.smi.desktop.accentColor = lib.mkOption {
    type = lib.types.enum [
      "blue"
      "teal"
      "green"
      "yellow"
      "orange"
      "red"
      "pink"
      "purple"
      "slate"
    ];
    default = "blue";
    description = "GNOME accent color";
  };

  config = lib.mkIf gnomeActive {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        accent-color = cfg.accentColor;
        cursor-theme = cfg.cursor.name;
        cursor-size = cfg.cursor.size;
      };
    };
  };
}
