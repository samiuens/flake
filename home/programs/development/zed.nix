{
  config,
  lib,
  ...
}:
let
  name = "zed";
  cfg = config.smi.programs.${name};
in
{
  options.smi.programs.${name}.enable = lib.mkEnableOption name;

  config = lib.mkIf cfg.enable {
    programs.zed-editor.enable = true;
  };
}
