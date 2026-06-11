{
  platforms = [ "linux" ];
  module =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    (import ../../../lib { inherit lib; }).mkSimpleProgram {
      inherit config lib;
      name = "chrome";
      packages = [ pkgs.google-chrome ];
    };
}
