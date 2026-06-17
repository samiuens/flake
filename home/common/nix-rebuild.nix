{
  platforms = [ "darwin" ];
  module = {
    programs.fish.shellAbbrs = {
      # Rebuild against the flake's `nix` input from git (github:samiuens/flake, locked)
      rebuild = "sudo darwin-rebuild switch --flake /Users/smi/nix/smi#smi-mac";

      # Rebuild against the local flake working copy (overrides the git input)
      rebuild-local = "sudo darwin-rebuild switch --flake /Users/smi/nix/smi#smi-mac --override-input nix path:/Users/smi/nix/flake";
    };
  };
}
