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
    pyprland
    hyprshade
  ];

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  # Enable gnome-keyring for secret storage and SSH agent
  services.gnome.gnome-keyring.enable = true;
  # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland; # use the latest hyprland package from flake
  #xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };

  #environment.sessionVariables = {
  #  NIXOS_OZONE_WL = "1";
  #};

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  # Enable gnome-keyring PAM integration for auto-unlock on login
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Enable polkit for authentication dialogs (required for keyring)
  security.polkit.enable = true;

  # Ensure keyring daemon starts with graphical sessions
  services.dbus.packages = [ pkgs.gcr ];
}
