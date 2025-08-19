{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.n8n
  ];
}
