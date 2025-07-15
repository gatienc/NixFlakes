{ pkgs, ... }:

{
  # List of packages to install.
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    unzip
  ];

  # Set the state version.
  system.stateVersion = 4;
}
