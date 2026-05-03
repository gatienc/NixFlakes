{ pkgs, username, ... }:
{
  #according to https://wiki.nixos.org/wiki/AMD_GPU
  environment.systemPackages = with pkgs; [ lact ];
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  # Add user to video and render groups for GPU control access
  users.users.${username}.extraGroups = [ "video" "render" ];

  # udev rules for AMDGPU power control
  services.udev.extraRules = ''
    # Allow video and render group to access GPU sysfs for power control
    KERNEL=="card*", SUBSYSTEM=="drm", GROUP="video", MODE="0660"
    KERNEL=="renderD*", SUBSYSTEM=="drm", GROUP="render", MODE="0660"

    # AMDGPU hwmon permissions for power limit control
    SUBSYSTEM=="hwmon", ATTRS{name}=="amdgpu", GROUP="video", MODE="0660"
  '';

  # Ensure kernel modules are loaded for GPU monitoring/control
  boot.kernelModules = [ "amdgpu" ];
}
