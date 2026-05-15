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
    grim # screenshot tool
    slurp # select region for screenshot
    loupe # image viewer

    ## Clipboard
    wl-clipboard
    wf-recorder

    xclip # clipboard manager for X11

    # Desktop environment
    awww # wallpaper manager
    fuzzel # launcher
    rofi # application launcher
    dunst # notification manager
    libnotify # notification tool

    # GUI software
    obsidian
    bitwarden-desktop
    vscodium-fhs
    zed-editor
    nautilus # GUI file manager
    font-manager # GUI font manager
    remmina # remote desktop client
    nextcloud-client # cloud sync client
    # moonlight-qt

    zotero # reference manager
    filezilla # ftp client
    vlc # video player
    smile # emoji picker
    ### Discord
    vesktop

    slack
    chromium # for web app mode

    # Office software
    onlyoffice-desktopeditors # office suite (lightweight alt)
    hunspell # spell checker

    # Audio effects
    easyeffects

  ];

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.morewaita-icon-theme;
      name = "MoreWaita";
    };
    gtk4.theme = null;
  };

  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
      };
    };
  };
}
