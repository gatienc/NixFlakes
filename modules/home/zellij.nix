{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Helper function to generate AI agent layout KDL
  # Takes the agent name (for tab name) and command
  mkAgentLayout = name: cmd: ''
    // Zellij layout for ${name}
    // Opens current directory with shell + ${name} agent tabs

    layout {
        default_tab_template {
            pane size=1 borderless=true {
                plugin location="zellij:tab-bar"
            }
            children
            pane size=2 borderless=true {
                plugin location="zellij:status-bar"
            }
        }

        tab name="shell" {
            pane
        }

        tab name="${lib.toLower name}" {
            pane command="${cmd}"
        }
    }
  '';

  # Define AI agent layouts
  agentLayouts = {
    zoc = {
      name = "OpenCode";
      cmd = "jailed-opencode";
    };
    zpi = {
      name = "Pi";
      cmd = "jailed-pi";
    };
  };
in
{
  programs.zellij = {
    enable = true;
    settings = {
      theme = "dracula";
      keybinds = {
        normal = {
          "bind \"Ctrl o\"" = {
            "LaunchOrFocusPlugin \"zellij:session-manager\"" = {
              floating = true;
              move_to_focused_tab = true;
            };
          };
        };
      };
    };
  };

  # Generate layout files programmatically
  xdg.configFile = lib.mapAttrs' (
    filename: agent:
    lib.nameValuePair "zellij/layouts/${filename}.kdl" {
      text = mkAgentLayout agent.name agent.cmd;
    }
  ) agentLayouts;

  # Shell aliases for layouts
  programs.zsh.shellAliases = lib.mapAttrs' (
    filename: _: lib.nameValuePair filename "zellij --layout ${filename}"
  ) agentLayouts;
}
