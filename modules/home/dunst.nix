{
  config,
  lib,
  ...
}:
let
  colors = (config.lib.stylix or {}).colors or { base03 = "6272a4"; base08 = "ff5555"; base0D = "8be9fd"; };
  inherit (colors) base03 base08 base0D;
  # Liquid glass: thin border, rounded (if supported), spacing
  globalOverrides = {
    frame_width = 1;
    frame_color = "#${base03}";
    padding = 14;
    horizontal_padding = 14;
    separator_height = 2;
    separator_color = lib.mkForce "frame";
    origin = "top-right";
    offset = "24x48";
    gap_size = 8;
    corner_radius = 14;
  };
in
{
  services.dunst = {
    enable = true;
    waylandDisplay = lib.mkIf (config.wayland.windowManager.hyprland.enable or false) "wayland-1";
    settings = {
      global = globalOverrides;
      urgency_normal.frame_color = "#${base0D}";
      urgency_critical.frame_color = "#${base08}";
    };
  };
}
