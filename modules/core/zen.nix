{ inputs, pkgs, lib, config, ... }: {

  environment.systemPackages = [
    inputs.zen-browser.packages."${pkgs.system}".default
  ];

}