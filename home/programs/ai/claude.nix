{
  config,
  lib,
  pkgs,
  ...
}:
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "claude";
  packages = [ pkgs.claude-code ];
}
