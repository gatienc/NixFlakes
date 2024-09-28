{ pkgs, inputs, username, host, ... }:
{

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "123";
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  nix.settings.allowed-users = [ "${username}" ];
}
