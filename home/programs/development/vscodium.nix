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
            "editor.fontFamily" = "'JetBrains Mono', 'JetBrainsMono Nerd Font', monospace";
            "editor.fontSize" = 16;
            "editor.lineHeight" = 2;
            "files.autoSave" = "onFocusChange";
            "editor.cursorStyle" = "block";
            "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
            "terminal.integrated.fontSize" = 14;
            "telemetry.telemetryLevel" = "off";
            "update.mode" = "none";
          };
        };
      };
    };
  };
}
