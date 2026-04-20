{
  inputs,
  pkgs,
  lib,
  config,
  username,
  host,
  ...
}:
{
  #services.freshrss.enable = true;
  #services.freshrss.authType = "none";
  #services.freshrss.baseUrl = "https://fresh.org";

  imports = [
    # inputs.sops-nix.nixosModules.sops
    # ./secrets.nix
    ./user.nix
    ./network.nix
  ];

  environment.localBinInPath = true; # add local bin to path
  services.gvfs.enable = true; # for Nautilus
  programs.nix-ld.enable = true; # to run non-nix executables
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes"; # Enable Flakes
    auto-optimise-store = true;
  };

  #QOL: enabling numlock on boot
  boot.initrd.systemd.services.numlock = {
    description = "Enable numlock";
    before = [ "initrd-switch-root.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kbd}/bin/setleds +num";
    };
  };

  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # User settings
  users.mutableUsers = false;

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    micro
    gvfs
    libmtp
  ];
  environment.variables.EDITOR = "micro";

  # Locale
  time.timeZone = "Europe/Paris";
  console.keyMap = "fr";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
