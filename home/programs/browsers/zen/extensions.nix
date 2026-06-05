{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.smi.programs.zen.enable {
    programs.zen-browser.policies =
      let
        # about:debugging#/runtime/this-firefox
        # attrset: { "<extension-id>" = "<amo-slug>"; }
        mkExtensionSettings = builtins.mapAttrs (
          _extensionId: amoSlug: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${amoSlug}/latest.xpi";
            installation_mode = "force_installed";
          }
        );
      in
      {
        ExtensionSettings = mkExtensionSettings {
          "uBlock0@raymondhill.net" = "ublock-origin";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
          "addon@darkreader.org" = "darkreader";
          "sponsorBlocker@ajay.app" = "sponsorblock";
        };

        # uBlock Origin Managed Storage. `adminSettings` ist als JSON-String
        # an die Extension zu übergeben; uBO importiert ihn wie ein Backup.
        # Quelle ist ./ublock-backup.json — Dashboard → Settings → Backup to
        # file → Datei hier ablegen, dann home-manager switch.
        "3rdparty" = {
          Extensions = {
            "uBlock0@raymondhill.net" = {
              adminSettings = builtins.readFile ./ublock-backup.json;
            };
          };
        };
      };
  };
}
