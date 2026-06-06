{
  description = "smi's nixos flake";

  inputs = {
    # Essentials
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Utils
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # UI
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      git-hooks,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});

      helpers = import ./lib { inherit (nixpkgs) lib; };
      nixosModule = import ./modules;

      mkHost =
        {
          inputs,
          self,
          userRegistry,
          system ? "x86_64-linux",
        }:
        hostsDir: hostname:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              self
              helpers
              userRegistry
              ;
          };
          modules = [
            nixosModule
            (hostsDir + "/${hostname}")
          ];
        };

      pre-commit-checkFor = forAllSystems (
        system:
        git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            nil.enable = true;
          };
        }
      );
    in
    {
      nixosModules.default = nixosModule;
      homeManagerModules.default = import ./home;
      lib = helpers // {
        inherit mkHost;
      };

      formatter = forAllSystems (system: pkgsFor.${system}.nixfmt);

      checks = forAllSystems (system: {
        pre-commit-check = pre-commit-checkFor.${system};
      });

      devShells = forAllSystems (system: {
        default = pkgsFor.${system}.mkShell {
          inherit (pre-commit-checkFor.${system}) shellHook;
          buildInputs =
            pre-commit-checkFor.${system}.enabledPackages
            ++ (with pkgsFor.${system}; [
              nixd
              nil
              statix
              deadnix
              nixfmt
            ]);
        };
      });
    };
}
