{ inputs, pkgs, lib, config, ... }:
	{
    imports = [
    ./hyprland.nix
  ];

  home = {
    username = "gatien";
    homeDirectory = "/home/gatien";
  };

  home.packages = with pkgs; [ 
    obsidian
    bitwarden
  	vscode
  	discord
  	fastfetch
	  age
	  ssh-to-age
    
    grim
    slurp

	  hyprlock
    hypridle
    waybar
    swww
    fuzzel
    dunst
    libnotify


    # media playing 
    #playerctl

    #brightnessctl
    #pamixer
	
    glow # markdown previewer in terminal
    btop  # replacement of htop/nmo
    iotop # io monitoring
    iftop # network monitoring

    ani-cli
  	spicetify-cli
    spotify

    # Terminal
    tree 
    nnn # terminal file manager
    bat # replacement for cat
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    wl-clipboard
    
    # archives
    zip
    unzip



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
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    helix = {
      enable = true;
      settings = { theme = "nord"; };
      themes = {
        nord = {
          inherits = "nord";
          "ui.background" = "none";
        };
      };
    };

  };

  # Nicely reload system units when changing configs
  #systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
