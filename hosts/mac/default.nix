{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [ ./darwin-configuration.nix ];

  # Home-manager configuration for mac
  home-manager.users.${username} = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];
    home.packages = with pkgs; [
      git
      wget
      curl
      unzip
    ];
    home.stateVersion = "24.05";
  };
}
