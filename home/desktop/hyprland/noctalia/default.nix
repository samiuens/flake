{
  osConfig,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  active =
    osConfig.smi.desktop.enable
    && osConfig.smi.desktop.environment == "hyprland"
    && osConfig.smi.desktop.shell == "noctalia";
  syncColorScheme = pkgs.writeShellScript "noctalia-sync-color-scheme" ''
    set -eu
    state="$(noctalia-shell ipc call state all 2>/dev/null || true)"
    if [ -z "$state" ]; then
      exit 0
    fi
    if [ "$(printf '%s' "$state" | ${pkgs.jq}/bin/jq -r '.settings.colorSchemes.darkMode // false')" = "true" ]; then
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
    else
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
    fi
  '';
in
{
  imports = [
    inputs.noctalia.homeModules.default
    ./settings
  ];
  home.packages = lib.mkIf active [ pkgs.xdg-desktop-portal-gtk ];

  programs = lib.mkIf active {
    noctalia-shell = {
      enable = true;
      user-templates.templates = {
        hyprland = {
          input_path = "${inputs.noctalia}/Assets/Templates/hyprland.conf";
          output_path = "${config.xdg.configHome}/hypr/noctalia-colors.conf";
          post_hook = "hyprctl reload && ${syncColorScheme}";
        };
        gtk3 = {
          input_path = "${inputs.noctalia}/Assets/Templates/gtk3.css";
          output_path = "${config.xdg.configHome}/gtk-3.0/gtk.css";
        };
        gtk4 = {
          input_path = "${inputs.noctalia}/Assets/Templates/gtk4.css";
          output_path = "${config.xdg.configHome}/gtk-4.0/gtk.css";
        };
        qt6ct = {
          input_path = "${inputs.noctalia}/Assets/Templates/qtct.conf";
          output_path = "${config.xdg.configHome}/qt6ct/colors/noctalia.conf";
        };
        ghostty = {
          input_path = "${inputs.noctalia}/Assets/Templates/terminal/ghostty";
          output_path = "${config.xdg.configHome}/ghostty/noctalia-colors";
          post_hook = "pkill -SIGUSR2 -x ghostty || true";
        };
        tmux = {
          input_path = "${./templates/tmux.conf}";
          output_path = "${config.xdg.configHome}/tmux/noctalia-colors.conf";
          post_hook = "tmux source-file ${config.xdg.configHome}/tmux/noctalia-colors.conf 2>/dev/null || true";
        };
        zed = {
          input_path = "${./templates/zed.json}";
          output_path = "${config.xdg.configHome}/zed/themes/noctalia.json";
        };
        /*
          zen = {
            input_path = "${./templates/zen.css}";
            output_path = "${config.home.homeDirectory}/.config/zen/default/chrome/userChrome.css";
          };
        */
      };
    };

    zen-browser.profiles.default.settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = lib.mkDefault true;
      "widget.use-xdg-desktop-portal.appearance" = lib.mkDefault 1;
      "layout.css.prefers-color-scheme.content-override" = lib.mkDefault 2;
    };
    firefox.profiles.default.settings = {
      "widget.use-xdg-desktop-portal.appearance" = lib.mkDefault 1;
      "layout.css.prefers-color-scheme.content-override" = lib.mkDefault 2;
    };
    ghostty.settings.config-file = "?${config.xdg.configHome}/ghostty/noctalia-colors";
    tmux.extraConfig = lib.mkAfter ''
      source-file -q ~/.config/tmux/noctalia-colors.conf
    '';
    zed-editor.userSettings.theme = lib.mkForce "Noctalia";
  };

  xdg.configFile."qt6ct/qt6ct.conf" = lib.mkIf active {
    text = ''
      [Appearance]
      custom_palette=true
      color_scheme_path=${config.xdg.configHome}/qt6ct/colors/noctalia.conf
      icon_theme=Adwaita
      standard_dialogs=default
      style=Fusion
    '';
  };
  gtk = lib.mkIf active {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  home.file.".icons/default/index.theme" = lib.mkIf active {
    text = ''
      [Icon Theme]
      Inherits=Adwaita
    '';
  };
  dconf.settings."org/gnome/desktop/interface" = lib.mkIf active {
    gtk-theme = "adw-gtk3";
    icon-theme = "Adwaita";
  };

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
