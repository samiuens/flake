{
  config,
  lib,
  pkgs,
  ...
}:
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "signal";
  packages = [ pkgs.signal-desktop ];
}
