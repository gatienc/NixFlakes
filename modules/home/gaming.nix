{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:
{

  home.packages = with pkgs; [
    # Gaming software
    lutris
    heroic
    bottles
    ## Minecraft
    prismlauncher

  ];
}
