{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./fastfetch.nix
  ];

  home = {
    username = "gatien";
    homeDirectory = "/home/gatien";
  };

  programs.kitty = {
    enable = true;
    keybindings =
      {
        "ctrl+f" = "launch --type=overlay --stdin-source=@screen_scrollback ${pkgs.fzf}/bin/fzf --no-sort --no-mouse --exact -i";
      };
  };

  home.packages = with pkgs; [
    # Terminal
    bat # replacement for cat
    eza # A modern replacement for ‘ls’
    fd # replacement for find
    fzf # A command-line fuzzy finder
    zellij # tmux alternative
    glow # markdown previewer in terminal
    nnn # terminal file manager
    ranger # terminal file manager

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

    # Gaming software
    lutris
    heroic
    bottles

    grim # screenshot tool
    slurp # select region for screenshot
    # Programming
    python3Full # python3 with all the packages
    age # age encryption tool
    ssh-to-age # ssh to age encryption tool
    nixpkgs-fmt # nix formatting tool
    direnv # environment variable manager

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
    alacritty.enable = true;
    fzf.enable = true; # enables zsh integration by default
    starship.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        nixswitch = "sudo nixos-rebuild switch";
        nixconfig = "$EDITOR /etc/nixos/";
        cd = "z";
        ls = "eza --icons --group-directories-first";
        ll = "eza --icons -l --group-directories-first";
        tree = "eza --tree --icons";
        cat = "bat";
        clip = "wl-copy";
        whatismyip = "curl https://ipinfo.io/ip";
        logout = "hyprctl dispatch exit";
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
