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
    freecad
  ];
}
