{ pkgs, lib, ... }:
let
  data_dir = "/var/lib/MinecraftServer";
in
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      25565
      25575
    ];
  };
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;

    package = pkgs.minecraft-server;
    dataDir = data_dir;

    serverProperties = {
      gamemode = "survival";
      difficulty = "hard";
      simulation-distance = 10;
      level-seed = "4";
      online-mode = false;
      enable-rcon = true;
      "rcon.port" = 25575;
      "rcon.password" = "minecraft";
    };

    whitelist = {
      teyzen = "b3d86a49-f7bc-4bc8-80be-45163719d0af";
    };

    jvmOpts = "-Xms4096M -Xmx4096M -XX:+UseG1GC";
  };

  systemd.services.minecraft-server-op = {
    wantedBy = [ "minecraft-server.service" ];
    after = [ "minecraft-server.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.mcrcon}/bin/mcrcon -H 127.0.0.1 -P 25575 -p minecraft op teyzen";
    };
  };
}
