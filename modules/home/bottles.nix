{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:
{

  home.packages = with pkgs; [
    bottles # run windows software in linux, including games, and manage wine prefixes
  ];
}
