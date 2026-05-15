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
  # Overlay to disable tests for packages that fail in build
  nixpkgs.overlays = [
    (final: prev: {
      # Disable tests for gtksourceview5 (timeout on test-language-specs)
      gtksourceview5 = prev.gtksourceview5.overrideAttrs (old: {
        doCheck = false;
      });
      # Disable tests for openldap (syncreplication test failure)
      openldap = prev.openldap.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];

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
    ../../modules/core/rocm.nix
    ../../modules/core/appimage.nix
    ../../modules/core/python.nix
    # ../../modules/core/minecraft.nix
    ../../modules/core/lact.nix
    ../../modules/core/ebook-reader.nix
    #../../modules/core/home-assistant.nix
    ../../modules/core/printing.nix
    ../../modules/core/laptop.nix
    ../../modules/core/syncthing.nix
    # ../../modules/core/affinity.nix
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

      stylix.targets.firefox.enable = false;
      stylix.targets.qt.platform = "qtct";

      imports = [
        ../../modules/home/common.nix
        ../../modules/home/zellij.nix
        ../../modules/home/desktop.nix
        ../../modules/home/dunst.nix
        #../../modules/home/music.nix
        ../../modules/home/gaming.nix
        ../../modules/home/fastfetch.nix
        ../../modules/home/hyprland
        ../../modules/home/waybar.nix
        ../../modules/home/wallpaper.nix
        ../../modules/home/syncthing.nix
        ../../modules/home/3d_modeling.nix
        #../../modules/home/latex.nix
        ../../modules/home/rofi.nix
        ../../modules/home/llm.nix
        ../../modules/home/jailed-agents.nix
        ../../modules/home/neovim.nix
        ../../modules/home/typst.nix
        ../../modules/home/tts.nix
      ];
    };
  };

  services.open-webui = {
    enable = false;
    port = 8085;
  };

  services.ollama = {
    enable = false;
    # Optional: set environment variables or extra args
    # environmentVariables = {
    #   OLLAMA_HOST = "0.0.0.0:11434";
    # };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      6112 # warcraft 3
      # 25565 # Minecraft server
      #8085 # open-webui
    ];
  };

  # Local DNS entry for open-webui.me
  #networking.hosts."127.0.0.1" = [ "open-webui.me" ];

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
