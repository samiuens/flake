{
  config,
  lib,
  ...
}:
let
  name = "zed";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name} = {
    enable = lib.mkEnableOption name;

    bufferFont = {
      family = lib.mkOption {
        type = lib.types.str;
        default = "JetBrains Mono";
        description = "Editor buffer font family";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 16;
        description = "Editor buffer font size";
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
    programs.zed-editor = {
      enable = true;
      extensions = [
        "material-icon-theme"
        "nix"
      ];
      userSettings = {
        icon_theme = "Material Icon Theme";
        ui_font_family = ".ZedSans";
        ui_font_size = 16;

        autosave = "on_focus_change";
        cursor_shape = "block";
        buffer_font_family = cfg.bufferFont.family;
        buffer_font_size = cfg.bufferFont.size;

        terminal = {
          font_family = cfg.terminal.fontFamily;
          font_size = cfg.terminal.fontSize;
        };

        features.copilot = false;
        disable_ai = true;

        telemetry.metrics = false;

        load_direnv = "shell_hook";
        lsp.nixd.binary.path = "nixd";
        languages.Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter.external = {
            command = "nixfmt";
            arguments = [ "-q" ];
          };
          format_on_save = "on";
        };
      };
    };
  };
}
