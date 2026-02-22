{
  pkgs,
  lib,
  config,
  ...
}@args:

let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  turnoffMenu = pkgs.pkgs.writeShellScriptBin "start" ''
    choice=$(printf "Lock\nLogout\nHibernate\nRestart\nShutdown\n" | fuzzel --dmenu)
    case "$choice" in
      Lock)     hyprlock ;; # Replace with your lock command if needed
      Logout)  hyprctl dispatch exit ;; # Replace with your logout command if needed
      Hibernate) systemctl hibernate ;;
      Restart) systemctl reboot ;;
      Shutdown) systemctl poweroff ;;
    esac
  '';
  readingModeToggle = pkgs.pkgs.writeShellScriptBin "reading-mode-toggle" ''
    current_shader=$(hyprshade current)
    if [[ "$current_shader" == *"reading_mode"* ]]; then
      hyprshade off
      notify-send 'Reading Mode' 'Off' 2>/dev/null || true
    else
      reading-mode-apply
      notify-send 'Reading Mode' 'On' 2>/dev/null || true
    fi
  '';
  readingModeStatus = pkgs.pkgs.writeShellScriptBin "reading-mode-status" ''
    current_shader=$(hyprshade current)
    if [[ "$current_shader" == *"reading_mode"* ]]; then
      echo "󰃳"
    else
      echo "󰌵"
    fi
  '';
  blueLightFilterToggle = pkgs.pkgs.writeShellScriptBin "blue-light-filter-toggle" ''
    current_shader=$(hyprshade current)
    if [[ "$current_shader" == *"blue-light-filter"* ]]; then
      hyprshade off
      notify-send 'Blue Light Filter' 'Off' 2>/dev/null || true
    else
      blue-light-filter-apply
      notify-send 'Blue Light Filter' 'On (scroll on icon to adjust strength)' 2>/dev/null || true
    fi
  '';
  blueLightFilterStatus = pkgs.pkgs.writeShellScriptBin "blue-light-filter-status" ''
    current_shader=$(hyprshade current)
    strength_file="$HOME/.config/hypr/blue-light-strength"
    if [[ "$current_shader" == *"blue-light-filter"* ]]; then
      if [ -f "$strength_file" ]; then
        pct=$(awk '{ printf "%.0f", $1*100 }' "$strength_file")
        printf "\xef\x86\x86 %s%%\n" "$pct"
      else
        printf "\xef\x86\x86\n"
      fi
    else
      printf "\xef\x86\x85\n"
    fi
  '';
  layoutStatus = pkgs.pkgs.writeShellScriptBin "layout-status" ''
    layout=$(hyprctl getoption general:layout | awk '{print $2}' | tr -d '"')
    if [[ "$layout" == "dwindle" ]]; then
      echo "󰖲"
    else
      echo "󰘖"
    fi
  '';
  # Toggle portrait (90°) via full monitor rule; see https://wiki.hyprland.org/Configuring/Monitors/#rotating
  portraitToggle = pkgs.pkgs.writeShellScriptBin "portrait-toggle" ''
    json=$(hyprctl monitors -j)
    mon=$(echo "$json" | ${pkgs.jq}/bin/jq -r ".[0].name")
    width=$(echo "$json" | ${pkgs.jq}/bin/jq -r ".[0].width")
    height=$(echo "$json" | ${pkgs.jq}/bin/jq -r ".[0].height")
    refresh=$(echo "$json" | ${pkgs.jq}/bin/jq -r ".[0].refreshRate")
    x=$(echo "$json" | ${pkgs.jq}/bin/jq -r ".[0].x")
    y=$(echo "$json" | ${pkgs.jq}/bin/jq -r ".[0].y")
    scale=$(echo "$json" | ${pkgs.jq}/bin/jq -r ".[0].scale")
    transform=$(echo "$json" | ${pkgs.jq}/bin/jq -r ".[0].transform")
    # refreshRate can be in Hz or mHz (e.g. 60000)
    if [[ "$refresh" -gt 1000 ]]; then
      refresh=$(( refresh / 1000 ))
    fi
    if [[ "$transform" == "0" || "$transform" == "2" ]]; then
      # Switch to portrait: 90° (transform 1)
      rule="$mon, ''${width}x''${height}@''${refresh}, ''${x}x''${y}, ''${scale}, transform, 1"
      hyprctl keyword monitor "$rule"
      # Match pen/touch coordinates to rotated display (see wiki.hyprland.org Configuring/Monitors#rotating)
      hyprctl keyword input:touchdevice:transform 1 2>/dev/null || true
      hyprctl keyword input:tablet:transform 1 2>/dev/null || true
      notify-send 'Screen' 'Portrait (90°)' 2>/dev/null || true
    else
      # Switch to landscape: 0°
      rule="$mon, ''${width}x''${height}@''${refresh}, ''${x}x''${y}, ''${scale}, transform, 0"
      hyprctl keyword monitor "$rule"
      hyprctl keyword input:touchdevice:transform 0 2>/dev/null || true
      hyprctl keyword input:tablet:transform 0 2>/dev/null || true
      notify-send 'Screen' 'Landscape' 2>/dev/null || true
    fi
  '';
  portraitStatus = pkgs.pkgs.writeShellScriptBin "portrait-status" ''
    printf "\xef\x80\xa1\n"
  '';
