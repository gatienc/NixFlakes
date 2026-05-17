{
  pkgs,
  lib,
  config,
  ...
}:

{
  services.jellyfin = {
    enable = true;
    openFirewall = false;
  };

  networking.firewall.allowedTCPPorts = [
    7359 # Jellyfin discovery (SSDP)
  ];

  systemd.services.jellyfin = {
    serviceConfig = {
      StateDirectory = "jellyfin";
      CacheDirectory = "jellyfin";
    };
  };
}
