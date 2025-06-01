{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:
{

  home.packages = with pkgs; [
    # Terminal
    bat # replacement for cat
    eza # A modern replacement for ‘ls’
    fd # replacement for find
    ripgrep # replacement for grep
    fzf # A command-line fuzzy finder
    zellij # tmux alternative
    lazygit # git terminal
    lazydocker # docker terminal
    bluetuith # bluetooth manager
    clipse # clipboard manager
    nmap # network exploration tool and security/port scanner
    arp-scan # network discovery tool

    # tlock # 2fa tui
    # calcure # calendar tui
    gsimplecal # calendar
    tealdeer # tldr client
    wget # download files from the web
    ranger # terminal file manager
    glow # markdown previewer in terminal

    # archives
    zip
    unzip
    unrar

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

    # Desktop environment
    swww # wallpaper manager
    fuzzel # launcher
    rofi-wayland # application launcher
    dunst # notification manager
    libnotify # notification tool

    # Office software
    libreoffice-qt # office suite
    hunspell # spell checker

    # Nix
    nixfmt-rfc-style # nix formatting tool
    direnv # environment variable manager
    # secrets
    age # age encryption tool
    ssh-to-age # ssh to age encryption tool
    sops # secrets management tool

    # System information
    lshw # hardware information tool
    ncdu # disk space navigator

    # System monitoring
    btop # replacement of htop/nmo
    dysk # disk usage analyzer
    iotop # io monitoring
    iftop # network monitoring

    # Display image TODO: select one
    timg
    gthumb
    w3m

    # media playing
    playerctl # control media players
    brightnessctl # control screen brightness
    pavucontrol # control audio devices
    pulsemixer # control audio devices
    pamixer # control audio volume

    # fun
    cowsay
    cbonsai # bonsai tree generator
    fortune # random quotes
    figlet # text art generator
    cmatrix # terminal screensaver
    asciiquarium # aquarium in terminal

  ];

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      userName = "\n    Gatien\n    Chenu ";
      userEmail = "\n    gatien + dev@chenu.me";
    };
    firefox.enable = true;

    fzf.enable = true; # enables zsh integration by default
    starship.enable = true;
    kitty = {
      enable = true;
      keybindings = {
        "ctrl+f" =
          "launch --type=overlay --stdin-source=@screen_scrollback ${pkgs.fzf}/bin/fzf --no-sort --no-mouse --exact -i";
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        nixswitch = "sudo nixos-rebuild switch";
        cd = "z";
        nano = "micro";
        cat = "bat";
        icat = "kitty +kitten icat";

        ls = "eza --icons --group-directories-first";
        ll = "eza --icons -l --group-directories-first";
        tree = "eza --tree --icons";
        clip = "wl-copy";
        whatismyip = "curl https://ipinfo.io/ip";
        logout = "hyprctl dispatch exit";
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

  # Nicely reload system units when changing configs
  #systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
