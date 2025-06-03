{
  pkgs,
  lib,
  config,
  ...
}:

let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in
{
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border-radius: 0;
        font-family: "AtkynsonMono Nerd Font", "Atkinson Hyperlegible", "Font Awesome 6 Free";
        font-weight: 900;
        font-size: 10pt;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: #DADAE8;
      }

      tooltip {
        background: #BAC2DE;
        border-radius: 15px;
        border-width: 30px;
        border-style: solid;
        border-color: #BAC2DE;
      }



      #workspaces button {
        padding-left: 10px;
        padding-right: 10px;
        min-width: 0;
        color: #f2cdcd;
      }

      #workspaces button.focused {
        color: #96cdfb;
      }

      #workspaces button.urgent {
        color: #89dceb;
      }

      #workspaces button:hover {
        color: #96cdfb;
      }

      #tray, #custom-launcher, #network, #clock, #battery, #custom-wifi, #custom-mail, #custom-dbx,
      #pulseaudio, #custom-mpd, #workspaces, #idle_inhibitor, #backlight {
        padding: 5px 5px;
        background: #24273A;
        margin-top: 9px;
        margin-bottom: 3px;
      }

      #custom-launcher {
        font-size: 12pt;
        border-radius: 15px 0px 0px 15px;
      }

      #custom-wifi {
        color: #F38BA8;
      }

      #pulseaudio { color: #abe9b3; }
      #custom-mail { color: #94E2D5; }
      #custom-dbx { color: #C6A0F6; }
      #custom-mpd { color: #96cdfb; }
      #idle_inhibitor { color:#7a887a; }
      #backlight { color: #fcf885; }

      #tray {}
      #battery {
        color: #f8bd96;
      }

      #idle_inhibitor {
        color: #70d6ff;
      }

      #clock {
        color: #96cdfb;
        border-radius: 0px 15px 15px 0px;
        padding-right: 9px;
      }
    '';
    settings = {
      # Thanks to https://gist.github.com/genofire/07234e810fcd16f9077710d4303f9a9e
      mainBar = {
        layer = "top";
        position = "bottom";
        modules-center = [
          "custom/launcher"
          "hyprland/workspaces"
          "custom/mpd"
          "custom/mail"
          "custom/dbx"
          "idle_inhibitor"
          "tray"
          "network"
          "backlight"
          "pulseaudio"
          "battery"
          "clock"
        ];

        #output = [ "eDP-1" "HDMI-A-1" ];
        # margin = "5 10 0 10";

        battery = {
          states = {
            warning = 20;
            critical = 10;
          };
          format-charging = " {capacity}%";
          format-plugged = "⚡ {capacity}% ";
          format = "{icon}  {capacity}% ";
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

        pulseaudio = {
          format-muted = "󰸈";
          format = "{icon}  {volume}%";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" ];
          };
          "on-click" = "pavucontrol";

        };

        clock = {
          "timezones" = [
            "Europe/London"
            "Europe/Paris"
          ];
          "timezone-alt" = "Europe/Paris";
          "format" = "🇬🇧 {:%H:%M}";
          "format-alt" = "🇫🇷 {:%H:%M}";
          "on-click-right" = "gsimplecal";
          "tooltip-format" = "{:%A, %B %d, %Y (%R)}";
          "actions" = {
            "on-click" = "tz_up";
          };
        };

        tray = {
          spacing = 10;
        };
        "custom/launcher" = {
          "format" = " ";
          "on-click" = "fuzzel";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          all-outputs = true;
          sort-by-number = true;
          format-icons = {
            "default" = "";
            "focused" = "";
            "0" = "0";
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";

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
            "activated" = "🔓";
            "deactivated" = "🔒";
          };
          network = {
            format-wifi = "{icon}";
            format = "{icon}";
            format-ethernet = "󰈀  Ethernet";
            tooltip = false;
            format-linked = "󰤭  {ifname}";
            format-disconnected = "󰤭   Disconnected";
            format-alt = "{icon} {signalStrength}%";
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            on-click-right = "kitty nmtui";
          };
        };
      };
    };
  };
}
