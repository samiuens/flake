{
  config,
  lib,
  ...
}:
let
  cfg = config.smi.homebrew;
in
{
  options.smi.homebrew = {
    enable = lib.mkEnableOption "Homebrew integration via nix-darwin";

    brews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Homebrew formulae to install";
    };

    casks = lib.mkOption {
      type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
      default = [ ];
      description = "Homebrew casks to install";
    };

    masApps = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
      default = { };
      example = {
        "Xcode" = 497799835;
      };
      description = "Mac App Store apps, mapping app name to app ID";
    };

    taps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional Homebrew taps";
    };

    cleanup = lib.mkOption {
      type = lib.types.enum [
        "none"
        "uninstall"
        "zap"
      ];
      default = "zap";
      description = "Cleanup strategy for brews/casks not declared here";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = false;
        upgrade = true;
        inherit (cfg) cleanup;
      };
      inherit (cfg) brews casks masApps taps;
    };
  };
}
