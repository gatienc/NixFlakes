{ inputs, pkgs, lib, config, ... }: {

    programs.hyprland = {
        enable = true;
        #package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };

	programs.nm-applet = {
		enable = true;
		indicator=true;
	};
	
  environment.systemPackages = with pkgs; [
        waybar
        dunst
        libnotify
        swww
        kitty
        rofi-wayland
    ];  
    #xdg.portal.enable = true;
    #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
