{ pkgs, ... }:
let
  wallpaperDir = ../../../assets/wallpaper;
  changeWallpaperScript = pkgs.writeShellScriptBin "change-wallpaper" ''
    #!/usr/bin/env bash
    WALLPAPER=$(find ${wallpaperDir} -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" \) | shuf -n1)
    if [ -n "$WALLPAPER" ]; then
      osascript -e "tell application \"System Events\" to tell every desktop to set picture to POSIX file \"$WALLPAPER\""
    fi
  '';
in
{
  home.packages = [ changeWallpaperScript ];
}
