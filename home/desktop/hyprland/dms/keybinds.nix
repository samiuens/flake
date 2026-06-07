{
  osConfig,
  lib,
  ...
}:
let
  active =
    osConfig.smi.desktop.enable
    && osConfig.smi.desktop.environment == "hyprland"
    && osConfig.smi.desktop.shell == "dms";
in
{
  wayland.windowManager.hyprland.extraConfig = lib.mkIf active ''
    -- DMS overrides
    hl.config({
      general = {
        gaps_in = 10,
        gaps_out = 15,
      },
      decoration = {
        rounding = 15,
        rounding_power = 2,
      },
    })

    -- DMS IPC (Verben aus docs/IPC.md)
    hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
    hl.bind("SUPER + S",     hl.dsp.exec_cmd("dms ipc call control-center toggle"))
    hl.bind("SUPER + V",     hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
    hl.bind("SUPER + N",     hl.dsp.exec_cmd("dms ipc call notifications toggle"))
    hl.bind("SUPER + comma", hl.dsp.exec_cmd("dms ipc call settings toggle"))
    hl.bind("SUPER + P",     hl.dsp.exec_cmd("dms ipc call lock lock"))

    -- Audio / brightness (repeat + works when locked)
    hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("dms ipc call audio increment 5"),       { repeating = true, locked = true })
    hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("dms ipc call audio decrement 5"),       { repeating = true, locked = true })
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("dms ipc call brightness increment 5"), { repeating = true, locked = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("dms ipc call brightness decrement 5"), { repeating = true, locked = true })
    hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("dms ipc call audio mute"),              { locked = true })
  '';
}
