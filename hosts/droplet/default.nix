{ config, lib, pkgs, modulesPath, ... }:

{

  imports = [
    ../../modules/core/common.nix
    ../../modules/core/network.nix
    ../../modules/core/ssh.nix
    ../../modules/core/user.nix


    ./hardware-configuration.nix
  ];
}
