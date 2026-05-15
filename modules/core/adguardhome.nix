{
  pkgs,
  lib,
  config,
  ...
}:

{
  services.adguardhome = {
    enable = true;
    openFirewall = true;
  };

  services.resolved.enable = false;

  networking.networkmanager.dns = "none";
}
