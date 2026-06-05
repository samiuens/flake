{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.smi.programs.zen.enable {
    programs.zen-browser.profiles.default = {
      containersForce = true; # Delete containers not declared here
      containers = {
        Personal = {
          color = "blue";
          icon = "circle";
          id = 1;
        };
      };
    };
  };
}
