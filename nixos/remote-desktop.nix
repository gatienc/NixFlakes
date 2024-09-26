{ pkgs, ... }:
{
  #services.xserver = {
  #  enable = true;
  #  displayManager.gdm.enable = true;
  #  desktopManager.gnome.enable = true;
  #};
  #environment.systemPackages = gnome.gnome-session;

  services.xrdp.enable = true;
  #services.xrdp.defaultWindowManager = "gnome-session";
  services.xrdp.openFirewall = true;


  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3389 ];
  };
}
