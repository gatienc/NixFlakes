# https://github.com/nix-community/impermanence#module-usage
{
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos" # not sure why but cuts a warning
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
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
        "Zotero"

        # Browser configuration
        ".mozilla"
        ".zen"

        # vscode configuration
        ".vscode"
        ".config/Code" # TODO: Nixify Vscode settings

        ".config/obsidian"
        ".config/sops"

        # Games
        ## Platforms
        ".steam"

        ## Minecraft
        ".local/share/PrismLauncher"
        ".local/share/ATLauncher"
        ".local/share/TLauncher"

        ".cache" # cache

      ];
      files = [
        ".bash_history"
        ".zsh_history"
      ];
    };
  };
}
