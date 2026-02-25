{
  pkgs,
  lib,
  ...
}:
{
  config.programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        path = lib.mkForce "${../../../assets/wallpaper/calm_cloud.png}";
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
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = lib.mkForce "rgba(0, 0, 0, 0)";
        inner_color = lib.mkForce "rgba(0, 0, 0, 0.5)";
        font_color = lib.mkForce "rgb(200, 200, 200)";
        fade_on_empty = false;
        font_family = "Atkinson Hyperlegible";
        placeholder_text = "<i><span foreground='##cdd6f4'>Input Password...</span></i>";
        hide_input = false;
        position = "0, -120";
        halign = "center";
        valign = "center";
      };
      label = [
        {
          text = "$TIME";
          color = "rgba(255, 255, 255, 0.6)";
          font_size = "120";
          font_family = "Atkinson Hyperlegible";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }
        {
          text = " Hi there, $USER";
          color = "rgba(255, 255, 255, 0.6)";
          font_size = 25;
          font_family = "Atkinson Hyperlegible";
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
