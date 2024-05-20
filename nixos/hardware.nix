{ inputs, pkgs, lib, config, ... }: {

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings = {
        General = {
            Experimental = true;
        };
  };
  services.blueman.enable = true;
}