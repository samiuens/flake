{ lib, ... }:
{
  imports = [
    ./fish.nix
    ./starship.nix
    ./neovim.nix
    ./tmux.nix
  ];

  options.smi.shell = {
    tmux.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable tmux";
    };

    tmux.accentColor = lib.mkOption {
      type = lib.types.str;
      default = "#7aa2f7";
      description = "Tmux status bar and border accent color";
    };

    neovim.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neovim as the default editor";
    };

    starship.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Starship prompt";
    };
  };
}
