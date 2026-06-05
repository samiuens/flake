{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.smi.programs.zen.enable {
    programs.zen-browser.profiles.default = {
      spacesForce = true; # Delete spaces not declared here
      spaces = {
        "Persönlich" = {
          id = "0597770a-4614-4634-8b27-63a4407577f1";
          icon = "👤";
          position = 1000;
          container = 1;
        };
      };
    };
  };
}
