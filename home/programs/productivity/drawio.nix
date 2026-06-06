{
  config,
  lib,
  pkgs,
  ...
}:
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "drawio";
  packages = [ pkgs.drawio ];
}
