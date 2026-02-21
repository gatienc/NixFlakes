{
  pkgs,
  lib,
  config,
  ...
}:
let
  startupScript = pkgs.writeShellScriptBin "start" ''
    swww-daemon &
    sleep 1 &
    swww img $(find ${../../../assets/wallpaper} -type f | shuf -n1) &
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.pyprland}/bin/pypr &
    brightnessctl set 127
  '';
  sessionStart = pkgs.writeShellScriptBin "hyprland-session-start" ''
    exec ${startupScript}/bin/start
  '';
  readingModeToggle = pkgs.writeShellScriptBin "reading-mode-toggle" ''
    current_shader=$(hyprshade current)
    if [[ "$current_shader" == *"reading_mode"* ]]; then
      hyprshade off
      notify-send 'Reading Mode' 'Off' 2>/dev/null || true
    else
      reading-mode-apply
      notify-send 'Reading Mode' 'On' 2>/dev/null || true
    fi
  '';
  exchangeMonitors = pkgs.writeShellScriptBin "exchange-monitors" ''
    mon0_workspace=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[0].activeWorkspace.id')
    mon1_workspace=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[1].activeWorkspace.id')

    mon0_windows=($(hyprctl clients -j | ${pkgs.jq}/bin/jq -r ".[] | select(.monitor == 0 and .workspace.id == $mon0_workspace) | .address"))
    mon1_windows=($(hyprctl clients -j | ${pkgs.jq}/bin/jq -r ".[] | select(.monitor == 1 and .workspace.id == $mon1_workspace) | .address"))

    for addr in "''${mon0_windows[@]}"; do
      if [ -n "$addr" ]; then
        hyprctl dispatch focuswindow address:"$addr"
        hyprctl dispatch movewindow mon:1
      fi
    done

    for addr in "''${mon1_windows[@]}"; do
      if [ -n "$addr" ]; then
        hyprctl dispatch focuswindow address:"$addr"
        hyprctl dispatch movewindow mon:0
      fi
    done
  '';
in
{
  config = {
    hyprland.scripts = {
      inherit readingModeToggle sessionStart exchangeMonitors;
    };
    home.packages = [ exchangeMonitors ];
  };
}
