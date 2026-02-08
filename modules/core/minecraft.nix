{ pkgs, lib, ... }:
let
  data_dir = "/var/lib/MinecraftServer";
in
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 ];
  };
  services.minecraft-server = {
    enable = false;
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
    };

    whitelist = {
      teyzen = "b3d86a49-f7bc-4bc8-80be-45163719d0af";
    };

    jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC";
  };
}
