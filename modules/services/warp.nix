{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.smi.services.warp.enable = lib.mkEnableOption "Cloudflare WARP";

  config = lib.mkIf config.smi.services.warp.enable {
    services.cloudflare-warp.enable = true;
  };
}
