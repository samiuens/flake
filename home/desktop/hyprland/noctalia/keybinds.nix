{
  osConfig,
  lib,
  ...
}:
let
  active =
    osConfig.smi.desktop.enable
    && osConfig.smi.desktop.environment == "hyprland"
    && osConfig.smi.desktop.shell == "noctalia";
in
{
  wayland.windowManager.hyprland.extraConfig = lib.mkIf active ''
    -- Farben von noctalia (~/.config/hypr/hyprland/colors.lua)
    pcall(require, "hyprland/colors")

    -- Noctalia overrides
    hl.config({
      general = {
        gaps_in = 10,
        gaps_out = 15,
      },
      decoration = {
        rounding = 15,
        rounding_power = 2,
        shadow = {
          range = 4,
          color = "rgba(1a1a1aee)",
        },
        blur = {
          size = 3,
          vibrancy = 0.1696,
        },
      },
    })

    -- Layer rule for noctalia background
    hl.layer_rule({
      name         = "noctalia",
      match        = { namespace = "noctalia-background-.*" },
      ignore_alpha = 0.5,
      blur         = true,
      blur_popups  = true,
    })

    -- Noctalia IPC
    hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle"))
    hl.bind("SUPER + S",     hl.dsp.exec_cmd("noctalia-shell ipc call controlCenter toggle"))
    hl.bind("SUPER + comma", hl.dsp.exec_cmd("noctalia-shell ipc call settings toggle"))
    hl.bind("SUPER + P",     hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock"))

    -- Audio / brightness (repeat + works when locked)
    hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("noctalia-shell ipc call volume increase"),     { repeating = true, locked = true })
    hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("noctalia-shell ipc call volume decrease"),     { repeating = true, locked = true })
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("noctalia-shell ipc call brightness increase"), { repeating = true, locked = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia-shell ipc call brightness decrease"), { repeating = true, locked = true })
    hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("noctalia-shell ipc call volume muteOutput"),   { locked = true })
  '';
}
