{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = config.smi.desktop.noctalia;
  active =
    osConfig.smi.desktop.enable
    && osConfig.smi.desktop.environment == "hyprland"
    && osConfig.smi.desktop.shell == "noctalia";
in
{
  options.smi.desktop.noctalia.settings = lib.mkOption {
    type = (pkgs.formats.json { }).type;
    default = { };
    description = "Noctalia shell settings";
  };

  config = lib.mkIf active {
    programs.noctalia-shell.settings = {
      settingsVersion = 59;
    }
    // cfg.settings;
  };
}
