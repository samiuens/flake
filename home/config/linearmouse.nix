{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "linearmouse";
  cfg = config.smi.config.${name};
  jsonFormat = pkgs.formats.json { };
in
{
  options.smi.config.${name} = {
    enable = lib.mkEnableOption "${name} configuration";

    settings = lib.mkOption {
      inherit (jsonFormat) type;
      default = { };
      description = ''
        LinearMouse settings written to ~/.config/linearmouse/linearmouse.json.
        LinearMouse itself is installed via the Homebrew cask, so this module
        only manages its configuration file.
      '';
    };
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    xdg.configFile."linearmouse/linearmouse.json".source =
      jsonFormat.generate "linearmouse.json" cfg.settings;
  };
}
