{ pkgs, lib, ... }:
let
  data_dir = "/var/lib/cobbleverse";
  # Path to the .env file containing sensitive keys
  # Create this file at /etc/nixos/secrets/cobbleverse.env
  env_file = "/etc/nixos/secrets/cobbleverse.env";
in
{
  # Enable Docker
  virtualisation.docker.enable = true;

  # Firewall configuration for Minecraft port
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 ];
  };

  # OCI container configuration for Cobbleverse server
  virtualisation.oci-containers.containers."mc-server" = {
    image = "itzg/minecraft-server:latest";

    ports = [ "25565:25565" ];

    # Environment variables from .env file (for sensitive data like API keys)
    # The .env file should be located at: /etc/nixos/secrets/cobbleverse.env
    # Format: KEY=value (one per line)
    environmentFiles = [ env_file ];

    environment = {
      # Accept EULA
      EULA = "TRUE";

      # Use AUTO_CURSEFORGE (recommended over CURSEFORGE)
      TYPE = "AUTO_CURSEFORGE";

      # CurseForge API Key is loaded from the .env file
      # Add CF_API_KEY=your_key_here to /etc/nixos/secrets/cobbleverse.env

      # CurseForge modpack page URL
      # Replace with the exact Cobbleverse modpack URL
      CF_PAGE_URL = "https://www.curseforge.com/minecraft/modpacks/cobbleverse-cobblemon";

      # Memory allocation (minimum 4GB recommended for modpacks)
      MEMORY = "6G";

      # Optional: Server name
      SERVER_NAME = "Cobbleverse Server";

      # Optional: Enable RCON (remote console)
      # ENABLE_RCON = "true";
      # RCON_PASSWORD = "your_password_here";
      # RCON_PORT = "25575";
    };

    volumes = [
      "${data_dir}:/data"
    ];

    # Auto-restart policy
    autoStart = true;

    # Optional: Resource limits
    # extraOptions = [
    #   "--memory=4g"
    #   "--cpus=2"
    # ];
  };

  # Create data directory if it doesn't exist
  systemd.tmpfiles.rules = [
    "d ${data_dir} 0755 root root -"
  ];
}
