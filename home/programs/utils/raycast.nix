{
  config,
  lib,
  pkgs,
  ...
}:
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "raycast";
  packages = [ pkgs.raycast ];
  condition = pkgs.stdenv.isDarwin;
}
