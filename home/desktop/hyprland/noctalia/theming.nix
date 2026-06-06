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
    && osConfig.smi.desktop.shell == "noctalia";
in
{
  xdg.configFile."qt6ct/qt6ct.conf" = lib.mkIf active {
    text = ''
      [Appearance]
      custom_palette=true
      color_scheme_path=${config.xdg.configHome}/qt6ct/colors/noctalia.conf
      icon_theme=Adwaita
      standard_dialogs=default
      style=Fusion
    '';
  };
  gtk = lib.mkIf active {
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

  home.file.".icons/default/index.theme" = lib.mkIf active {
    text = ''
      [Icon Theme]
      Inherits=Adwaita
    '';
  };
  dconf.settings."org/gnome/desktop/interface" = lib.mkIf active {
    gtk-theme = "adw-gtk3";
    icon-theme = "Adwaita";
  };
}
