{pkgs, lib, inputs, ...}: {

	programs.hyprland.enable = true;
	programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

	environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

	security.pam.services.hyprlock = {}; # to enable hyprlock auth
	
}