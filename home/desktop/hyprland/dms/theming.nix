{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  active =
    osConfig.smi.desktop.enable
    && osConfig.smi.desktop.environment == "hyprland"
    && osConfig.smi.desktop.shell == "dms";
in
{
  config = lib.mkIf active {
    xdg.configFile."qt6ct/qt6ct.conf".text = ''
      [Appearance]
      custom_palette=true
      color_scheme_path=${config.xdg.configHome}/qt6ct/colors/matugen.conf
      icon_theme=Adwaita
      standard_dialogs=default
      style=Fusion
    '';
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
    home.file.".icons/default/index.theme".text = ''
      [Icon Theme]
      Inherits=Adwaita
    '';
    dconf.settings."org/gnome/desktop/interface" = {
      gtk-theme = "adw-gtk3";
      icon-theme = "Adwaita";
    };
  };
}
