# Touch screen goodies for Hyprland (icicle / tablet).
# Hyprgrass: https://github.com/horriblename/hyprgrass
# wvkbd: on-screen keyboard for wlroots (Squeekboard requires GNOME session and fails on Hyprland)

{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  enableHyprgrass = false;
in
{
  home.packages = [ pkgs.wvkbd ];

  wayland.windowManager.hyprland = {
    plugins = lib.optional enableHyprgrass (inputs.hyprgrass.packages.${pkgs.system}.default);
    settings = {
      plugin.gestures = {
        workspace_swipe = true;
        workspace_swipe_cancel_ratio = 0.15;
      };

      plugin.touch_gestures = lib.mkIf enableHyprgrass {
        sensitivity = 4.0;
        workspace_swipe_fingers = 3;
        workspace_swipe_edge = "d";
        long_press_delay = 400;
        resize_on_border_long_press = true;
        edge_margin = 10;
        emulate_touchpad_swipe = false;

        "hyprgrass-bind" = [
          ", edge:r:l, workspace, +1"
          ", edge:l:r, workspace, -1"
          #  ", edge:d:u, exec, $browser"
          #  ", swipe:4:d, killactive"
          #  ", swipe:3:ld, exec, $terminal"
        ];
        "hyprgrass-bindm" = [
          ", longpress:2, movewindow"
          ", longpress:3, resizewindow"
        ];
      };
    };
  };
}
