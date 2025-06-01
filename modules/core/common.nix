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

  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # User settings
  users.mutableUsers = false;

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    micro
  ];
  environment.variables.EDITOR = "micro";

  # Locale
  time.timeZone = "Europe/Paris";
  console.keyMap = "fr";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
