# https://github.com/nix-community/impermanence#module-usage
{
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos" # not sure why but cuts a warning
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
        # secrets configuration
        ".ssh"

        # Directories
        "Documents"
        "Downloads"
        "Games"
        "NixFlakes"

        # Browser configuration
        ".mozilla"

        # vscode configuration
        ".vscode"
        ".config/Code" #TODO: Nixify Vscode settings
        ".config/obsidian"

        # Games
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
