{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.rustdesk
  ];
}
