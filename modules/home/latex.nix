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
    texlive.combined.scheme-full # LaTeX distribution
  ];
}
