{
  osConfig,
  lib,
  inputs,
  ...
}:
let
  active =
    osConfig.smi.desktop.enable
    && osConfig.smi.desktop.environment == "hyprland"
    && osConfig.smi.desktop.shell == "dms";
in
{
  imports = [
    inputs.danksearch.homeModules.dsearch
  ];

  programs.dsearch.enable = lib.mkIf active true;
}
