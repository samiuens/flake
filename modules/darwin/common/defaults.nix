{
  config,
  lib,
  ...
}:
let
  cfg = config.smi.system;
  finderViewCode = {
    icon = "icnv";
    list = "Nlsv";
    column = "clmv";
    gallery = "glyv";
  };
in
{
  options.smi.system = {
    appearance = lib.mkOption {
      type = lib.types.enum [
        "light"
        "dark"
        "auto"
      ];
      default = "auto";
      description = "System appearance mode";
    };

    dock = {
      autohide = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Auto-hide the Dock";
      };
      tilesize = lib.mkOption {
        type = lib.types.int;
        default = 48;
        description = "Dock icon size in pixels";
      };
      magnification = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Magnify icons on hover";
      };
      position = lib.mkOption {
        type = lib.types.enum [
          "bottom"
          "left"
          "right"
        ];
        default = "bottom";
        description = "Dock position on screen";
      };
      persistentApps = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "/Applications/Ghostty.app"
          "/Applications/Zen Browser.app"
        ];
        description = "Apps pinned to the Dock (paths)";
      };
      showRecents = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Show recent apps in the Dock";
      };
    };

    finder = {
      showHidden = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show hidden files";
      };
      showExtensions = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show all file extensions";
      };
      showPathBar = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show path bar";
      };
      showStatusBar = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show status bar";
      };
      defaultView = lib.mkOption {
        type = lib.types.enum (lib.attrNames finderViewCode);
        default = "column";
        description = "Default folder view";
      };
    };

    keyboard = {
      keyRepeat = lib.mkOption {
        type = lib.types.int;
        default = 2;
        description = "Key repeat rate (lower is faster)";
      };
      initialKeyRepeat = lib.mkOption {
        type = lib.types.int;
        default = 15;
        description = "Initial key repeat delay (lower is faster)";
      };
      autocorrect = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable autocorrect";
      };
      smartQuotes = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable smart quotes substitution";
      };
    };

    trackpad = {
      tapToClick = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Tap to click";
      };
      threeFingerDrag = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Three-finger drag";
      };
    };

    screenshots = {
      location = lib.mkOption {
        type = lib.types.str;
        default = "~/Pictures/Screenshots";
        description = "Where screenshots are saved";
      };
      format = lib.mkOption {
        type = lib.types.enum [
          "png"
          "jpg"
          "pdf"
          "tiff"
        ];
        default = "png";
        description = "Screenshot file format";
      };
      disableShadow = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Disable window-screenshot drop shadow";
      };
    };

    loginwindow.guestEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow guest login";
    };
  };

  config = {
    system.defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = lib.mkIf (cfg.appearance == "dark") "Dark";
        AppleInterfaceStyleSwitchesAutomatically = cfg.appearance == "auto";
        KeyRepeat = cfg.keyboard.keyRepeat;
        InitialKeyRepeat = cfg.keyboard.initialKeyRepeat;
        NSAutomaticSpellingCorrectionEnabled = cfg.keyboard.autocorrect;
        NSAutomaticQuoteSubstitutionEnabled = cfg.keyboard.smartQuotes;
      };

      dock = {
        autohide = cfg.dock.autohide;
        tilesize = cfg.dock.tilesize;
        magnification = cfg.dock.magnification;
        orientation = cfg.dock.position;
        persistent-apps = cfg.dock.persistentApps;
        show-recents = cfg.dock.showRecents;
      };

      finder = {
        AppleShowAllFiles = cfg.finder.showHidden;
        AppleShowAllExtensions = cfg.finder.showExtensions;
        ShowPathbar = cfg.finder.showPathBar;
        ShowStatusBar = cfg.finder.showStatusBar;
        FXPreferredViewStyle = finderViewCode.${cfg.finder.defaultView};
      };

      trackpad = {
        Clicking = cfg.trackpad.tapToClick;
        TrackpadThreeFingerDrag = cfg.trackpad.threeFingerDrag;
      };

      screencapture = {
        location = cfg.screenshots.location;
        type = cfg.screenshots.format;
        disable-shadow = cfg.screenshots.disableShadow;
      };

      loginwindow.GuestEnabled = cfg.loginwindow.guestEnabled;
    };
  };
}
