{
  pkgs,
  lib,
  inputs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    hyprpicker
    hyprcursor
    inputs.pyprland.packages."x86_64-linux".pyprland
  ];

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland; # use the latest hyprland package from flake
  #xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
