{ pkgs, username, ... }:

{
  users.users.${username} = {
    home = "/Users/${username}";
  };
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  system.primaryUser = username;
  homebrew = {
    enable = true;

    casks = [
      "slack"
      "visual-studio-code"
    ];
  };
  system.stateVersion = 5;
  environment.shells = [ pkgs.zsh ];

}
