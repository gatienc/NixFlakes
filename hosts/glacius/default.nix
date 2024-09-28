{ config, lib, pkgs, modulesPath, ... }:

{
  # Core configuration
  imports = [
    ../../modules/core/common.nix
    ../../modules/core/persist.nix
    ../../modules/core/hyprland.nix
    ../../modules/core/bluetooth.nix
    ../../modules/core/stylix.nix
    ../../modules/core/zen.nix
    ../../modules/core/ssh.nix
    ../../modules/core/minecraft.nix
    ../../modules/core/network.nix
    ../../modules/core/fonts.nix

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
