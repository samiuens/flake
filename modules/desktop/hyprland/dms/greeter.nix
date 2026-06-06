{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  active =
    config.smi.desktop.enable
    && config.smi.desktop.environment == "hyprland"
    && config.smi.desktop.shell == "dms";
  system = pkgs.stdenv.hostPlatform.system;
  kb = config.smi.keyboard;

  greeterCompositorConfig = ''
    hl.config({
      input = {
        kb_layout = "${kb.layout}",
        kb_variant = "${kb.variant}",
      },
    })

    hl.env("XCURSOR_THEME", "Adwaita")
    hl.env("XCURSOR_SIZE", "24")
    hl.env("XCURSOR_PATH", "${pkgs.adwaita-icon-theme}/share/icons")
  '';
in
{
  imports = [
    inputs.dms.nixosModules.greeter
  ];

  config = lib.mkIf (active && config.smi.desktop.dms.greeter.enable) {
    programs.dank-material-shell.greeter = {
      enable = true;
      compositor.name = "hyprland";
      compositor.customConfig = greeterCompositorConfig;
      package = inputs.dms.packages.${system}.dms-shell;
      quickshell.package = pkgs.quickshell;
      configHome = config.smi.desktop.dms.greeter.configHome;
    };
    services.greetd.settings.default_session.user = lib.mkDefault "greeter";
  };
}
