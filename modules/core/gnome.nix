{ inputs, pkgs, lib, config, ... }: {

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
