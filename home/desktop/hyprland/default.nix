{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}:
let
  active = osConfig.smi.desktop.enable && osConfig.smi.desktop.environment == "hyprland";
  noctaliaActive = active && osConfig.smi.desktop.shell == "noctalia";
  dmsActive = active && osConfig.smi.desktop.shell == "dms";
  cursorSize = toString config.smi.desktop.cursor.size;
  kbLayout = osConfig.smi.keyboard.layout;

  workspaceBinds = builtins.concatStringsSep "\n        " (
    builtins.concatMap (i: [
      ''hl.bind("SUPER + ${toString i}", hl.dsp.focus({ workspace = ${toString i} }))''
      ''hl.bind("SUPER + SHIFT + ${toString i}", hl.dsp.window.move({ workspace = ${toString i} }))''
    ]) (lib.range 1 9)
  );
in
{
  imports = [
    ./noctalia
    ./dms
  ];

  config = lib.mkIf active {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        -- Monitor / env
        hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
        hl.env("XCURSOR_SIZE", "${cursorSize}")
        hl.env("HYPRCURSOR_SIZE", "${cursorSize}")

        -- Base settings
        hl.config({
          general = {
            gaps_in = 4,
            gaps_out = 8,
            border_size = 2,
            col = {
              active_border   = { colors = { "rgba(89b4faff)", "rgba(cba6f7ff)" }, angle = 45 },
              inactive_border = "rgba(4c566a66)",
            },
            layout = "dwindle",
          },
          decoration = {
            rounding = 8,
            blur = {
              enabled = true,
              size = 4,
              passes = 2,
            },
            shadow = {
              enabled = true,
              range = 20,
              render_power = 3,
              color = "rgba(0, 0, 0, 0.4)",
            },
            dim_inactive = true,
            dim_strength = 0.05,
          },
          input = {
            kb_layout = "${kbLayout}",
            follow_mouse = 2,
            touchpad = {
              natural_scroll = true,
            },
          },
          misc = {
            force_default_wallpaper = 0,
            background_color = "0x1e1e2e",
            disable_hyprland_logo = true,
          },
        })

        ${lib.optionalString dmsActive ''
          do
            local ok, c = pcall(dofile, os.getenv("HOME") .. "/.config/hypr/dms/colors.lua")
            if ok and type(c) == "table" then
              hl.config({ general = { col = {
                active_border   = c.active,
                inactive_border = c.inactive,
              } } })
            end
          end''}

        -- Animations
        hl.curve("smooth", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
        hl.animation({ leaf = "windows",    enabled = true, speed = 6, bezier = "smooth",  style = "slide" })
        hl.animation({ leaf = "fade",       enabled = true, speed = 6, bezier = "default" })
        hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default", style = "slide" })

        -- Autostart
        hl.on("hyprland.start", function ()
          hl.exec_cmd("${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
          ${lib.optionalString noctaliaActive ''hl.exec_cmd("noctalia-shell -d")''}
          ${lib.optionalString dmsActive ''hl.exec_cmd("dms run")''}
        end)

        -- App / window
        hl.bind("SUPER + Return", hl.dsp.exec_cmd("ghostty"))
        hl.bind("SUPER + Q",      hl.dsp.window.close())
        hl.bind("SUPER + F",      hl.dsp.window.fullscreen({ action = "toggle" }))

        -- Focus
        hl.bind("SUPER + h", hl.dsp.focus({ direction = "l" }))
        hl.bind("SUPER + l", hl.dsp.focus({ direction = "r" }))
        hl.bind("SUPER + k", hl.dsp.focus({ direction = "u" }))
        hl.bind("SUPER + j", hl.dsp.focus({ direction = "d" }))

        -- Move window
        hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
        hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
        hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
        hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

        -- Workspaces
        ${workspaceBinds}

        -- Resize (repeat-on-hold)
        hl.bind("SUPER + plus",  hl.dsp.window.resize({ x =  40, y = 0, relative = true }), { repeating = true })
        hl.bind("SUPER + minus", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })

        -- Mouse
        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
        hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
      '';
    };
  };
}
