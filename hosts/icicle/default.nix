{
  inputs,
  nixpkgs,
  self,
  username,
  host,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];

  # Core configuration
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../modules/core/common.nix
    ../../modules/core/persist.nix
    ../../modules/core/hyprland.nix
    ../../modules/core/bluetooth.nix
    ../../modules/core/stylix.nix
    ../../modules/core/ssh.nix
    ../../modules/core/fonts.nix
    ../../modules/core/printing.nix
    ../../modules/core/laptop.nix
    ../../modules/core/syncthing.nix

    ./hardware-configuration.nix
  ];

  # Home Configuration
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit
        inputs
        username
        host
        ;
    };
    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      imports = [
        ../../modules/home/common.nix
        ../../modules/home/zellij.nix
        ../../modules/home/desktop.nix
        ../../modules/home/dunst.nix
        ../../modules/home/bottles.nix
        ../../modules/home/fastfetch.nix
        ../../modules/home/hyprland
        ../../modules/home/touchscreen.nix
        ../../modules/home/waybar.nix
        ../../modules/home/wallpaper.nix
        ../../modules/home/syncthing.nix
        ../../modules/home/llm.nix
        ../../modules/home/jailed-agents.nix

      ];
    };
  };

}
