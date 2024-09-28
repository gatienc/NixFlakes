{ inputs, nixpkgs, self, username, host, config, lib, pkgs, modulesPath, ... }:

{

  # Core configuration
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../../modules/core/common.nix
    ../../modules/core/persist.nix
    ../../modules/core/hyprland.nix
    ../../modules/core/bluetooth.nix
    ../../modules/core/stylix.nix
    ../../modules/core/zen.nix
    ../../modules/core/laptop.nix
    ../../modules/core/fonts.nix
    ../../modules/core/network.nix

    ./hardware-configuration.nix
  ];
  # Home Configuration
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username host; };
    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      imports = [
        ../../modules/home/common.nix
        ../../modules/home/fastfetch.nix
        ../../modules/home/hyprland.nix
        ../../modules/home/waybar.nix
      ];
    };
  };


}
