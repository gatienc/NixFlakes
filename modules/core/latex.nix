{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    micro
    texlive.combined.scheme-full
  ];
}
