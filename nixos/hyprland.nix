{ pkgs, lib, inputs, ... }: {

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };

  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  security.pam.services.hyprlock = { }; # to enable hyprlock auth	

}
