{ pkgs, inputs, config, username, host, lib, ... }:
let
  hosts = [ "glacius" "icicle" "frostion" ];
  passwordSecrets = builtins.map (h: "password-${h}") hosts;
in {
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = lib.genAttrs passwordSecrets (name: {
    neededForUsers = true;
  });
}
