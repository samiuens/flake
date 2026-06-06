{ config, lib, ... }:
(import ../../../../lib { inherit lib; }).mkGitProvider {
  inherit config lib;
  name = "gitlab";
  displayName = "GitLab";
  defaultInsteadOf = [
    "https://gitlab.com/"
    "gl:"
  ];
}
