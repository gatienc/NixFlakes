{ pkgs, lib, config, username, ... }: {
  services.syncthing = {
    enable = true;
    user = username;
    dataDir = "/home/${username}/.config/syncthing";
    configDir = "/home/${username}/.config/syncthing";
    openDefaultPorts = true;
  };
}
