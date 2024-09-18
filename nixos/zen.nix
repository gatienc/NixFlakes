{ inputs, pkgs, lib, config, ... }: {

  environment.systemPackages = [
    inputs.zen-browser.packages."${system}".default
  ];

}