{ pkgs, ... }:

{
  system.stateVersion = 5;

  environment.shells = [ pkgs.zsh ];

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
