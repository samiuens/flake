{ inputs, helpers, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs helpers;
      platform = "linux";
    };
    backupFileExtension = ".bak";
    sharedModules = [
      (import ../../home)
      inputs.nix-index-database.homeModules.default
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];
  };
}
