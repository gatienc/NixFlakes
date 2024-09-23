{ inputs, pkgs, lib, config, ... }: {
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    fira-mono
    hack-font
    noto-fonts
    inconsolata
    iosevka
    twemoji-color-font
    openmoji-color
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    }) # fonts name can get in ``https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/data/fonts/nerdfonts/shas.nix`

  ];
  fonts.fontconfig = {
    defaultFonts = {
      emoji = [ "apple-color-emoji" "WhatsApp Emoji" "Noto Color Emoji" "Twemoji" "OpenMoji" ];
    };
  };

}
