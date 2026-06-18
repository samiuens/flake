{
  config,
  lib,
  pkgs,
  ...
}:
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "nodejs";
  # Provides node + npx, e.g. for `npx @upstash/context7-mcp` in Claude Code.
  packages = [ pkgs.nodejs ];
}
