{ pkgs, lib, config, ... }:
  let
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww-daemon &
    hypridle &
    ${pkgs.swww}/bin/swww img ${../assets/wallpaper/Kanagawa.png} &
    '';

	in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        #monitor =;
        path = "/etc/nixos/nixflakes/assets/wallpaper/Kanagawa.png";
        blur_passes = 1;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };
      input-field = {
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2 ;# Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.5)";
        font_color = "rgb(200, 200, 200)";
        fade_on_empty = false;
        font_family = "JetBrains Mono Nerd Font Mono";
        placeholder_text = "<i><span foreground='##cdd6f4'>Input Password...</span></i>";
        hide_input = false;
        position = "0, -120";
        halign = "center";
        valign = "center";
    };
    label = [{
        text = "$TIME";
        #color = $foreground
        color = "rgba(255, 255, 255, 0.6)";
        font_size = "120";
        font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
        position = "0, -300";
        halign = "center";
        valign = "top";
    } 
    {
        text = " Hi there, $USER";
        #"color = "$foreground"";
        color = "rgba(255, 255, 255, 0.6)";
        font_size = 25;
        font_family = "JetBrains Mono Nerd Font Mono";
        position = "0, -40";
        halign = "center";
        valign = "center";
    }];

    };
  };

  #hypridle
  #home.file.".config/hypr/hypridle.conf" = {
  #  text = (builtins.readFile /etc/nixos/nixflakes/.config/hypr/hypridle.conf);
  #};

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
    	input = {
    		kb_layout = "fr";
        follow_mouse = 1;
    		touchpad = {
    			natural_scroll = true;
          };
    	};
      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 5;
        gaps_out = [ 5 5 5 5 ];
        border_size = 2;
        "col.active_border" = "rgb(5E81AC)";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = "yes";

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        pseudotile = "yes";
        # you probably want this
        preserve_split = "yes";
      };


      gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = true ;
      };


      "$mainMod" = "SUPER";#windows key as modifier
      "$terminal" = "alacritty";
      "$browser" = "firefox";

      bind = 
      [
      	"$mainMod, T, exec, $terminal"
      	"$mainMod, B, exec, $browser"
        "$mainMod, F, fullscreen "
        "$mainMod, escape, killactive"
	      "$mainMod, V, togglefloating,"
      	"$mainMod, M, exit," #quit Hyprland

        '', Print, exec, grim -g "$(slurp -d)" - | wl-copy''


      	"$mainMod, ampersand, workspace, 1"
      	"$mainMod, eacute, workspace, 2"
      	"$mainMod, quotedbl, workspace, 3"
      	"$mainMod, apostrophe, workspace, 4"
      	"$mainMod, parenleft, workspace, 5"
      	"$mainMod, egrave, workspace, 6"
      	"$mainMod, minus, workspace, 7"
      	"$mainMod, underscore, workspace, 8"
      	"$mainMod, ccedilla, workspace, 9"
      	"$mainMod, agrave, workspace, 10"

        "SUPER_SHIFT, ampersand, movetoworkspace, 1"
        "SUPER_SHIFT, eacute, movetoworkspace, 2"
        "SUPER_SHIFT, quotedbl, movetoworkspace, 3"
        "SUPER_SHIFT, apostrophe, movetoworkspace, 4"
        "SUPER_SHIFT, parenleft, movetoworkspace, 5"
        "SUPER_SHIFT, egrave, movetoworkspace, 6"
        "SUPER_SHIFT, minus, movetoworkspace, 7"
        "SUPER_SHIFT, underscore, movetoworkspace, 8"
        "SUPER_SHIFT, ccedilla, movetoworkspace, 9"
        "SUPER_SHIFT, agrave, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # 
        "$mainMod SHIFT, right, movetoworkspace, +1"
        "$mainMod SHIFT, left, movetoworkspace, -1"

        "$mainMod, Left, movefocus, l"
        "$mainMod, Right, movefocus, r"
        "$mainMod, Up, movefocus, u"
        "$mainMod, Down, movefocus, d"

        "$mainMod SHIFT, Left, movewindow, l"
        "$mainMod SHIFT, Right, movewindow, r"
        "$mainMod SHIFT, Up, movewindow, u"
        "$mainMod SHIFT, Down, movewindow, d"

        "$mainMod CTRL, Left, resizeactive, 50 0"
        "$mainMod CTRL, Right, resizeactive, -50 0"
        "$mainMod CTRL, Up, resizeactive, 0 -50"
        "$mainMod CTRL, Down, resizeactive, 0 50"
      	
        "ALT,TAB,workspace,next"
        "$mainMod, space, exec, fuzzel"

        " , mouse:274, exec, ;" #disable middle click paste
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      
      
      # Todo change the func
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctlp s 5%-"
      ];

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        disable_hyprland_logo = true;
        enable_swallow = true;
      };

      exec-once = ''${startupScript}/bin/start'';
      
    };
  };
}
