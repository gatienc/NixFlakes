{
  inputs,
  pkgs,
  ...
}:
let
  username = "gatien";
in
{
  imports = [
    ./darwin-configuration.nix
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
