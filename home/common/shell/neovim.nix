{ config, lib, ... }:
let
  cfg = config.smi.shell;
in
{
  config.programs.neovim = lib.mkIf cfg.neovim.enable {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
}
