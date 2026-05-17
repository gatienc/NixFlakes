{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    ./bluetooth.nix
  ];

  services.home-assistant = {
    enable = true;
    configDir = "/var/lib/home-assistant";

    extraComponents = [
      "matter"
      "bluetooth"
      "bluetooth_le_tracker"
      "network"
    ];

    customComponents = with pkgs.home-assistant-custom-components; [
      #will add library here
    ];

    extraPackages =
      py: with py; [
        numpy
        pyturbojpeg
        gtts
      ];

    config = {
      homeassistant = {
        name = "Home";
        latitude = 48.8566;
        longitude = 2.3522;
        elevation = 50;
        unit_system = "metric";
        temperature_unit = "C";
        time_zone = "Europe/Paris";
        currency = "EUR";

        customize_glob = {
          "light.*" = {
            icon = "mdi:lamps";
          };
        };
      };

      http = {
        server_port = 8123;
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };

      auth_providers = [
        {
          type = "trusted_networks";
          trusted_networks = [
            "127.0.0.1"
            "::1"
          ];
        }
        {
          type = "homeassistant";
        }
      ];

      lovelace = {
        resource_mode = "storage";
      };

      logger = {
        default = "info";
        logs = {
          "homeassistant.core" = "warning";
          "homeassistant.components" = "info";
        };
      };

      hue = {
        autodetect = false;
      };
    };

    openFirewall = false;
  };

  systemd.services.matter-server = {
    description = "Matter Server for Home Assistant";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "home-assistant";
      Group = "home-assistant";
      ExecStart = "${pkgs.python-matter-server}/bin/matter-server --storage-path /var/lib/matter-server";
      Restart = "on-failure";
      RestartSec = "5s";
      StateDirectory = "matter-server";
    };

    environment = {
      MATTER_SERVER_HEX_CODE = "";
    };
  };

  users.users.home-assistant = {
    isSystemUser = true;
    group = "home-assistant";
    extraGroups = [ "bluetooth" ];
  };

  users.groups.home-assistant = { };

  environment.systemPackages = with pkgs; [
    libjpeg
  ];

  networking.firewall.allowedTCPPorts = [
    5580 # Matter Server
  ];
}
