{ pkgs, username, ... }:

{
  service.nix-daemon.enable = true;
  users.users.${username} = {
    home = "/Users/${username}";
  };
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  homebrew = {
    enable = true;

    casks = [
      "discord"
      "visual-studio-code"
    ];
  };
  system.stateVersion = 5;
  environment.shells = [ pkgs.zsh ];

}
