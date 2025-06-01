{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "gatien" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

}
