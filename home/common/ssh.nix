{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "confirm";
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
    };
  };
}
