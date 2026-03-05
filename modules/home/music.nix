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
    yt-dlp
    chromaprint
    picard
    # musicat not yetstable
    tauon
  ];
}
