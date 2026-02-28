{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  fonts.fontDir.enable = true;
  fonts.packages =
    with pkgs;
    [
      atkinson-hyperlegible-next
      fira-code
      fira-code-symbols
      fira-mono
      hack-font
      noto-fonts
      inconsolata
      iosevka
      twemoji-color-font
      # openmoji-color  # Temporarily disabled due to test failures
      # fonts name can get in ``https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/data/fonts/nerdfonts/shas.nix`
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  fonts.fontconfig = {
    defaultFonts = {
      emoji = [
        "apple-color-emoji"
        "WhatsApp Emoji"
        "Noto Color Emoji"
        "Twemoji"
        "OpenMoji"
      ];
    };
  };

}
