{
  config,
  lib,
  inputs,
  ...
}:
let
  name = "zen";
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
    ./securefox.nix
    ./peskyfox.nix
    ./smoothfox.nix
    ./containers.nix
    ./extensions.nix
    ./mods.nix
    ./search.nix
    ./spaces.nix
    ./xdg.nix
  ];

  options.smi.programs.${name}.enable = lib.mkEnableOption name;

  config = lib.mkIf config.smi.programs.${name}.enable {

    # create symlink: ~/.zen -> ~/.config/zen
    # making sure zen doesn't use its legacy path
    home.file.".zen" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/zen";
    };

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;

      profiles.default = {
        # https://github.com/yokoffing/Betterfox/wiki/Common-Overrides
        settings = {
          "browser.search.suggest.enabled" = lib.mkForce true;
          "layout.spellcheckDefault" = 0;
          "signon.firefoxRelay.feature" = "disabled";
          "zen.welcome-screen.seen" = true;
          "network.trr.mode" = 3;
          "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
          "signon.rememberSignons" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
        };
      };
    };
  };
}
