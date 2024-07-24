{ pkgs,lib, ... }: 
{
      stylix.cursor.package = pkgs.bibata-cursors;
      stylix.cursor.name = "Bibata-Modern-Ice";
      stylix.cursor.size = 12;
      stylix.image = ../assets/wallpaper/pixel_kanagawa.png;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      stylix.fonts = {
            monospace = {
                  package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
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
      };

      stylix.opacity = {
            applications = 0.95;
            terminal = 0.8;
            desktop = 1.0;
            popups = 0.95;
      };
      
      stylix.polarity = "dark"; # "light" or "either"

}

