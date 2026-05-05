{ pkgs, ... }:
{
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    expat
  ];
}
