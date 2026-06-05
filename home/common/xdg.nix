{ config, lib, ... }:
{
  xdg.userDirs = {
    enable = true;
    createDirectories = lib.mkDefault true;
    setSessionVariables = lib.mkDefault false;

    desktop = lib.mkDefault "${config.home.homeDirectory}/Desktop";
    documents = lib.mkDefault "${config.home.homeDirectory}/Documents";
    download = lib.mkDefault "${config.home.homeDirectory}/Downloads";
    music = lib.mkDefault null;
    projects = lib.mkDefault null;
    pictures = lib.mkDefault "${config.home.homeDirectory}/Pictures";
    publicShare = lib.mkDefault null;
    templates = lib.mkDefault null;
    videos = lib.mkDefault "${config.home.homeDirectory}/Videos";
  };
}
