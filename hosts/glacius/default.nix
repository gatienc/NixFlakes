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
    # ../../modules/core/hyprland.nix
    ../../modules/core/bluetooth.nix
    ../../modules/core/stylix.nix
    ../../modules/core/ssh.nix
    ../../modules/core/fonts.nix
    # ../../modules/core/gnome.nix
    ../../modules/core/gaming.nix
    ../../modules/core/remote-desktop.nix
    ../../modules/core/rustdesk.nix
    ../../modules/core/n8n.nix

    ./hardware-configuration.nix
  ];
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
        ../../modules/home/gaming.nix
        ../../modules/home/fastfetch.nix
        # ../../modules/home/hyprland.nix
        # ../../modules/home/waybar.nix
        ../../modules/home/syncthing.nix
      ];
    };
  };

}
