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
    ollama
    llmfit
    lmstudio
  ];

}
