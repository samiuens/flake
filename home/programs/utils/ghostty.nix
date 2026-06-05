{ config, lib, ... }:
let
  name = "ghostty";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        font-family = "JetBrainsMono Nerd Font Mono";
        font-size = 12;
        window-decoration = "auto";
        cursor-style = "block";
        cursor-style-blink = false;
        cursor-click-to-move = true;
        background-opacity = 1;
        window-padding-x = 5;
        window-padding-y = 5;
        confirm-close-surface = false;
      };
    };
  };
}
