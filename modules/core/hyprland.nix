{ pkgs, lib, inputs, ... }: {

  environment.systemPackages = with pkgs; [
    hyprpicker
    hyprcursor
    # pyprland #TODO: add pyprland
  ];

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };

  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  security.pam.services.hyprlock = { }; # to enable hyprlock auth

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
