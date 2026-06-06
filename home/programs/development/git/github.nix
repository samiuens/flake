{ config, lib, ... }:
(import ../../../../lib { inherit lib; }).mkGitProvider {
  inherit config lib;
  name = "github";
  displayName = "GitHub";
  defaultInsteadOf = [
    "https://github.com/"
    "gh:"
  ];
}
