{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.smi.services.mullvad-vpn.enable = lib.mkEnableOption "Mullvad VPN";

  config = lib.mkIf config.smi.services.mullvad-vpn.enable {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
