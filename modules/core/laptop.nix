{ pkgs, lib, inputs, ... }: {
  boot.kernelParams = [ "button.lid_init_state=open" ];
  programs.xss-lock = {
    enable = true;
    lockerCommand = "systemctl suspend";
  };
}
