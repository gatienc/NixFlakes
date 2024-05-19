# home.nix

{ pkgs, lib, config, ... }:

  let
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swww}/bin/swww init &
  
      sleep 1
  
      #${pkgs.swww}/bin/swww img ${./wallpaper.png} &
    '';
	in
	{
  	wayland.windowManager.hyprland = {
    enable = true;

    settings = {
    	input ={
    		kb_layout = fr
    		touchpad {
    			natural_scroll = true}
    	}
      "$mainMod" = "SUPER";#windows key as modifier
      "$terminal" = "kitty";
      "$brower" = "firefox";
      bind = 
      [
      	"$mainMod, T, exec, $terminal"
      	"$mainMod, B, exec, $browser"
		    "$mainMod, F ,fullscreen "
		    "$mainMod, V, togglefloating,"
      	"$mainMod, M, exit," #quit Hyprland

      	"$mainMod, ampersand, workspace, 1"
      	"$mainMod, eacute, workspace, 2"
      	"$mainMod, quotedbl, workspace, 3"
      	"$mainMod, apostrophe, workspace, 4"
      	"$mainMod, parenleft, workspace, 5"
      	"$mainMod, egrave, workspace, 6"
      	"$mainMod, minus, workspace, 7"
      	"$mainMod, underscore, workspace, 8"
      	"$mainMod, ccedilla, workspace, 9"
      	"$mainMod, agrave, workspace, 10"

        "SUPER_SHIFT, ampersand, movetoworkspace, 1"
        SUPER_SHIFT, eacute, movetoworkspace, 2"
        "SUPER_SHIFT, quotedbl, movetoworkspace, 3"
        "SUPER_SHIFT, apostrophe, movetoworkspace, 4"
        "SUPER_SHIFT, parenleft, movetoworkspace, 5"
        "SUPER_SHIFT, egrave, movetoworkspace, 6"
        "SUPER_SHIFT, minus, movetoworkspace, 7"
        "SUPER_SHIFT, underscore, movetoworkspace, 8"
        "SUPER_SHIFT, ccedilla, movetoworkspace, 9"
        "SUPER_SHIFT, agrave, movetoworkspace, 10"
      	"ALT,TAB,workspace,previous"

        "$mainMod, space, exec, rofi -show drun -show-icons"
      ]
      exec-once = ''${startupScript}/bin/start'';
      
    };
  };




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


	# media playing 
	playerctl
	
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
