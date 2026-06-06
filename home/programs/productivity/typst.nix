{
  config,
  lib,
  pkgs,
  ...
}:
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "typst";
  packages = with pkgs; [
    typst
    tinymist
  ];
}
