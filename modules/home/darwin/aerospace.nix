{ pkgs, ... }:
let
  exchangeMonitors = pkgs.writeShellScriptBin "exchange-monitors" ''
    # Exchange only windows from the current workspace on each monitor
    # Get the first two monitors
    monitors=$(aerospace list-monitors 2>/dev/null | head -2)
    if [ -z "$monitors" ]; then
      # Fallback: use common monitor names
      mon1="main"
      mon2="secondary"
    else
      mon1=$(echo "$monitors" | head -1)
      mon2=$(echo "$monitors" | tail -1)
    fi

    # Get the current/focused workspace on each monitor (first workspace is typically focused)
    ws1=$(aerospace list-workspaces --monitor "$mon1" 2>/dev/null | head -1 | grep -v "^$" || true)
    ws2=$(aerospace list-workspaces --monitor "$mon2" 2>/dev/null | head -1 | grep -v "^$" || true)

    # Get all windows from the current workspace on each monitor
    mon1_windows=$(aerospace list-windows --workspace "$ws1" --monitor "$mon1" 2>/dev/null | grep -v "^$" || true)
    mon2_windows=$(aerospace list-windows --workspace "$ws2" --monitor "$mon2" 2>/dev/null | grep -v "^$" || true)

    # Move windows from monitor 1's current workspace to monitor 2
    echo "$mon1_windows" | while read -r window_id; do
      [ -n "$window_id" ] && aerospace move-node-to-monitor "$window_id" "$mon2" 2>/dev/null || true
    done

    # Move windows from monitor 2's current workspace to monitor 1
    echo "$mon2_windows" | while read -r window_id; do
      [ -n "$window_id" ] && aerospace move-node-to-monitor "$window_id" "$mon1" 2>/dev/null || true
    done
  '';
in
{
  home.packages = [ exchangeMonitors ];
  home.file.aerospace = {
    target = ".aerospace.toml";
    text = ''
      after-startup-command = [
      'exec-and-forget borders active_color=rgba(143, 171, 255, 1) inactive_color=rgba(52, 51, 56, 1) width=5.0'
      ]

      # Start AeroSpace at login
      start-at-login = true

      # enable-normalization-flatten-containers = false
      # enable-normalization-opposite-orientation-for-nested-containers = false
      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

      # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
      # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
      # Also see: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
      automatically-unhide-macos-hidden-apps = false


      accordion-padding = 100

      [gaps]
      inner.horizontal = 1
      inner.vertical   = 1
      outer.left       = 1
      outer.bottom     = 1
      outer.top        = 1
      outer.right      = 1

      [mode.main.binding]

      # All possible keys:
      # - Letters.        a, b, c, ..., z
      # - Numbers.        0, 1, 2, ..., 9
      # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
      # - F-keys.         f1, f2, ..., f20
      # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon,
      #                   backtick, leftSquareBracket, rightSquareBracket, space, enter, esc,
      #                   backspace, tab, pageUp, pageDown, home, end, forwardDelete,
      #                   sectionSign (ISO keyboards only, european keyboards only)
      # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
      #                   keypadMinus, keypadMultiply, keypadPlus
      # - Arrows.         left, down, up, right

      # All possible modifiers: cmd, alt, ctrl, shift

      # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

      # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
      # You can uncomment the following lines to open up terminal with alt + enter shortcut
      # (like in i3)
      # alt-enter = '''exec-and-forget osascript -e '
      # tell application "Terminal"
      #     do script
      #     activate
      # end tell'
      # '''

      # See: https://nikitabobko.github.io/AeroSpace/commands#layout
      ctrl-shift-d = 'layout tiles horizontal vertical'
      ctrl-alt-d = 'layout accordion horizontal vertical'

      # See: https://nikitabobko.github.io/AeroSpace/commands#focus
      alt-h = 'focus left'
      alt-j = 'focus down'
      alt-k = 'focus up'
      alt-l = 'focus right'

      # See: https://nikitabobko.github.io/AeroSpace/commands#move
      alt-shift-h = 'move left'
      alt-shift-j = 'move down'
      alt-shift-k = 'move up'
      alt-shift-l = 'move right'




      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
      ctrl-1 = 'workspace 1'
      ctrl-2 = 'workspace 2'
      ctrl-3 = 'workspace 3'
      ctrl-4 = 'workspace 4'
      ctrl-5 = 'workspace 5'
      ctrl-6 = 'workspace 6'
      ctrl-7 = 'workspace 7'
      ctrl-8 = 'workspace 8'
      ctrl-9 = 'workspace 9'

      # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
      ctrl-shift-1 = 'move-node-to-workspace 1'
      ctrl-shift-2 = 'move-node-to-workspace 2'
      ctrl-shift-3 = 'move-node-to-workspace 3'
      ctrl-shift-4 = 'move-node-to-workspace 4'
      ctrl-shift-5 = 'move-node-to-workspace 5'
      ctrl-shift-6 = 'move-node-to-workspace 6'
      ctrl-shift-7 = 'move-node-to-workspace 7'
      ctrl-shift-8 = 'move-node-to-workspace 8'
      ctrl-shift-9 = 'move-node-to-workspace 9'

      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
      alt-tab = 'workspace-back-and-forth'
      # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
      alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'
      # Exchange all windows between monitor 1 and monitor 2
      cmd-tab = 'exec-and-forget exchange-monitors'

      # Change wallpaper
      alt-shift-enter = 'exec-and-forget change-wallpaper'

      # See: https://nikitabobko.github.io/AeroSpace/commands#mode
      ctrl-f1 = 'mode service'

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      [mode.service.binding]
      esc = ['reload-config', 'mode main']
      r = ['flatten-workspace-tree', 'mode main'] # reset layout
      f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
      backspace = ['close-all-windows-but-current', 'mode main']

      # See: https://nikitabobko.github.io/AeroSpace/commands#resize
      keypadMinus = 'resize smart -50'
      keypadPlus = 'resize smart +50'

      # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
      #s = ['layout sticky tiling', 'mode main']

      alt-shift-h = ['join-with left', 'mode main']
      alt-shift-j = ['join-with down', 'mode main']
      alt-shift-k = ['join-with up', 'mode main']
      alt-shift-l = ['join-with right', 'mode main']

      down = 'volume down'
      up = 'volume up'
      shift-down = ['volume set 0', 'mode main']

      [workspace-to-monitor-force-assignment]
      1 = 'main'
      2 = 'main'
      3 = 'main'
      4 = 'main'
      5 = 'main'
      6 = ['built-in', 'secondary', 'main']
      7 = ['built-in', 'secondary', 'main']
      8 = ['built-in', 'secondary', 'main']
      9 = ['built-in', 'secondary', 'main']
    '';
  };
}
