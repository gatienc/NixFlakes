{ pkgs, username, ... }:

{
  users.users.${username} = {
    home = "/Users/${username}";
  };
  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
    download-buffer-size = 1048576
  '';
  system.primaryUser = username;
  security.pam.services.sudo_local.touchIdAuth = true;
  system = {
    defaults = {
      ".GlobalPreferences"."com.apple.mouse.scaling" = 4.0;
      spaces.spans-displays = false;
      universalaccess = {
        # FIXME: cannot write universal access
        #reduceMotion = true;
        #reduceTransparency = true;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        orientation = "bottom";
        dashboard-in-overlay = true;
        largesize = 85;
        tilesize = 50;
        magnification = true;
        launchanim = false;
        mru-spaces = false;
        show-recents = false;
        show-process-indicators = false;
        static-only = true;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf"; # current folder
        QuitMenuItem = true;
      };

      NSGlobalDomain = {
        _HIHideMenuBar = false;
        AppleFontSmoothing = 0;
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        AppleScrollerPagingBehavior = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        InitialKeyRepeat = 10;
        KeyRepeat = 2;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowResizeTime = 0.0;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.trackpad.scaling" = 2.0;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    micro
  ];
  environment.variables = {
    EDITOR = "micro";
    VISUAL = "micro";
    GIT_EDITOR = "micro";
  };

  homebrew = {
    enable = true;
    taps = [
      "nikitabobko/tap" # aerospace
      "FelixKratz/formulae" # sketchybar
    ];
    brews = [
      "sketchybar"
      "borders"
    ];
    casks = [
      "obsidian"
      "qgis"
      "syncthing"
      "bitwarden"
      "visual-studio-code"
      "cursor"
      "android-studio"
      "docker-desktop"
      "google-chrome" # used for debugging
      #"borders" # FIXME don't work for the moment
      "nikitabobko/tap/aerospace" # tiling window manager
      "font-0xproto-nerd-font"
      "font-3270-nerd-font"
      "font-agave-nerd-font"
      "font-arimo-nerd-font"
      "font-aurulent-sans-mono-nerd-font"
      "font-bigblue-terminal-nerd-font"
      "font-bitstream-vera-sans-mono-nerd-font"
      "font-blex-mono-nerd-font"
      "font-caskaydia-cove-nerd-font"
      "font-code-new-roman-nerd-font"
      "font-cousine-nerd-font"
      "font-daddy-time-mono-nerd-font"
      "font-dejavu-sans-mono-nerd-font"
      "font-droid-sans-mono-nerd-font"
      "font-fantasque-sans-mono-nerd-font"
      "font-fira-code-nerd-font"
      "font-fira-mono-nerd-font"
      "font-go-mono-nerd-font"
      "font-gohufont-nerd-font"
      "font-hack-nerd-font"
      "font-hasklug-nerd-font"
      "font-heavy-data-nerd-font"
      "font-hurmit-nerd-font"
      "font-im-writing-nerd-font"
      "font-inconsolata-go-nerd-font"
      "font-inconsolata-lgc-nerd-font"
      "font-inconsolata-nerd-font"
      "font-iosevka-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-lekton-nerd-font"
      "font-liberation-nerd-font"
      "font-meslo-lg-nerd-font"
      "font-monoid-nerd-font"
      "font-monofur-nerd-font"
      "font-mononoki-nerd-font"
      "font-mplus-nerd-font"
      "font-noto-nerd-font"
      "font-open-dyslexic-nerd-font"
      "font-overpass-nerd-font"
      "font-profont-nerd-font"
      "font-proggy-clean-tt-nerd-font"
      "font-roboto-mono-nerd-font"
      "font-sauce-code-pro-nerd-font"
      "font-shure-tech-mono-nerd-font"
      "font-space-mono-nerd-font"
      "font-symbols-only-nerd-font"
      "font-terminess-ttf-nerd-font"
      "font-tinos-nerd-font"
      "font-ubuntu-mono-nerd-font"
      "font-ubuntu-nerd-font"
      "font-victor-mono-nerd-font"
    ];
  };
  system.stateVersion = 5;
  environment.shells = [ pkgs.zsh ];

}
