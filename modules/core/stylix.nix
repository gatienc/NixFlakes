{
  pkgs,
  lib,
  stylix,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    base16-schemes
    adwaita-icon-theme # for icons in nautilus
    morewaita-icon-theme
    whatsapp-emoji-font
  ];

  stylix = {
    enable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 16;
    };
    image = ../../assets/wallpaper/pixel_kanagawa.png;
    # https://tinted-theming.github.io/base16-gallery/
    # Dracula, Nord, cattpuccin-mocha
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.atkynson-mono;
        name = "AtkynsonMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.atkinson-hyperlegible-next;
        name = "Atkinson Hyperlegible";
      };
      serif = {
        package = pkgs.atkinson-hyperlegible-next;
        name = "Atkinson Hyperlegible";
      };
      emoji = {
        package = pkgs.whatsapp-emoji-font;
        name = "WhatsApp Emoji";
      };
    };

    opacity = {
      applications = 0.95;
      terminal = 0.85;
      desktop = 1.0;
      popups = 0.95;
    };

    polarity = "dark"; # "light" or "either"
  };
}
