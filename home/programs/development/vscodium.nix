{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "vscodium";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;

    editor = {
      fontFamily = lib.mkOption {
        type = lib.types.str;
        default = "'JetBrains Mono', 'JetBrainsMono Nerd Font', monospace";
        description = "Editor font family";
      };
      fontSize = lib.mkOption {
        type = lib.types.int;
        default = 16;
        description = "Editor font size";
      };
    };

    terminal = {
      fontFamily = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
        description = "Integrated terminal font family";
      };
      fontSize = lib.mkOption {
        type = lib.types.int;
        default = 14;
        description = "Integrated terminal font size";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      mutableExtensionsDir = false;

      profiles = {
        "typst" = {
          extensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            myriad-dreamin.tinymist
            mkhl.direnv
            pkief.material-icon-theme
            editorconfig.editorconfig
            tomoki1207.pdf
          ];

          userSettings = {
            "workbench.iconTheme" = "material-icon-theme";
            "editor.fontFamily" = cfg.editor.fontFamily;
            "editor.fontSize" = cfg.editor.fontSize;
            "editor.lineHeight" = 2;
            "files.autoSave" = "onFocusChange";
            "editor.cursorStyle" = "block";
            "terminal.integrated.fontFamily" = cfg.terminal.fontFamily;
            "terminal.integrated.fontSize" = cfg.terminal.fontSize;
            "telemetry.telemetryLevel" = "off";
            "update.mode" = "none";
          };
        };
      };
    };
  };
}
