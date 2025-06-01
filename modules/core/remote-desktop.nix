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
    defaultWindowManager = "${pkgs.gnome-remote-desktop}/bin/gnome-remote-desktop";
    openFirewall = true;
  };
}