in
{
  programs.waybar = {
    enable = true;
    style = with config.stylix.fonts; ''
      * {
        border-radius: 0;
        font-family: "${monospace.name}", "${sansSerif.name}", "${emoji.name}";
        font-weight: 800;
        font-size: 11px;
        transition: ${betterTransition};
        min-height: 0;
        color: #${config.lib.stylix.colors.base05};
      }
      #clock {
        color: #${config.lib.stylix.colors.base05};
      }
      #custom-launcher {
        font-size: 16px;
      }
      #custom-mail, #custom-dbx, #custom-layout, #custom-reading-mode, #custom-blue-light,
      #custom-wallpaper, #custom-portrait, #custom-poweroff, #custom-mpd,
      #network, #idle_inhibitor, #backlight, #pulseaudio, #battery, #disk, #cpu {
        font-size: 11px;
      }

      window#waybar {
        background: transparent;
        color: #${config.lib.stylix.colors.base05};
        padding: 0;
        margin: 0;
      }

      tooltip {
        background: #${config.lib.stylix.colors.base01};
        border-radius: 15px;
        border-width: 30px;
        border-style: solid;
        border-color: #${config.lib.stylix.colors.base01};
      }

      #workspaces {
      border-radius: 0px 0px 15px 15px;
      }

      #workspaces button {
        padding-left: 10px;
        padding-right: 10px;
        min-width: 0;
        color: #${config.lib.stylix.colors.base05};
        font-size: 18px;
      }

      #workspaces button.focused {
        color: #${config.lib.stylix.colors.base04};
      }

      #workspaces button.urgent {
        color: #${config.lib.stylix.colors.base05};
      }

      #workspaces button:hover {
        color: #${config.lib.stylix.colors.base05};
      }

      #tray, #custom-launcher, #network, #clock, #battery, #network, #custom-mail, #custom-dbx,
      #pulseaudio, #custom-mpd, #workspaces, #idle_inhibitor, #backlight, #disk, #cava, #custom-poweroff, #custom-gpu, #cpu, #custom-wallpaper, #custom-layout, #custom-reading-mode, #custom-blue-light, #custom-portrait, #custom-keyboard {
        padding: 6px 8px;
        background: #${config.lib.stylix.colors.base00};
      }

      #cava {
      border-radius: 0px 0px 15px 0px;
      }

      #network,
      #pulseaudio, #custom-mail, #custom-dbx, #custom-mpd, #custom-layout,
      #custom-wallpaper, #custom-reading-mode, #custom-blue-light, #custom-portrait, #custom-keyboard,
      #idle_inhibitor, #backlight {
        color: #${config.lib.stylix.colors.base05};
      }

      #tray {}
      #battery {
        color: #${config.lib.stylix.colors.base05};
      }

      #idle_inhibitor {
        border-radius: 0px 0px 0px 15px;
        margin-left: 10px;
      }

      #poweroff {
        color: #${config.lib.stylix.colors.base05};
        margin-right: 30px;
       }
    '';
    settings = {
      # Thanks to https://gist.github.com/genofire/07234e810fcd16f9077710d4303f9a9e
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "custom/launcher"
          "clock"
          "custom/mail"
          "custom/dbx"
          "custom/layout"
          "custom/reading-mode"
          "custom/blue-light"
          "custom/wallpaper"
        ] ++ lib.optionals ((args.host or "") == "icicle") [ "custom/portrait" "custom/keyboard" ] ++ [
          "cava"
        ];
        cava = {
          framerate = 30;
          autosens = true;
          bars = 12;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 20000;
          hide_on_silence = true;
          format_silent = "quiet";
          method = "pulse";
          stereo = false;
          reverse = false;
          bar_delimiter = 0;
          monstercat = false;
          waves = false;
          noise_reduction = 0.77;
          format-icons = [
            "▁"
            "▂"
            "▄"
            "▆"
            "█"
          ];
          actions = {
            on-click-right = "mode";
          };
        };
        clock = {
          "timezones" = [
            "Europe/Paris"
            "Europe/London"
          ];
          "timezone-alt" = "Europe/London";
          "format" = "{:%H:%M} 󰥔";
          "format-alt" = "{:%I:%M %p} 󰥔";
          "on-click-right" = "gsimplecal";
          "tooltip-format" = "{:%D %A, %B %d, %Y (%R)}";
          "actions" = {
            "on-click" = "tz_up";
          };
        };
        "custom/launcher" = {
          "format" = " ";
          "on-click" = "sh -c 'sleep 0.1 && hyprctl dispatch hyprexpo:expo toggle'";
        };
        modules-center = [
          "hyprland/workspaces"
        ];
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          all-outputs = true;
          sort-by-number = true;
          format-icons = {
            "focused" = "";
            # "default" = "";
            # "0" = "0";
            # "1" = "一";
            # "2" = "二";
            # "3" = "三";
            # "4" = "四";
            # "5" = "五";
            # "6" = "六";
            # "7" = "七";
            # "8" = "八";
            # "9" = "九";
            # "10" = "十";

          };
          window-rewrite = {
            "title<.*youtube.*>" = " ";
            "title<.*amazon.*>" = " ";
            "title<.*reddit.*>" = " ";
            "title<.*Picture-in-Picture.*>" = " ";
            "class<firefox>" = " ";
            "class<kitty>" = " ";
            "class<konsole>" = " ";
            "class<thunar>" = "󰝰 ";
            "class<discord>" = " ";
            "class<subl>" = "󰅳 ";
            "class<celluloid>" = " ";
            "class<Cider>" = "󰎆 ";
            "class<code-oss>" = "󰨞 ";
            "class<codeblocks>" = "󰅩 ";
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          "format-icons" = {
            "activated" = "󰅶"; # mdi:lock-open-outline
            "deactivated" = "󰌾"; # mdi:lock-outline
          };
        };
        modules-right = [
          "idle_inhibitor"
          "cpu"
          # "custom/gpu"
          "disk"
          "network"
          "tray"
          "backlight"
          "pulseaudio"
          "battery"
          "custom/mpd"
          "custom/poweroff"
        ];

        #output = [ "eDP-1" "HDMI-A-1" ];
        # margin = "5 10 0 10";

        battery = {
          states = {
            warning = 20;
            critical = 10;
          };
          format-charging = "󰢟 {capacity}% ";
          format-plugged = "󰢟 {capacity}% ";
          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          max-length = 25;
          interval = 1;
        };
        backlight = {
          # device = "intel_backlight",
          format = "{icon} {percent}%";
          format-icons = "";
        };

        disk = {
          format = "󰋊 {specific_free:.0f} GB";
          format-icons = "󰋊";
          interval = 60;
          unit = "GB";
        }
        // lib.optionalAttrs ((args.host or "") == "icicle") {
          path = "/nix";
        };
        cpu = {
          format = "{icon} {usage}%";
          format-icons = "";
          interval = 1;
          max-length = 25;
        };
        "custom/gpu" = {
          exec = "radeontop -d - -l 1 | cut -c 32-35";
          format = "{val}% {icon}";
          format-icons = [ "󰾲" ];
          return-type = "val";
          interval = 4;
        };
        pulseaudio = {
          format-muted = "󰸈";
          format = "{icon} {volume}%";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" ];
          };
          on-click-right = "blueman-manager";
          on-click = "pavucontrol";
        };

        tray = {
          spacing = 10;
        };

        network = {
          format-wifi = "{icon}";
          format-ethernet = "";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "";
          format-alt = " {bandwidthUpOctets}  {bandwidthDownOctets}";
          tooltip-format = "{ipaddr}";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            ""
          ];
          on-click-right = "kitty nmtui";
        };

        "custom/layout" = {
          exec = "${layoutStatus}/bin/layout-status";
          format = "{}";
          tooltip = "Current tiling layout";
          interval = 1;
        };

        "custom/wallpaper" = {
          format = "";
          tooltip = "Change Wallpaper";
          on-click = "change-wallpaper";
        };

        "custom/reading-mode" = {
          exec = "${readingModeStatus}/bin/reading-mode-status";
          format = "{}";
          tooltip = "Reading Mode (Toggle). Right-click for Paper blue & invert.";
          on-click = "${readingModeToggle}/bin/reading-mode-toggle";
          on-click-right = "reading-mode-adjust";
          interval = 2;
        };
        "custom/blue-light" = {
          exec = "${blueLightFilterStatus}/bin/blue-light-filter-status";
          format = "{}";
          tooltip = "Blue Light Filter (Toggle). Right-click for Temperature, Strength, Luminance.";
          on-click = "${blueLightFilterToggle}/bin/blue-light-filter-toggle";
          on-click-right = "blue-light-filter-slider";
          interval = 2;
        };
        "custom/poweroff" = {
          format = "󰐥";
          tooltip = "Power Menu";
          on-click = "${turnoffMenu}/bin/start";
        };
      } // lib.optionalAttrs ((args.host or "") == "icicle") {
        "custom/portrait" = {
          exec = "${portraitStatus}/bin/portrait-status";
          format = "{}";
          tooltip = "Toggle portrait / landscape";
          on-click = "${portraitToggle}/bin/portrait-toggle";
          interval = 2;
        };
        "custom/keyboard" = {
          format = "󰌌";
          tooltip = "Toggle on-screen keyboard (wvkbd)";
          # -x: match executable name only (avoid matching the shell running this command)
          # SIGRTMIN toggles visibility; start if not running
          on-click = "pkill -SIGRTMIN -x wvkbd-mobintl 2>/dev/null || wvkbd-mobintl &";
        };
      };
    };
  };
}
