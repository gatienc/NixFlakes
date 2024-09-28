{ inputs, nixpkgs, self, username, host, config, lib, pkgs, modulesPath, ... }:

{

  # Core configuration
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.stylix.nixosModules.stylix
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
  inputs.home-manager.nixosModules.home-manager.users.${username}.imports = [
    ../../modules/home/common.nix
    ../../modules/home/fastfetch.nix
    ../../modules/home/hyprland.nix
    ../../modules/home/waybar.nix
  ];

}
