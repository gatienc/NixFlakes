{ pkgs, lib, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 ];
  };
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;

    package = pkgs.minecraft-server;
    dataDir = "/var/lib/MinecraftServer";

    serverProperties = {
      gamemode = "survival";
      difficulty = "hard";
      simulation-distance = 10;
      level-seed = "4";
    };

    whitelist = {
      teyzen = "b3d86a49-f7bc-4bc8-80be-45163719d0af"

        };

      jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC";
    };

  }
