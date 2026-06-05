{
  config,
  lib,
  ...
}:
let
  name = "zed";
in
{
  options.smi.programs.${name}.enable = lib.mkEnableOption name;

  config = lib.mkIf config.smi.programs.${name}.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "material-icon-theme"
        "nix"
      ];
      userSettings = {
        # Visuals
        icon_theme = "Material Icon Theme";
        ui_font_family = ".ZedSans";
        ui_font_size = 16;

        # Editor
        autosave = "on_focus_change";
        cursor_shape = "block";
        buffer_font_family = "JetBrains Mono";
        buffer_font_size = 16;

        # Terminal
        terminal = {
          font_family = "JetBrainsMono Nerd Font";
          font_size = 14;
        };

        # AI
        features.copilot = false;
        disable_ai = true;

        # Telemetry
        telemetry.metrics = false;

        # Nix LSP via devShell + direnv
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
