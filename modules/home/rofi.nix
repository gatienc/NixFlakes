{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.lib.stylix.colors)
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base07
    base08
    base09
    base0A
    base0B
    base0C
    base0D
    base0E
    base0F
    ;
  inherit (config.stylix.fonts) monospace;
  # Fuzzel-like: single column, no sidebar, centered, minimal. Styling follows stylix (base16).
  themeRasi = ''
    configuration {
      modi: "drun,run";
      show-icons: true;
      terminal: "kitty";
      drun-display-format: "{icon} {name}";
      location: 0;
      disable-history: false;
      hide-scrollbar: true;
      display-drun: "";
      display-run: "";
      sidebar-mode: false;
      font: "${monospace.name} 11";
    }

    * {
      bg-col:  #${base00};
      bg-col-light: #${base01};
      border-col: #${base02};
      selected-col: #${base02};
      blue: #${base0D};
      fg-col: #${base05};
      fg-col2: #${base07};
      grey: #${base03};
      width: 420;
      font: "${monospace.name} 11";
    }

    element-text, element-icon, mode-switcher {
      background-color: inherit;
      text-color:       inherit;
    }

    window {
      height: 320px;
      border: 1px;
      border-color: #${base02};
      background-color: #${base00};
      border-radius: 12px;
    }

    mainbox {
      background-color: #${base00};
      border-radius: 12px;
    }

    inputbar {
      children: [prompt,entry];
      background-color: #${base01};
      border-radius: 8px 8px 0px 0px;
      padding: 8px 12px;
    }

    prompt {
      background-color: transparent;
      padding: 0px;
      text-color: #${base05};
      border-radius: 0px;
      margin: 0px 8px 0px 0px;
      font: "${monospace.name} 11";
    }

    textbox-prompt-colon {
      expand: false;
      str: " ";
    }

    entry {
      padding: 0px;
      margin: 0px;
      text-color: #${base05};
      background-color: transparent;
    }

    listview {
      border: 0px;
      padding: 4px 0px 8px;
      margin: 0px;
      columns: 1;
      lines: 8;
      background-color: #${base00};
      border-radius: 0px 0px 12px 12px;
    }

    element {
      padding: 6px 12px;
      background-color: #${base00};
      text-color: #${base05};
    }

    element-icon {
      size: 22px;
    }

    element selected {
      background-color: #${base02};
      text-color: #${base05};
    }

    message {
      background-color: #${base01};
      border: 1px;
      border-color: #${base02};
      padding: 6px;
      border-radius: 8px;
    }

    textbox {
      padding: 6px 12px;
      margin: 0px;
      text-color: #${base05};
      background-color: #${base01};
    }
  '';
  themeFile = pkgs.writeText "rofi-custom.rasi" themeRasi;
in
{
  programs.rofi = {
    enable = true;
    # Pass store path as string so HM uses @theme "/nix/store/..."; a derivation would be treated as attrs and break.
    theme = lib.mkForce "${themeFile}";
  };
}
