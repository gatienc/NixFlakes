{
  ...
}:
{
  config = {
    home.file = {
      ".config/hypr/pyprland.toml" = {
        text = ''
          [pyprland]
          plugins = ["scratchpads", "fetch_client_menu","monitors"]

          [workspaces_follow_focus]

          [scratchpads.term]
          animation = "fromTop"
          command = "kitty --class kitty-dropterm"
          class = "kitty-dropterm"
          size = "75% 60%"
          max_size = "1920px 100%"
          margin = 50

          [scratchpads.volume]
          command = "pavucontrol"
          animation = "fromRight"
          lazy = true
          size = "15% 25%"
        '';
        executable = false;
      };

      ".config/hypr/hyprshade.toml" = {
        text = ''
          [[shades]]
          name = "blue-light-filter"
          start_time = 19:00:00
          end_time = 06:00:00
        '';
        executable = false;
      };
    };
  };
}
