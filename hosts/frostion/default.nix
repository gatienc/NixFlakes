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
    ../../modules/core/hyprland.nix
    ../../modules/core/bluetooth.nix
    ../../modules/core/stylix.nix
    ../../modules/core/ssh.nix
    ../../modules/core/fonts.nix
    ../../modules/core/gnome.nix
    ../../modules/core/gaming.nix
    ../../modules/core/rustdesk.nix
    # ../../modules/core/virt-manager.nix
    # ../../modules/core/zen.nix

    ./hardware-configuration.nix
  ];

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
        ../../modules/home/hyprland.nix
        ../../modules/home/waybar.nix
        ../../modules/home/syncthing.nix
        ../../modules/home/3d_modeling.nix
        ../../modules/home/latex.nix
        ../../modules/home/qgis.nix
      ];
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      6112
    ]; # trying to allow warcraft 3 to work
  };

}
