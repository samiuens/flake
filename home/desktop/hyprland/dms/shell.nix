{
  osConfig,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  active =
    osConfig.smi.desktop.enable
    && osConfig.smi.desktop.environment == "hyprland"
    && osConfig.smi.desktop.shell == "dms";
  system = pkgs.stdenv.hostPlatform.system;
in
{
  options.smi.desktop.dms.settings = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "DankMaterialShell settings.json als Attribut-Set.";
  };

  config.programs.dank-material-shell = lib.mkIf active {
    enable = true;
    package = inputs.dms.packages.${system}.dms-shell;
    quickshell.package = pkgs.quickshell;
    systemd.enable = false;
    enableDynamicTheming = true;
    settings = config.smi.desktop.dms.settings;
  };
}
