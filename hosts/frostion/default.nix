{
  inputs,
  pkgs,
  config,
  lib,
  modulesPath,
  username,
  ...
}:

{
  # Core configuration
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../../modules/core/common.nix
    ../../modules/core/hyprland.nix
    ../../modules/core/bluetooth.nix
    ../../modules/core/stylix.nix
    ../../modules/core/ssh.nix
    ../../modules/core/fonts.nix
    ../../modules/core/gnome.nix
    ../../modules/core/gaming.nix
    ../../modules/core/minecraft.nix
    ../../modules/core/lact.nix

    # ../../modules/core/virt-manager.nix
    # ../../modules/core/zen.nix

    ./hardware-configuration.nix
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username; };
    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      imports = [
        ../../modules/home/common.nix
        ../../modules/home/desktop.nix
        ../../modules/home/gaming.nix
        ../../modules/home/fastfetch.nix
        ../../modules/home/hyprland.nix
        ../../modules/home/waybar.nix
        ../../modules/home/wallpaper.nix
        ../../modules/home/syncthing.nix
        ../../modules/home/3d_modeling.nix
        ../../modules/home/latex.nix
        ../../modules/home/rofi.nix
      ];
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      6112 # warcraft 3
      25565 # Minecraft server
    ];
  };

  services.pulseaudio.enable = false; # Disable PulseAudio
  security.rtkit.enable = true; # For better real-time audio performance
  services.pipewire = {
    enable = true;
    # This section ensures all necessary parts are enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # Also make sure Bluetooth is enabled in your system:
    # services.blueman.enable = true; # Or use your preferred bluetooth manager
  };

}
