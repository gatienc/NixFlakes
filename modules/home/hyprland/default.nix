{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./scripts.nix
    ./blue-light.nix
    ./files.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./wayland.nix
  ];

  options.hyprland.scripts = lib.mkOption {
    type = lib.types.attrsOf lib.types.package;
    default = { };
    internal = true;
    description = "Hyprland script derivations (readingModeToggle, sessionStart, exchangeMonitors).";
  };
}
