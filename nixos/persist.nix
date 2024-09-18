# https://github.com/nix-community/impermanence#module-usage
{
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      # machine-id is used by systemd for the journal, if you don't persist this
      # file you won't be able to easily use journalctl to look at journals for
      # previous boots.
      "/etc/machine-id"
    ];
    users.gatien = {
      directories = [
        ".local/share"
        ".mozilla"
        ".ssh"
        ".vscode"
        "Downloads"
        "Games"
        "NixFlakes"
        ".config/Code" #TODO: Nixify Vscode settings
        ".steam"
        ".cache/lutris"
      ];
      files = [
        ".bash_history"
        ".zsh_history"
      ];
    };
  };
}
