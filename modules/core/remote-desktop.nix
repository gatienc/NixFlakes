{ pkgs, ... }:
{
  # Enable X11 and a desktop environment
  services.xserver = {
    enable = true;
    displayManager.defaultSession = "gnome";
    desktopManager.gnome.enable = true;
  };
  services.xrdp = {
    enable = true;
    package = pkgs.xrdp;
    defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    openFirewall = true;
  };
}
