{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = null; # You can set a wallpaper image path here if desired
    base16Scheme = "${pkgs.base16-schemes}/share/themes/github-dark.yaml";
    # Optionally, set fonts and other style options here
    # fonts = { ... };
    opacity = {
      applications = 0.95;
      terminal = 0.95;
      desktop = 1.0;
      popups = 0.95;
    };
  };
}
