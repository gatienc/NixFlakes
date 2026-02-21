{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./darwin-configuration.nix
    inputs.home-manager.darwinModules.home-manager

    ../../modules/home/darwin/stylix.nix

  ];

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      imports = [
        ../../modules/home/common.nix
        ../../modules/home/darwin/aerospace.nix
        ../../modules/home/darwin/kitty.nix
        ../../modules/home/darwin/wallpaper.nix
        ../../modules/home/fvm.nix
      ];
      home.sessionPath = [
        "$HOME/.local/bin"
      ];
    };
  };
}
