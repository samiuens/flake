{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (pkgs) gnomeExtensions;
  gnomeActive = osConfig.smi.desktop.enable && osConfig.smi.desktop.environment == "gnome";
in
{
  home.packages = lib.mkIf gnomeActive (
    with gnomeExtensions;
    [
      appindicator
      blur-my-shell
      caffeine
      dash-to-dock
      just-perfection
    ]
  );

  dconf.settings = lib.mkIf gnomeActive {
    "org/gnome/shell" = {
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
        #"dash-to-dock@micxgx.gmail.com"
        "just-perfection-desktop@just-perfection"
      ];
    };
    /*
      "org/gnome/shell/extensions/dash-to-dock" = {
        show-trash = false;
      };
    */
    "org/gnome/shell/extensions/just-perfection" = {
      activites-button = false;
    };
  };
}
