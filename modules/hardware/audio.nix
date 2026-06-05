{ config, lib, ... }:
{
  options.smi.hardware.audio.enable = lib.mkEnableOption "Pipewire-Audio-Stack";

  config = lib.mkIf config.smi.hardware.audio.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = false;
      pulse.enable = true;
      jack.enable = false;
    };
  };
}
