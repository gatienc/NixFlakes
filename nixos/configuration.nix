{ inputs, pkgs, lib, config, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };
  services.gvfs.enable = true; # for Nautilus

  programs.nix-ld.enable = true; # to run non-nix executables



  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Paris";


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
    base16-schemes
    adwaita-icon-theme # for icons in nautilus
    morewaita-icon-theme
    whatsapp-emoji-font

    #pyprland
    hyprpicker
    hyprcursor

  ];



  environment.variables.EDITOR = "micro";

  #services.xserver = {
  #  enable = true;
  #  desktopManager.gnome.enable = true;
  #  displayManager.gdm.enable = true;
  #  xkb.layout = "fr";
  #};
  console.keyMap = "fr";
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    fira-mono
    hack-font
    noto-fonts
    inconsolata
    iosevka
    twemoji-color-font
    openmoji-color
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    }) # fonts name can get in ``https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/data/fonts/nerdfonts/shas.nix`

  ];
  fonts.fontconfig = {
    defaultFonts = {
      emoji = [ "apple-color-emoji" "WhatsApp Emoji" "Noto Color Emoji" "Twemoji" "OpenMoji" ];
    };
  };
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
