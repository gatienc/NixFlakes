{ pkgs, inputs, config, username, ... }:
{
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

  sops.secrets.example-key = { };
  systemd.services."sometestservice" = {
    script = ''
      echo "
      Hey bro! I'm a service, and imma send this secure password:
      $(cat ${config.sops.secrets."example_key".path})
      located in:
      ${config.sops.secrets."example_key".path}
      to database and hack the mainframe
      " > /var/lib/sometestservice/testfile
    '';
    serviceConfig = {
      User = "sometestservice";
      WorkingDirectory = "/var/lib/sometestservice";
    };
  };

  users.users.sometestservice = {
    home = "/var/lib/sometestservice";
    createHome = true;
    isSystemUser = true;
    group = "sometestservice";
  };
  users.groups.sometestservice = { };

}
