{ ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts."external" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 81;
        }
      ];

      locations = {
        "/" = {
          return = "302 /miniflux/";
        };

        "/miniflux" = {
          extraConfig = ''
            return 302 $scheme://$host/miniflux/;
          '';
        };

        "/miniflux/" = {
          proxyPass = "http://127.0.0.1:8080/miniflux/";
          extraConfig = ''
            proxy_set_header X-Forwarded-Prefix /miniflux;
          '';
        };
      };
    };

    virtualHosts."lan" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];
      default = true;

      locations = {
        "/jellyfin" = {
          extraConfig = ''
            return 302 $scheme://$host/jellyfin/;
          '';
        };

        "/jellyfin/" = {
          proxyPass = "http://127.0.0.1:8096/";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_buffering off;
          '';
        };

        "/transmission/" = {
          proxyPass = "http://127.0.0.1:9091";
          extraConfig = ''
            proxy_set_header X-Forwarded-Host $http_host;
          '';
        };
      };
    };

    virtualHosts."ha" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 8120;
        }
      ];

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8123/";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };

    virtualHosts."immich" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 2280;
        }
      ];

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:2283/";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            client_max_body_size 50000M;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
          '';
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    81
    8120
    2280
  ];
}
