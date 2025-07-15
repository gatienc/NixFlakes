{ config, pkgs, username, ... }:

{
  # Home-manager configuration for mac
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      git
      wget
      curl
      unzip
    ];
  };
}
