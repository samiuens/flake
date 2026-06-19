{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "ghostty";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;

    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "JetBrainsMono Nerd Font";
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

      # Auf Darwin kommt das Package vom Homebrew-Cask (pkgs.ghostty baut dort
      # nicht). home-manager verwaltet nur die Config unter ~/.config/ghostty.
      package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin null;

      settings = {
        font-family = cfg.fontFamily;
        font-size = cfg.fontSize;
        command = "${pkgs.fish}/bin/fish --login";
        window-decoration = "auto";

        # Titelleiste verschmilzt mit dem Fensterhintergrund (Glas); die
        # Ampel-Buttons bleiben, native Tabs/Titel-Text entfallen optisch.
        # Fenster/Tabs verwaltet ohnehin tmux.
        macos-titlebar-style = "hidden";

        cursor-style = "block";
        cursor-style-blink = false;
        cursor-click-to-move = true;

        # Liquid Glass (macOS 26): natives Glas-Material als Fensterhintergrund.
        # background-opacity wirkt in Ghostty nur auf die Default-BG, daher
        # scheinen die Panes durch, während Zellen mit gesetzter bg-Farbe (z.B.
        # die tmux-Statusbar) deckend bleiben. Hintergrund = Tokyo-Night-BG.
        background = "1a1b26";
        background-opacity = 0.92;
        background-blur = "macos-glass-regular";

        # Einheitliches Farbschema mit tmux: Tokyo Night (Night). Exakt dieselben
        # Hex-Werte wie die tn-Palette in home/common/shell.nix, damit Terminal
        # und tmux-Statusbar wie ein zusammenhängendes Theme wirken.
        foreground = "c0caf5";
        cursor-color = "c0caf5";
        selection-background = "283457";
        selection-foreground = "c0caf5";
        palette = [
          "0=#15161e"
          "1=#f7768e"
          "2=#9ece6a"
          "3=#e0af68"
          "4=#7aa2f7"
          "5=#bb9af7"
          "6=#7dcfff"
          "7=#a9b1d6"
          "8=#414868"
          "9=#f7768e"
          "10=#9ece6a"
          "11=#e0af68"
          "12=#7aa2f7"
          "13=#bb9af7"
          "14=#7dcfff"
          "15=#c0caf5"
        ];

        # Comfortable Spacing: mehr Rand ums Terminal und etwas Luft zwischen
        # den Zeilen.
        window-padding-x = 15;
        window-padding-y = 15;
        window-padding-balance = true;
        adjust-cell-height = "12%";

        confirm-close-surface = false;
      };
    };
  };
}
