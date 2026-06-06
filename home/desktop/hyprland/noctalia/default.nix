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
    && osConfig.smi.desktop.shell == "noctalia";
in
{
  imports = [
    inputs.noctalia.homeModules.default
    ./shell.nix
    ./theming.nix
    ./apps.nix
    ./keybinds.nix
    ./settings
  ];

  home.packages = lib.mkIf active [ pkgs.xdg-desktop-portal-gtk ];
}
