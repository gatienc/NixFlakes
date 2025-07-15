{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./darwin-configuration.nix
    inputs.home-manager.nix-darwin-modules.home-manager
  ];

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      home.packages = with pkgs; [
        git
        wget
        curl
        unzip
      ];
      home.stateVersion = "24.05";
    };
  };
}
