{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:

{
  # Non-sandboxed versions for full system access
  # For sandboxed versions, use jailed-agents.nix which provides:
  # - jailed-opencode (restricted to cwd, network, and config dirs)
  # - jailed-pi (restricted to cwd, network, and config dirs)
  home.packages = with pkgs; [
    opencode
    llmfit
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # ollama is managed as a NixOS service on Linux
    # but needs to be installed as a package on macOS
    ollama
  ];

}
