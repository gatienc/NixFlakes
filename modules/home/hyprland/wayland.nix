{
  pkgs,
  lib,
  config,
  ...
}:
let
  scripts = config.hyprland.scripts;
in
{
  config.wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    systemd.enable = true;
    settings = {
      input = {
        kb_layout = "fr";
        follow_mouse = 1;
        numlock_by_default = true;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        monitor = [
          "desc:Sharp Corporation 0x1479, 1920x1280@60, auto, 1.25"
          "desc:Iiyama North America PL2470H 0x00000117, 1920x1080@60, 0x0, 1"
          "desc:AU Optronics 0xB69B, 1920x1080@165, 1920x0, 1"
        ];
        gaps_in = 5;
        gaps_out = [
          5
          5
          5
          5
        ];
        border_size = 2;
        "col.active_border" = lib.mkDefault "rgb(5E81AC)";
        "col.inactive_border" = lib.mkDefault "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
        smart_split = "yes";
      };

      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "firefox";

      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, B, exec, $browser"
        "$mainMod, F, fullscreen "
        "$mainMod, escape, killactive"
        "$mainMod, V, togglefloating"
        "$mainMod, P, pin"
        "$mainMod CTRL, V,exec, pypr toggle volume"
        "$mainMod,A,exec,pypr toggle term"
        "$mainMod,Y,exec,pypr attach"
        "$mainMod SHIFT, M, exit,"
        '', Print, exec, grim -g "$(slurp -d)" - | wl-copy''
        "$mainMod, F12, exec, grim -g \"$(slurp -d)\" - | wl-copy"
        "$mainMod, ampersand, workspace, 1"
        "$mainMod, eacute, workspace, 2"
        "$mainMod, quotedbl, workspace, 3"
        "$mainMod, apostrophe, workspace, 4"
        "$mainMod, parenleft, workspace, 5"
        "$mainMod, minus, workspace, 6"
        "$mainMod, egrave, workspace, 7"
        "$mainMod, underscore, workspace, 8"
        "$mainMod, ccedilla, workspace, 9"
        "$mainMod, agrave, workspace, 10"
        "SUPER_SHIFT, ampersand, movetoworkspace, 1"
        "SUPER_SHIFT, eacute, movetoworkspace, 2"
        "SUPER_SHIFT, quotedbl, movetoworkspace, 3"
        "SUPER_SHIFT, apostrophe, movetoworkspace, 4"
        "SUPER_SHIFT, parenleft, movetoworkspace, 5"
        "SUPER_SHIFT, minus, movetoworkspace, 6"
        "SUPER_SHIFT, egrave, movetoworkspace, 7"
        "SUPER_SHIFT, underscore, movetoworkspace, 8"
        "SUPER_SHIFT, ccedilla, movetoworkspace, 9"
        "SUPER_SHIFT, agrave, movetoworkspace, 10"
        "$mainMod, mouse_up, workspace, e+1"
        "$mainMod, mouse_down, workspace, e-1"
        "$mainMod SHIFT, right, movetoworkspace, +1"
        "$mainMod SHIFT, left, movetoworkspace, -1"
        "$mainMod, Left, movefocus, l"
        "$mainMod, Right, movefocus, r"
        "$mainMod, Up, movefocus, u"
        "$mainMod, Down, movefocus, d"
        "$mainMod SHIFT, Left, movewindow, l"
        "$mainMod SHIFT, Right, movewindow, r"
        "$mainMod SHIFT, Up, movewindow, u"
        "$mainMod SHIFT, Down, movewindow, d"
        "$mainMod CTRL, Left, resizeactive, 50 0"
        "$mainMod CTRL, Right, resizeactive, -50 0"
        "$mainMod CTRL, Up, resizeactive, 0 -50"
        "$mainMod CTRL, Down, resizeactive, 0 50"
        "SUPER_SHIFT, l, exec, hyprlock"
        "$mainMod, space, exec, rofi -show drun"
        "$mainMod SHIFT, return, exec, swww-daemon & swww img $(find ${../../../assets/wallpaper} | shuf -n1) --transition-fps 60 --transition-duration 2 --transition-type any --transition-pos top-right --transition-bezier .3,0,0,.99 --transition-angle 135"
        "$mainMod, R, exec, ${scripts.readingModeToggle}/bin/reading-mode-toggle"
        "$mainMod, D, exec, hyprctl keyword general:layout dwindle"
        "$mainMod SHIFT, D, exec, hyprctl keyword general:layout master"
        "ALT, TAB, exec, pypr fetch_client_menu"
        "$mainMod, return, exec, open -na kitty --args /Users/gatien/Documents/transcribe-cli/.venv/bin/python3.13 -m transcribe_cli.cli record --to-clipboard"
        "$mainMod, TAB, exec, ${scripts.exchangeMonitors}/bin/exchange-monitors"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      binde = [
        ", XF86AudioRaiseVolume, exec, amixer set Master 5%+"
        ", XF86AudioLowerVolume, exec, amixer set Master 5%-"
        ", XF86AudioMute, exec, amixer set Master toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl s +5% "
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindl = [ ",switch:Lid Switch, exec, hyprlock" ];

      # Start as floating: popups, dialogs, and windows that request it
      windowrule = [
        "match:float 1, float on"
        "match:class pavucontrol, float on"
        "match:class blueman-manager, float on"
        "match:class yad, float on"
        "match:class bitwarden, float on"
        "match:initial_title .*[Bb]itwarden.*, float on"
      ];

      misc = {
        disable_hyprland_logo = true;
        enable_swallow = true;
      };

      exec-once = [
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd HYPRLAND_INSTANCE_SIGNATURE"
        "hyprshade install"
        "systemctl --user enable --now hyprshade.timer"
        "${scripts.sessionStart}/bin/hyprland-session-start"
        "hyprshade auto"
        "hyprctl seterror disable"
      ];
    };
  };
}
