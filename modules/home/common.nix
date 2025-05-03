{ inputs, pkgs, lib, config, username, ... }:
{


  home.packages = with pkgs; [
    # Terminal
    bat # replacement for cat
    eza # A modern replacement for ‘ls’
    fd # replacement for find
    fzf # A command-line fuzzy finder
    zellij # tmux alternative
    lazygit # git terminal
    glow # markdown previewer in terminal
    nnn # terminal file manager
    ranger # terminal file manager
    gh # github cli
    gh-dash # github dashboard

    gsimplecal # calendar

    # Desktop environment
    swww # wallpaper manager
    fuzzel # launcher
    dunst # notification manager
    libnotify # notification tool

    # GUI software
    obsidian
    bitwarden
    vscode
    discord
    nautilus # GUI file manager
    font-manager # GUI font manager
    remmina # remote desktop client
    zotero # reference manager

    # Gaming software
    lutris
    heroic
    bottles

    ## Minecraft
    prismlauncher

    # Office software
    libreoffice-qt
    hunspell


    grim # screenshot tool
    slurp # select region for screenshot
    # Programming
    python3 # python3 with all the packages
    uv # package manager and installer
    poetry
    zlib

    nodejs

    moonlight-qt
    texlive.combined.scheme-full


    age # age encryption tool
    ssh-to-age # ssh to age encryption tool
    sops # secrets management tool
    nixpkgs-fmt # nix formatting tool
    direnv # environment variable manager
    copier # project templating tool

    # System monitoring
    btop # replacement of htop/nmo
    iotop # io monitoring
    iftop # network monitoring
    ## archives
    zip
    unzip

    ani-cli
    spicetify-cli
    spotify # spotify client
    spotifyd # spotify daemon
    ## Clipboard
    wl-clipboard
    wf-recorder

    # Display image TODO: select one
    gthumb
    w3m
    ueberzug
    # media playing 
    playerctl # control media players
    brightnessctl # control screen brightness
    pamixer # control audio volume
    # Other
    cowsay
    xclip
    ripgrep
  ];



  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Gatien Chenu";
      userEmail = "gatien+dev@chenu.me";
    };
    firefox.enable = true;
    fzf.enable = true; # enables zsh integration by default
    starship.enable = true;
    kitty = {
      enable = true;
      keybindings =
        {
          "ctrl+f" = "launch --type=overlay --stdin-source=@screen_scrollback ${pkgs.fzf}/bin/fzf --no-sort --no-mouse --exact -i";
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
        gc = "git commit -m \"$1\"";

      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "node" "npm" ];
        theme = "af-magic";
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.morewaita-icon-theme;
      name = "MoreWaita";
    };
  };

  # Nicely reload system units when changing configs
  #systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
