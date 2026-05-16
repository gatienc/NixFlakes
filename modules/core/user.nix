{ pkgs, inputs, username, host, config, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."password-${host}".path;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  nix.settings.allowed-users = [ "${username}" ];
}
