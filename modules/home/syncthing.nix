{ inputs, pkgs, lib, config, username, ... }: {
  home.packages = with pkgs; [ syncthing syncthingtray ];

  systemd.user.services.syncthing = {
    description = "Syncthing service for ${username}";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = username;
      Group = "syncthing";
      ExecStart = "${pkgs.syncthing}/bin/syncthing -no-browser -no-restart";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

}
