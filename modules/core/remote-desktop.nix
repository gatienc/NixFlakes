{ pkgs, ... }: {

  services.xrdp = {
    enable = true;
    package = pkgs.xrdp;
    defaultWindowManager = "${pkgs.mate.gnome-session}/bin/gnome-session";
    openFirewall = true;
  };
}
