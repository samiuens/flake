# Smoothfox — Scrolling
# https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
#
# Aktiviere genau EINE der folgenden Optionen durch Auskommentieren.
# Standardmäßig ist "Instant Scrolling" (60Hz+) aktiv.
{ config, lib, ... }:
{
  config = lib.mkIf config.smi.programs.zen.enable {
    programs.zen-browser.profiles.default.settings = {
      "apz.overscroll.enabled" = true;
      "general.smoothScroll" = true;
      "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
      "general.smoothScroll.msdPhysics.enabled" = true;
      "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
      "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
      "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
      "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
      "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
      "general.smoothScroll.currentVelocityWeighting" = "1";
      "general.smoothScroll.stopDecelerationWeighting" = "1";
      "mousewheel.default.delta_multiplier_y" = 100;
    };
  };
}
