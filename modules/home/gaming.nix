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
    (prismlauncher.override {
      jdks = [
        pkgs.jdk8
        pkgs.jdk17
      ];
    })
    atlauncher
    tlauncher
    # for modded mc
  ];
}
