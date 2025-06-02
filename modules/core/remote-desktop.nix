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

  displayManager.auto.enable = true;
  displayManager.auto.user = "gatien";
  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

}
