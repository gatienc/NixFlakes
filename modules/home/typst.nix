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
    typst # The Typst compiler
    tinymist # LSP for Typst
    typstyle # Formatter for Typst (typstfmt is deprecated)
  ];
}
