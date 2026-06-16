# Smoothfox — Scrolling
# https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
#
# Aktiviere genau EINE der folgenden Optionen durch Auskommentieren.
# Standardmäßig ist "Instant Scrolling" (60Hz+) aktiv.
{ config, lib, ... }:
{
  config = lib.mkIf config.smi.programs.zen.enable {
    programs.zen-browser.profiles.default.settings = {

      # ---------------------------------------------------------------------------
      # OPTION 1: SHARPEN SCROLLING
      # Nur schärferes Scrollen ohne Physics. Gut für alle Displays.
      # ---------------------------------------------------------------------------
      # "apz.overscroll.enabled" = true;
      # "general.smoothScroll" = true;
      # "mousewheel.min_line_scroll_amount" = 10;
      # "general.smoothScroll.mouseWheel.durationMinMS" = 80;
      # "general.smoothScroll.currentVelocityWeighting" = "0.15";
      # "general.smoothScroll.stopDecelerationWeighting" = "0.6";
      # "general.smoothScroll.msdPhysics.enabled" = false;

      # ---------------------------------------------------------------------------
      # OPTION 2: INSTANT SCROLLING (aktiv — empfohlen für 60Hz+)
      # ---------------------------------------------------------------------------
      "apz.overscroll.enabled" = true;
      "general.smoothScroll" = true;
      "mousewheel.default.delta_multiplier_y" = 275; # 250–400, nach Geschmack anpassen
      "general.smoothScroll.msdPhysics.enabled" = false;

      # ---------------------------------------------------------------------------
      # OPTION 3: SMOOTH SCROLLING (empfohlen für 90Hz+)
      # ---------------------------------------------------------------------------
      # "apz.overscroll.enabled" = true;
      # "general.smoothScroll" = true;
      # "general.smoothScroll.msdPhysics.enabled" = true;
      # "mousewheel.default.delta_multiplier_y" = 300;

      # ---------------------------------------------------------------------------
      # OPTION 4: NATURAL SMOOTH SCROLLING V3 (empfohlen für 120Hz+)
      # Chrome-ähnliches Scrollverhalten
      # ---------------------------------------------------------------------------
      # "apz.overscroll.enabled" = true;
      # "general.smoothScroll" = true;
      # "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
      # "general.smoothScroll.msdPhysics.enabled" = true;
      # "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
      # "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
      # "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
      # "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
      # "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
      # "general.smoothScroll.currentVelocityWeighting" = "1";
      # "general.smoothScroll.stopDecelerationWeighting" = "1";
      # "mousewheel.default.delta_multiplier_y" = 300;
    };
  };
}
