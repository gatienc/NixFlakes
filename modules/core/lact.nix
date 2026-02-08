{ pkgs, ... }:
{
  #according to https://wiki.nixos.org/wiki/AMD_GPU
  environment.systemPackages = with pkgs; [ lact ];
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
}
