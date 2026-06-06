{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.smi.boot.limine;
in
{
  options.smi.boot.limine = {
    enable = lib.mkEnableOption "Limine bootloader";

    secureBoot = lib.mkEnableOption "Secure Boot via sbctl";

    maxGenerations = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Max generations shown in the boot menu";
    };

    windowsEfiUuid = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "1c135138-506a-45ed-8352-6455f45e9fea";
      description = "EFI partition UUID of the Windows bootloader; adds a Windows entry to the menu";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.limine = {
      enable = true;
      secureBoot.enable = cfg.secureBoot;
      inherit (cfg) maxGenerations;
      extraEntries = lib.mkIf (cfg.windowsEfiUuid != null) ''
        /Windows
          protocol: efi
          path: uuid(${cfg.windowsEfiUuid}):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };

    environment.systemPackages = [ pkgs.sbctl ];
  };
}
