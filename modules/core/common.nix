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
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
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
  boot.loader.timeout = 2; # Show boot menu for 2 seconds then auto-boot
  boot.loader.systemd-boot.editor = false; # Disable kernel param editing for security

  # User settings
  users.mutableUsers = true;

  services.fail2ban.enable = true;

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh xonsh ];
  environment.systemPackages = with pkgs; [
    micro
    gvfs
    libmtp
    nix-output-monitor # Pretty output for nix builds
  ];

  # Nix Helper for better rebuild UX
  programs.nh = {
    enable = true;
    flake = "/home/${username}/NixFlakes";
    # Optional: clean old generations automatically
    # clean.enable = true;
    # clean.extraArgs = "--keep-since 7d --keep 5";
  };
  environment.variables.EDITOR = "micro";
  environment.sessionVariables = {
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    REQUESTS_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
    CURL_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
  };

  # Locale
  time.timeZone = "Europe/Paris";
  console.keyMap = "fr";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
