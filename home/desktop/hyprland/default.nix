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
  cursorSize = toString config.smi.desktop.cursor.size;
in
{
  imports = [ ./noctalia ];

  config = lib.mkIf active {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = ",preferred,auto,auto";

        "$mod" = "SUPER";

        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = "rgba(89b4faff) rgba(cba6f7ff) 45deg";
          "col.inactive_border" = "rgba(4c566a66)";
          layout = "dwindle";
        };

        decoration = {
          rounding = 8;
          blur = {
            enabled = true;
            size = 4;
            passes = 2;
          };
          shadow = {
            enabled = true;
            range = 20;
            render_power = 3;
            color = "rgba(0, 0, 0, 0.4)";
          };
          dim_inactive = true;
          dim_strength = 0.05;
        };

        animations = {
          enabled = true;
          bezier = "smooth, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 6, smooth, slide"
            "fade, 1, 6, default"
            "workspaces, 1, 6, default, slide"
          ];
        };

        input = {
          kb_layout = osConfig.smi.locale.keyboard.layout;
          follow_mouse = 2;
          touchpad.natural_scroll = true;
        };

        env = [
          "XCURSOR_SIZE,${cursorSize}"
          "HYPRCURSOR_SIZE,${cursorSize}"
        ];

        misc = {
          force_default_wallpaper = 0;
          background_color = "0x1e1e2e";
          disable_hyprland_logo = true;
        };

        exec-once = [
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        ]
        ++ lib.optionals noctaliaActive [
          "noctalia-shell -d"
        ];

        bind = [
          "$mod, Return, exec, ghostty"
          "$mod, Q, killactive"
          "$mod, F, fullscreen"

          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, l, movewindow, r"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, j, movewindow, d"
        ]
        ++ builtins.concatMap (i: [
          "$mod, ${toString i}, workspace, ${toString i}"
          "$mod SHIFT, ${toString i}, movetoworkspace, ${toString i}"
        ]) (lib.range 1 9);

        # repeat-on-hold (binde) für flüssiges Resizing.
        binde = [
          "$mod, plus,  resizeactive,  40 0"
          "$mod, minus, resizeactive, -40 0"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
