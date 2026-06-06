{
  config,
  lib,
  pkgs,
  ...
}:
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "vesktop";
  packages = [ pkgs.vesktop ];
}
