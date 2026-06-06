{
  config,
  lib,
  pkgs,
  ...
}:
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "bitwarden";
  packages = [ pkgs.bitwarden-desktop ];
}
