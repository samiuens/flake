{
  config,
  lib,
  pkgs,
  ...
}:
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "chromium";
  packages = [ pkgs.ungoogled-chromium ];
}
