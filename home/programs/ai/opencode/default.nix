{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "opencode";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name}.enable = lib.mkEnableOption name;

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      opencode
    ];

    xdg.configFile = {
      "opencode/opencode.jsonc".source = ./opencode.jsonc;
      "opencode/oh-my-openagent.json".source = ./oh-my-openagent.json;
      "opencode/tui.json".source = ./tui.json;
    };
  };
}
