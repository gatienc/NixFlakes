{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
