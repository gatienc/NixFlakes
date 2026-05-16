{ inputs, pkgs, config, ... }:

{
  home.packages = [
    inputs.zen-browser.packages."${pkgs.system}".default
  ];
}
