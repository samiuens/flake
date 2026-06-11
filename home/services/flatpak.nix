{
  platforms = [ "linux" ];
  module =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.smi.services.flatpak;
    in
    {
      options.smi.services.flatpak = {
        packages = lib.mkOption {
          type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
          default = [ ];
          example = [
            "com.spotify.Client"
            {
              appId = "us.zoom.Zoom";
              origin = "flathub";
            }
          ];
          description = "User-scoped Flatpaks to install";
        };
      };

      config = {
        services.flatpak.packages = cfg.packages;
      };
    };
}
