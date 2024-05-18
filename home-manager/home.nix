{ pkgs, ... }: {
  home = {
    username = "gatien";
    homeDirectory = "/home/gatien";
  };

  home.packages = with pkgs; [ 
    firefox
    obsidian
    bitwarden
  	vscode
  	discord
  	fastfetch
	age
	ssh-to-age
    #age-keygen


    glow # markdown previewer in terminal
    btop  # replacement of htop/nmo
    iotop # io monitoring
    iftop # network monitoring

    ani-cli
  	spicetify-cli

    # Terminal
    tree 
    nnn # terminal file manager
    
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    
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

    alacritty.enable = true;
    fzf.enable = true; # enables zsh integration by default
    starship.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
