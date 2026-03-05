{
  inputs,
  pkgs,
  config,
  lib,
  modulesPath,
  username,
  ...
}:

{
  # Core configuration
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../../modules/core/common.nix
    ../../modules/core/bluetooth.nix
    ../../modules/core/stylix.nix
    ../../modules/core/ssh.nix
    ../../modules/core/fonts.nix
    ../../modules/core/gaming.nix
    ../../modules/core/remote-desktop.nix
    ../../modules/core/rocm.nix
    ../../modules/core/lact.nix
    ../../modules/core/minecraft.nix
    # ../../modules/core/hyprland.nix
    # ../../modules/core/gnome.nix

    ./hardware-configuration.nix
  ];

  virtualisation.docker.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      8000
      8384
    ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    # # extraSpecialArgs = { inherit inputs username host; };
    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      imports = [
        ../../modules/home/common.nix
        ../../modules/home/desktop.nix
        ../../modules/home/dunst.nix
        ../../modules/home/music.nix
        ../../modules/home/gaming.nix
        ../../modules/home/fastfetch.nix
        ../../modules/home/rofi.nix
        ../../modules/home/llm.nix
        # ../../modules/home/hyprland.nix
        # ../../modules/home/waybar.nix
        ../../modules/home/syncthing.nix
      ];

      systemd.user.services.obsidian-vault-auto-commit = {
        Unit = {
          Description = "Auto-commit Obsidian vault changes";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash /home/${username}/Documents/obsidian/.git-hooks/auto-commit.sh";
          StandardOutput = "append:/home/${username}/Documents/obsidian/.git-hooks/auto-commit.log";
          StandardError = "append:/home/${username}/Documents/obsidian/.git-hooks/auto-commit.log";
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };

      systemd.user.timers.obsidian-vault-auto-commit = {
        Unit = {
          Description = "Timer for auto-committing Obsidian vault";
        };
        Timer = {
          OnCalendar = "*:0/5";
          Persistent = true;
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
  };

}
