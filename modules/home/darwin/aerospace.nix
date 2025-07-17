{ ... }:
{
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

            [gaps]
            inner.horizontal = 1
            inner.vertical   = 1
            outer.left       = 1
            outer.bottom     = 1
            outer.top        = 1
            outer.right      = 1

            [mode.main.binding]
            ctrl-alt-shift-left = 'focus left'
            ctrl-alt-shift-down = 'focus down'
            ctrl-alt-shift-up = 'focus up'
            ctrl-alt-shift-right = 'focus right'

            # See: https://nikitabobko.github.io/AeroSpace/commands#resize
            ctrl-shift-minus = 'resize smart -50'
            ctrl-shift-equal = 'resize smart +50'

            # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
            ctrl-alt-shift-tab = 'workspace-back-and-forth'

            ctrl-shift-down = 'move down'
            ctrl-shift-up = 'move up'
            ctrl-shift-right = 'move right'
            ctrl-shift-left = 'move left'


            ctrl-t = 'exec-and-forget open -na kitty'
            ctrl-f = 'fullscreen'
            ctrl-d = 'layout h_accordion tiles' # 'layout tabbed' in i3
            ctrl-v = 'layout floating tiling'

            ctrl-1 = 'workspace 1'
            ctrl-2 = 'workspace 2'
            ctrl-3 = 'workspace 3'
            ctrl-4 = 'workspace 4'
            ctrl-5 = 'workspace 5'
            ctrl-6 = 'workspace 6'
            ctrl-7 = 'workspace 7'
            ctrl-8 = 'workspace 8'
            ctrl-9 = 'workspace 9'
            ctrl-0 = 'workspace 10'

            ctrl-shift-1= 'move-node-to-workspace 1'
            ctrl-shift-2 = 'move-node-to-workspace 2'
            ctrl-shift-3 = 'move-node-to-workspace 3'
            ctrl-shift-4 = 'move-node-to-workspace 4'
            ctrl-shift-5 = 'move-node-to-workspace 5'
            ctrl-shift-6 = 'move-node-to-workspace 6'
            ctrl-shift-7 = 'move-node-to-workspace 7'
            ctrl-shift-8 = 'move-node-to-workspace 8'
            ctrl-shift-9 = 'move-node-to-workspace 9'
            ctrl-shift-0 = 'move-node-to-workspace 10'  

            ctrl-shift-c = 'reload-config'

            ctrl-esc = 'close'



            [workspace-to-monitor-force-assignment]
            1 = 'main'
            2 = 'main'
            3 = 'main'
            4 = 'main'
            5 = ['built-in', 'secondary', 'main']
            6 = ['built-in', 'secondary', 'main']

            [[on-window-detected]]
            if.app-name-regex-substring = 'slack'
            run = 'move-node-to-workspace 5'

            [[on-window-detected]]
            if.app-name-regex-substring = 'obsidian'
            run = 'move-node-to-workspace 6'


      # See: https://nikitabobko.github.io/AeroSpace/commands#mode
      ctrl-alt-shift-cmd-semicolon = 'mode service'

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      [mode.service.binding]
      esc = ['reload-config', 'mode main']
      r = ['flatten-workspace-tree', 'mode main'] # reset layout
      #s = ['layout sticky tiling', 'mode main'] # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
      f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
      backspace = ['close-all-windows-but-current', 'mode main']

      ctrl-alt-shift-cmd-h = ['join-with left', 'mode main']
      ctrl-alt-shift-cmd-j = ['join-with down', 'mode main']
      ctrl-alt-shift-cmd-k = ['join-with up', 'mode main']
      ctrl-alt-shift-cmd-l = ['join-with right', 'mode main']
    '';
  };
}
