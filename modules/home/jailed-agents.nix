{
  inputs,
  pkgs,
  lib,
  config,
  username,
  system ? pkgs.system,
  ...
}:

let
  jail = inputs.jail-nix.lib.init pkgs;

  # Common packages available to all agents in sandbox
  commonAgentPkgs = with pkgs; [
    bashInteractive
    curl
    wget
    jq
    git
    which
    ripgrep
    gnugrep
    gawkInteractive
    ps
    findutils
    gzip
    unzip
    gnutar
    diffutils
    bat
    eza
    fd
    fzf
  ];

  # Common sandbox options shared by all agents
  commonJailOptions = with jail.combinators; [
    network
    time-zone
    no-new-session
    mount-cwd
  ];

  # Directories that need to exist for jailed agents
  agentConfigDirs = [
    "${config.home.homeDirectory}/.agents"
    "${config.home.homeDirectory}/.config/opencode"
    "${config.home.homeDirectory}/.local/share/opencode"
    "${config.home.homeDirectory}/.local/state/opencode"
    "${config.home.homeDirectory}/.cache/opencode"
    "${config.home.homeDirectory}/.config/pi"
    "${config.home.homeDirectory}/.cache/pi"
    "${config.home.homeDirectory}/.local/share/pi"
  ];

in
{
  # Ensure agent config directories exist (required for bind mounts)
  home.activation.createAgentConfigDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for dir in ${lib.concatStringsSep " " agentConfigDirs}; do
      if [ ! -d "$dir" ]; then
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$dir"
      fi
    done
  '';

  # Library functions for creating custom jailed agents
  # Usage: self.lib.jailedAgents.mkJailedAgent { name = "my-agent"; pkg = pkgs.some-agent; extraPkgs = [ pkgs.go ]; }
  lib.jailedAgents = {
    inherit commonAgentPkgs commonJailOptions jail;

    mkJailedAgent =
      {
        name,
        pkg,
        extraPkgs ? [ ],
        extraOptions ? [ ],
        configDirs ? [ ],
      }:
      jail "jailed-${name}" pkg (
        with jail.combinators;
        commonJailOptions
        ++ [
          (add-pkg-deps commonAgentPkgs)
          (add-pkg-deps extraPkgs)
        ]
        ++ (map (dir: readwrite (noescape dir)) configDirs)
        ++ extraOptions
      );

    mkJailedOpencode =
      {
        extraPkgs ? [ ],
        extraOptions ? [ ],
      }:
      jail "jailed-opencode" pkgs.opencode (
        with jail.combinators;
        commonJailOptions
        ++ [
          # Config directories for opencode
          (readwrite (noescape "~/.agents"))
          (readwrite (noescape "~/.config/opencode"))
          (readwrite (noescape "~/.local/share/opencode"))
          (readwrite (noescape "~/.local/state/opencode"))
          (readwrite (noescape "~/.cache/opencode"))

          (add-pkg-deps commonAgentPkgs)
          (add-pkg-deps extraPkgs)
        ]
        ++ extraOptions
      );

    mkJailedPi =
      {
        extraPkgs ? [ ],
        extraOptions ? [ ],
      }:
      jail "jailed-pi" pkgs.pi-coding-agent (
        with jail.combinators;
        commonJailOptions
        ++ [
          # Config directories for pi
          (readwrite (noescape "~/.agents"))
          (readwrite (noescape "~/.config/pi"))
          (readwrite (noescape "~/.cache/pi"))
          (readwrite (noescape "~/.local/share/pi"))

          (fwd-env "OPENCODE_API_KEY")
          (add-pkg-deps commonAgentPkgs)
          (add-pkg-deps extraPkgs)
        ]
        ++ extraOptions
      );
  };

  # Pre-configured jailed agents available as packages
  home.packages = [
    # Jailed opencode - use with: jailed-opencode
    (jail "jailed-opencode" pkgs.opencode (
      with jail.combinators;
      commonJailOptions
      ++ [
        (readwrite (noescape "~/.agents"))
        (readwrite (noescape "~/.config/opencode"))
        (readwrite (noescape "~/.local/share/opencode"))
        (readwrite (noescape "~/.local/state/opencode"))
        (readwrite (noescape "~/.cache/opencode"))
        (add-pkg-deps commonAgentPkgs)
      ]
    ))

    # Jailed pi - use with: jailed-pi
    (jail "jailed-pi" pkgs.pi-coding-agent (
      with jail.combinators;
      commonJailOptions
      ++ [
        (readwrite (noescape "~/.agents"))
        (readwrite (noescape "~/.config/pi"))
        (readwrite (noescape "~/.cache/pi"))
        (readwrite (noescape "~/.local/share/pi"))
        (fwd-env "OPENCODE_API_KEY")
        (add-pkg-deps commonAgentPkgs)
      ]
    ))
  ];
}
