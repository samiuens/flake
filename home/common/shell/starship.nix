{ config, lib, ... }:
let
  cfg = config.smi.shell;
in
{
  config.programs.starship = lib.mkIf cfg.starship.enable {
    enable = true;
    enableFishIntegration = true;

    settings = {
      add_newline = true;
      format = "$directory$character";

      directory = {
        style = "bold #7aa2f7";
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[ $path ]($style)";
      };

      character = {
        success_symbol = "[❯](bold #9ece6a)";
        error_symbol = "[❯](bold #f7768e)";
      };
    };
  };
}
