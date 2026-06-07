{
  osConfig,
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
in
{
  imports = [
    inputs.dms.homeModules.default
    ./shell.nix
    ./theming.nix
    ./apps.nix
    ./keybinds.nix
    ./search.nix
  ];

  home.packages = lib.mkIf active [ pkgs.xdg-desktop-portal-gtk ];
}
