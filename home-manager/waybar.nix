{ pkgs, lib, config, ... }:
 
{ 
 programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [ "eDP-1" "HDMI-A-1" ];
        margin = "20 20 0 20";

        battery = {
          format-plugged =
            "{capacity}% <span rise='250' size='large'> {icon}</span> <span rise='250' size='large'>  </span>";
          format = "{capacity}% <span rise='250' size='large'> {icon}</span>";
          format-icons = [ "" "" "" "" "" ];
          max-length = 25;
          interval = 1;
        };

        backlight = {
          # device = "intel_backlight",
          format = "{percent}% <span rise='250' size='large'> {icon}</span>";
          format-icons = "";
        };

        pulseaudio = {
          format-muted = "<span size='large'>󰸈</span>";
          format = "{volume}% <span size='large'> {icon}</span>";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" ];
          };
        };

        clock = {
          format = "{:%I:%M %p} <span rise='250' size='large'> </span>";
        };

        tray = { spacing = 10; };

        modules-right = [ "backlight" "pulseaudio" "battery" "tray" ];
        modules-center = [ "clock" ];
        modules-left = [ "hyprland/workspaces" ];

      };
    };
    style = ''
      /* colors */
      /* #5E81AC
      #81A1C1
      #88C0D0
      #8FBCBB */

      * {
      	border-radius: 0;
      	font-size: 12px;
      	min-height: 0;
      }

      window#waybar {
      	background: #4c566a;
      	color: #ECEFF4;
      	border-radius: 25;
      }

      .modules-left {
      	padding: 5 0 5 5;
      	border-bottom-right-radius: 20px;
      }

      .modules-right {
      	padding: 5 1 5 0;
      	border-bottom-left-radius: 20px;
      }

      #workspaces {
      	border: none;
      	background-color: rgba(0, 0, 0, 0);
      	border: solid 1px #8FBCBB;
      	padding: 0 10px;
      	padding-left: 0px;
      	padding-right: 5px;
      	border-radius: 19px;
      }

      #workspaces button {
      	font-size: 10px;
      	color: rgba(0, 0, 0, 0);
      	background-color: #ECEFF4;
      	padding: 0;
      	padding-left: 1px;
      	margin-left: 5px;
      	margin-top: 5px;
      	margin-bottom: 5px;
      	border-radius: 100%;
      }

      #workspaces button.active {
      	background: #8FBCBB;
      	padding-left: 15px;
      	border-radius: 30px;
      }

      #workspaces button:hover {
      	color: #ECEFF4;
      	background: #8FBCBB;
      	text-shadow: none;
      	border: solid 1px #8FBCBB;
      }

      #workspaces button.active:hover {
      	color: rgba(0, 0, 0, 0);
      }

      #network {
      	background: #8FBCBB;
      }

      #workspaces button.urgent {
      }

      #mode {
      	background: #64727d;
      	border-bottom: 3px solid #ECEFF4;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #network,
      #wireplumber,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor {
      	padding: 0 15px;
      	margin-right: 5px;
      	margin-left: 5px;
      	border-radius: 2rem;
      }

      #battery {
      	background: #88C0D0;
      	color: #ECEFF4;
      	padding-right: 25px;
      }

      #battery.plugged {
      	color: #ECEFF4;
      	background: #A3BE8C;
      }

      #backlight {
      	color: #ECEFF4;
      	background: #5E81AC;
      	padding-right: 20px;
      }

      #pulseaudio {
      	padding-right: 20px;
      	background: #81A1C1;
      }

      #pulseaudio.muted {
      	padding-right: 16px;
      	padding-left: 15px;
      	padding-top: 2px;
      	background: #BF616A;
      }

      #tray {
      	border: solid 1px #8FBCBB;
      	color: #ECEFF4;
      }
    '';
  };
}