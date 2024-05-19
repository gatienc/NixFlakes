{ inputs, pkgs, lib, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
    ./hyprland.nix
  ];

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  nixpkgs.config.allowUnfree = true;
  networking.hostName = "blitzar";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Paris";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.mutableUsers = false;

  users.users = {
    gatien = {
      initialPassword = "123";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    micro
  ];
  
  environment.variables.EDITOR ="micro";

  # services.xserver = {
  #   enable = true;
  #   desktopManager.gnome.enable = true;
  #   displayManager.gdm.enable = true;
  #   xkb.layout = "fr";
  # };
  console.keyMap = "fr";


  fonts.packages = with pkgs; [
    fira-mono
    hack-font
    inconsolata
    iosevka
    (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      }) # fonts name can get in ``https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/data/fonts/nerdfonts/shas.nix`
      twemoji-color-font
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
