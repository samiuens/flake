{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "aerospace";
  cfg = config.smi.programs.${name};
  tomlFormat = pkgs.formats.toml { };
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;

    settings = lib.mkOption {
      inherit (tomlFormat) type;
      default = { };
      description = "AeroSpace settings written to ~/.config/aerospace/aerospace.toml";
    };
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    home.packages = [ pkgs.aerospace ];
    xdg.configFile."aerospace/aerospace.toml".source =
      tomlFormat.generate "aerospace.toml" cfg.settings;
  };
}
