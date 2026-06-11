{
  platforms = [ "linux" ];
  module =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.smi.services.warp.autoConnect = lib.mkEnableOption "Cloudflare WARP auto-connect on login";

      config = lib.mkIf config.smi.services.warp.autoConnect {
        systemd.user.services.warp-connect = {
          Unit = {
            Description = "Cloudflare WARP auto-connect";
            After = [ "default.target" ];
          };
          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.cloudflare-warp}/bin/warp-cli --accept-tos connect";
            ExecStop = "${pkgs.cloudflare-warp}/bin/warp-cli disconnect";
          };
          Install.WantedBy = [ "default.target" ];
        };
      };
    };
}
