{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.smi.desktop.fonts;

  apple-color-emoji = pkgs.stdenvNoCC.mkDerivation {
    name = "apple-color-emoji";
    version = "20260219";
    src = pkgs.fetchurl {
      url = "https://github.com/samuelngs/apple-emoji-ttf/releases/download/macos-26-20260219-2aa12422/AppleColorEmoji-Linux.ttf";
      hash = "sha256-U1oEOvBHBtJEcQWeZHRb/IDWYXraLuo0NdxWINwPUxg=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src $out/share/fonts/truetype/AppleColorEmoji.ttf
    '';
  };
in
{
  options.smi.desktop.fonts = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fonts and fontconfig";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        adwaita-fonts
        roboto
        inter
        nerd-fonts.jetbrains-mono
        jetbrains-mono
        apple-color-emoji
      ];
      defaultText = lib.literalExpression "[ adwaita-fonts roboto inter nerd-fonts.jetbrains-mono jetbrains-mono apple-color-emoji ]";
      description = "Font packages to install";
    };

    defaultEmoji = lib.mkOption {
      type = lib.types.str;
      default = "Apple Color Emoji";
      description = "Default emoji font for fontconfig";
    };
  };

  config = lib.mkIf (cfg.enable && config.smi.desktop.enable) {
    fonts = {
      fontDir.enable = true;
      inherit (cfg) packages;
      fontconfig.defaultFonts.emoji = [ cfg.defaultEmoji ];
    };
  };
}
