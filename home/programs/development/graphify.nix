{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs) uv2nix pyproject-nix pyproject-build-systems;

  # graphifyy is not in nixpkgs and pulls ~30 tree-sitter grammars, so build it
  # reproducibly from the pinned uv.lock in ./graphify via uv2nix.
  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./graphify; };

  overlay = workspace.mkPyprojectOverlay {
    # Prefer prebuilt wheels to avoid compiling the tree-sitter grammars.
    sourcePreference = "wheel";
  };

  python = pkgs.python312;

  pythonSet = (pkgs.callPackage pyproject-nix.build.packages { inherit python; }).overrideScope (
    lib.composeManyExtensions [
      pyproject-build-systems.overlays.default
      overlay
    ]
  );

  # Virtual env exposing the `graphify` CLI on bin/.
  graphify = pythonSet.mkVirtualEnv "graphify-env" workspace.deps.default;
in
(import ../../../lib { inherit lib; }).mkSimpleProgram {
  inherit config lib;
  name = "graphify";
  packages = [ graphify ];
}
