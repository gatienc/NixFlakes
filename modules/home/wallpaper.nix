{ pkgs, ... }:
let
  wallpaperDir = ../../assets/wallpaper;
  changeWallpaperScript = pkgs.writeShellScriptBin "change-wallpaper" ''
    #!/usr/bin/env bash
    WALLPAPER=$(find ${wallpaperDir} -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" \) | shuf -n1)
    if [ -n "$WALLPAPER" ]; then
      swww img "$WALLPAPER" --transition-fps 60 --transition-duration 2 --transition-type any --transition-pos top-right --transition-bezier .3,0,0,.99 --transition-angle 135
    fi
  '';
in
{
  home.packages = [ changeWallpaperScript ];
}

