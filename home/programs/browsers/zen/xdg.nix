{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.smi.programs.zen.enable {
    xdg.mimeApps =
      let
        associations = builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value = "zen-beta.desktop";
            })
            [
              "application/x-extension-shtml"
              "application/x-extension-xhtml"
              "application/x-extension-html"
              "application/x-extension-xht"
              "application/x-extension-htm"
              "x-scheme-handler/unknown"
              "x-scheme-handler/mailto"
              "x-scheme-handler/chrome"
              "x-scheme-handler/about"
              "x-scheme-handler/https"
              "x-scheme-handler/http"
              "application/xhtml+xml"
              "text/html"
            ]
        );
      in
      {
        enable = true;
        associations.added = associations;
        defaultApplications = associations;
      };
  };
}
