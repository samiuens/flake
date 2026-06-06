{ config, lib, ... }:
let
  name = "ghostty";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;

    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "JetBrainsMono Nerd Font Mono";
      description = "Font family for Ghostty";
    };

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Font size for Ghostty";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        font-family = cfg.fontFamily;
        font-size = cfg.fontSize;
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
