{
  platforms = [ "linux" ];
  module =
    { config, lib, ... }:
    let
      name = "firefox";
    in
    {
      options.smi.programs.${name}.enable = lib.mkEnableOption name;

      config = lib.mkIf config.smi.programs.${name}.enable {
        programs.firefox.enable = true;
      };
    };
}
