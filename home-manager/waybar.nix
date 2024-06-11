{ pkgs, lib, config, ... }:
 
{ 
 programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = ["custom/launcher" "clock" ];
        modules-center = [  "hyprland/workspaces" ];
        modules-right = [ "idle_inhibitor" "backlight" "pulseaudio" "network" "battery" "tray" ];


        height = 10; # noting to be auto
        output = [ "eDP-1" "HDMI-A-1" ];
        margin = "5 10 0 10";

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
          timezone = "Europe/Paris";
          format = "{:%H:%M}";
          #locale = "fr";
          "format-alt" = "{:%A %B %e | %H:%M }";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        tray = { spacing = 10; };
        "custom/launcher" = {
            "format" = "";
            
            "on-click" = "fuzzel";
          };
		

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          all-outputs = true;
          sort-by-number = true;
          format-icons = {
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
              "title<.*youtube.*>"= " ";
              "title<.*amazon.*>"= " ";
              "title<.*reddit.*>"= " ";
              "title<.*Picture-in-Picture.*>"= " ";
              "class<firefox>"= " ";
              "class<kitty>"= " ";
              "class<konsole>"= " ";
              "class<thunar>"= "󰝰 ";
              "class<discord>"= " ";
              "class<subl>"= "󰅳 ";
              "class<celluloid>"= " ";
              "class<Cider>"= "󰎆 ";
              "class<code-oss>"= "󰨞 ";
              "class<codeblocks>"= "󰅩 ";
            };
        };
      idle_inhibitor = {
        format = "{icon}";
        "format-icons" = {
            "activated" = "";
            "deactivated" = "";
        };
      network = {
        format-wifi = "{icon}";
        format-ethernet = "󰈀  Ethernet";
        tooltip = false;
        format-linked = "󰤭  {ifname}";
        format-disconnected = "󰤭   Disconnected";
        format-alt = "{icon} {signalStrength}%	| {essid}";
        format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
	      on-click-right = "kitty nmtui";
        };
      };
      };
    };
    style = ''
      /* colors */
      /* #5E81AC
      #81A1C1
      #88C0D0
      #8FBCBB */

      * {
        font-family: "JetBrainsMono Nerd Font";
      	border-radius: 0;
      	font-size: 12px;
        font-weight: 900;
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
      	background-color: rgba(0, 0, 0, 0);
        border: none;
      }

      #workspaces button {
        color :  #ECEFF4;
        border-radius: 19px;
      }

      #workspaces button.active {
        color: #8FBCBB;
        background: #ECEFF4 ,
      }

      #workspaces button:hover {
      	color:  #ECEFF4 ;
        background:#8FBCBB,
      }

      #workspaces button.active:hover {
        color:  #ECEFF4 ;
        background:#8FBCBB,
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

      #custom {
        font-size : 20;
      }
    '';
  };
}