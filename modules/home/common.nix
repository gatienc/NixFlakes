{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  # Common packages for all systems
  commonPackages = with pkgs; [
    # Terminal
    bat # replacement for cat
    bat-extras.batdiff # extra features for bat
    bat-extras.batman # extra features for bat
    eza # A modern replacement for ‘ls’
    fd # replacement for find
    ripgrep # replacement for grep
    fzf # A command-line fuzzy finder
    zellij # tmux alternative
    lazygit # git terminal
    lazydocker # docker terminal
    nmap # network exploration tool and security/port scanner
    arp-scan # network discovery tool

    tealdeer # tldr client
    wget # download files from the web
    ranger # terminal file manager
    glow # markdown previewer in terminal

    # archives
    zip
    unzip

    # Programming
    python3 # python3 with all the packages
    uv # package manager and installer
    poetry
    zlib

    gcc # C compiler
    gnumake # GNU make
    cargo # rust package manager
    nodejs # nodejs runtime
    jdk # java development kit

    gh # github cli
    gh-dash # github dashboard
    copier # project templating tool

    # Nix
    nixfmt-rfc-style # nix formatting tool
    direnv # environment variable manager
    # secrets
    age # age encryption tool
    ssh-to-age # ssh to age encryption tool
    sops # secrets management tool

    # System information
    ncdu # disk space navigator

    # System monitoring
    btop # replacement of htop/nmo
    dysk # disk usage analyzer
    iotop # io monitoring
    iftop # network monitoring

    # Display image
    timg
    gthumb
    w3m

    ffmpeg
    playerctl # control media players

    # fun
    cowsay
    cbonsai # bonsai tree generator
    fortune # random quotes
    figlet # text art generator
    cmatrix # terminal screensaver
    asciiquarium # aquarium in terminal
  ];

  # Linux-only packages
  linuxPackages = with pkgs; [
    unrar # unrar tool
    lshw # hardware information tool
    bluetuith # bluetooth manager
    clipse # clipboard manager
    gsimplecal # calendar
    # Desktop environment
    swww # wallpaper manager
    fuzzel # launcher
    rofi-wayland # application launcher
    dunst # notification manager
    libnotify # notification tool

    cava # audio visualizer
    iniparser # for cava

    alsa-utils # ALSA sound utilities

    # Office software
    libreoffice-qt # office suite
    hunspell # spell checker

    radeontop # GPU monitoring
    brightnessctl # control screen brightness
    pavucontrol # control audio devices
    pulsemixer # control audio devices
    pamixer # control audio volume
  ];

in
lib.mkMerge [
  # ===================================================================
  #
  #                            Common Config
  #
  # ===================================================================
  {
    home.packages = commonPackages;

    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        lfs.enable = true;
        userName = "Gatien Chenu";
        userEmail = "gatien+dev@chenu.me";
      };
      firefox.enable = true;

      fzf.enable = true; # enables zsh integration by default
      starship.enable = true;
      kitty = {
        enable = true;
        keybindings = {
          "ctrl+alt+f" =
            "launch --type=overlay --stdin-source=@screen_scrollback ${pkgs.fzf}/bin/fzf --no-sort --no-mouse --exact -i";
        };
      };
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
          cd = "z";
          nano = "micro";
          cat = "bat";
          icat = "kitty +kitten icat";
          grep = "rg";
          diff = "batdiff";
          man = "batman";
          ls = "eza --icons --group-directories-first";
          ll = "eza --icons -l --group-directories-first";
          tree = "eza --tree --icons";
          whatismyip = "curl https://ipinfo.io/ip";
          c = "clear";
          g = "lazygit";
          gc = ''git commit -m "$1"'';
        };

        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "node"
            "npm"
          ];
          theme = "af-magic";
        };
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "24.05";
  }

  # ===================================================================
  #
  #                            Linux Config
  #
  # ===================================================================
  (lib.mkIf pkgs.stdenv.isLinux {
    home.packages = linuxPackages;

    programs.zsh.shellAliases = {
      nixswitch = "sudo nixos-rebuild switch";
      logout = "hyprctl dispatch exit";
      clip = "wl-copy";
    };
  })

  # ===================================================================
  #
  #                            macOS Config
  #
  # ===================================================================
  (lib.mkIf pkgs.stdenv.isDarwin {
    # Add any macOS-specific packages here
    # home.packages = [ pkgs.mac-app-utils ];

    programs.zsh.shellAliases = {
      # Example of a macOS-specific alias
      # nixswitch = "darwin-rebuild switch --flake ~/NixFlakes";
      clip = "pbcopy";
    };
  })
]
