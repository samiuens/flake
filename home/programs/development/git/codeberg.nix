{ config, lib, ... }:
(import ../../../../lib { inherit lib; }).mkGitProvider {
  inherit config lib;
  name = "codeberg";
  displayName = "Codeberg";
  defaultInsteadOf = [
    "https://codeberg.org/"
    "cb:"
  ];
}
