{ inputs, pkgs, lib, config, ... }: {
  home.packages = with pkgs; [ syncthing syncthingtray ];

  systemd.user.services.syncthing = {
    Unit = {
      Description = "Autosuspend Powerplay mousepad led";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = lib.getExe pkgs.syncthing;
      Restart = "on-failure";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
