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
    swww # wallpaper manager
    fuzzel # launcher
    rofi # application launcher
    dunst # notification manager
    libnotify # notification tool

    # GUI software
    obsidian
    bitwarden-desktop
    vscode
    code-cursor
    nautilus # GUI file manager
    font-manager # GUI font manager
    remmina # remote desktop client
    # moonlight-qt

    zotero # reference manager
    filezilla # ftp client
    vlc # video player
    smile # emoji picker
    ### Discord
    discord
    vesktop

    teams-for-linux # teams client

    # Office software
    libreoffice-qt # office suite
    hunspell # spell checker

  ];

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.morewaita-icon-theme;
      name = "MoreWaita";
    };
  };
}
