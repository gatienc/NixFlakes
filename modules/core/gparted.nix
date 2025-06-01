{ config, pkgs, ... }:
{
  security.polkit.enable = true; # Enable polkit for gparted
  environment.systemPackages = with pkgs; [
    gparted
  ];
}
