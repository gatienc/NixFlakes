{ inputs, pkgs, config, lib, modulesPath, username, ... }:

{
  # Core configuration
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../../modules/core/common.nix
    ../../modules/core/hyprland.nix
    ../../modules/core/bluetooth.nix
    ../../modules/core/stylix.nix
    ../../modules/core/zen.nix
    ../../modules/core/ssh.nix
    ../../modules/core/fonts.nix


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
        ../../modules/home/fastfetch.nix
        ../../modules/home/hyprland.nix
        ../../modules/home/waybar.nix
      ];
    };
  };

}
