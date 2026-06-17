{
  config,
  lib,
  pkgs,
  ...
}:
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "shottr";
  packages = [ pkgs.shottr ];
  condition = pkgs.stdenv.isDarwin;
}
