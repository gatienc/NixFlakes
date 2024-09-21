{ pkgs, lib, ... }:
{
  stylix = {
    enable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 16;
    };

    image = ../assets/wallpaper/pixel_kanagawa.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.whatsapp-emoji-linux;
        name = "WhatsApp Emoji";
      };
    };

    opacity = {
      applications = 0.95;
      terminal = 0.8;
      desktop = 1.0;
      popups = 0.95;
    };

    polarity = "dark"; # "light" or "either"
  };

}

