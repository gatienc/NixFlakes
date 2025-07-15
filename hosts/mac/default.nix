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
  ];

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      imports = [ ../../modules/home/common.nix ];
    };
  };
}
