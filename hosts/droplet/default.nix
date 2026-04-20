{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  username,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../modules/core/common.nix
    ../../modules/core/network.nix
    ../../modules/core/ssh.nix
    ../../modules/core/user.nix
    ../../modules/core/gaming.nix

    ./hardware-configuration.nix
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      imports = [
        ../../modules/home/common.nix
      ];
    };
  };
}
