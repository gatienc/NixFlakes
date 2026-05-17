{ pkgs, ... }:
{
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openFirewall = false;
    settings = {
      rpc-bind-address = "127.0.0.1";
      rpc-port = 9091;
      rpc-whitelist = "127.0.0.1";
      download-dir = "/var/lib/transmission/downloads";
      incomplete-dir = "/var/lib/transmission/incomplete";
      watch-dir = "/var/lib/transmission/watch";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/transmission/downloads 0755 transmission transmission -"
    "d /var/lib/transmission/incomplete 0755 transmission transmission -"
    "d /var/lib/transmission/watch 0755 transmission transmission -"
  ];
}
