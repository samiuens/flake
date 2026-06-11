{ inputs, helpers, ... }:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs helpers;
      platform = "darwin";
    };
    backupFileExtension = ".bak";
    sharedModules = [
      (import ../../home)
      inputs.nix-index-database.homeModules.default
    ];
  };
}
