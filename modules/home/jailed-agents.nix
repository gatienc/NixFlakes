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
    python3
    uv
    marimo
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
    "${config.home.homeDirectory}/.config/opencode-jailed"
    "${config.home.homeDirectory}/.local/share/opencode"
    "${config.home.homeDirectory}/.local/state/opencode"
    "${config.home.homeDirectory}/.cache/opencode"
    "${config.home.homeDirectory}/.local/state/marimo"
    "${config.home.homeDirectory}/.cache/uv"
    "${config.home.homeDirectory}/.local/share/uv"
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
          # Write managed config files to writable dir (runs on host before jail starts)
          (add-runtime ''
            CONFIG_DIR="${config.home.homeDirectory}/.config/opencode-jailed"
            mkdir -p "$CONFIG_DIR"
            cat > "$CONFIG_DIR/opencode.json" << 'EOF'
{
  "plugin": ["opencode-websearch"],
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["~/.config/opencode/jailed-instructions.md"],
  "agent": {
    "build": {
      "permission": "allow"
    }
  }
}
EOF
            cat > "$CONFIG_DIR/jailed-instructions.md" << 'EOF'
# Jailed Agent

You are running inside a **bubblewrap (bwrap) sandbox** with restricted filesystem access.

## Filesystem Access

| Path | Access |
|------|--------|
| `/tmp` | readwrite |
| Current working directory | readwrite |
| `~/.agents/` | readwrite — installed skills |
| `~/.config/opencode/` | readwrite — your config |
| `~/.local/share/opencode/` | readwrite |
| `~/.local/state/opencode/` | readwrite |
| `~/.cache/opencode/` | readwrite |
| `~/.local/state/marimo/` | readwrite — marimo server registry |
| `~/.cache/uv/` | readwrite — uv cache |
| `~/.local/share/uv/` | readwrite — uv tool installs |

Everything else is **inaccessible**: `~/.ssh`, `~/.gnupg`, `/etc`, other users' homes, system files.

## Network

Network access is **enabled**.

## Constraint

You cannot escape the sandbox. Python, bash, and all tools are restricted by the kernel to the paths above. If you need access outside these, ask the user.
EOF
          '')

          # Config directories for opencode
          (readwrite (noescape "/tmp"))
          (readwrite (noescape "~/.agents"))
          (rw-bind (noescape "~/.config/opencode-jailed") (noescape "~/.config/opencode"))
          (readwrite (noescape "~/.local/share/opencode"))
          (readwrite (noescape "~/.local/state/opencode"))
          (readwrite (noescape "~/.cache/opencode"))

          # Marimo server registry (discover/start marimo sessions)
          (readwrite (noescape "~/.local/state/marimo"))

          # UV cache/tool dirs (for uvx to download and run packages)
          (readwrite (noescape "~/.cache/uv"))
          (readwrite (noescape "~/.local/share/uv"))

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
        # Write managed config files to writable dir (runs on host before jail starts)
        (add-runtime ''
          CONFIG_DIR="${config.home.homeDirectory}/.config/opencode-jailed"
          mkdir -p "$CONFIG_DIR"
          cat > "$CONFIG_DIR/opencode.json" << 'EOF'
{
  "plugin": ["opencode-websearch"],
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["~/.config/opencode/jailed-instructions.md"],
  "agent": {
    "build": {
      "permission": "allow"
    }
  }
}
EOF
          cat > "$CONFIG_DIR/jailed-instructions.md" << 'EOF'
# Jailed Agent

You are running inside a **bubblewrap (bwrap) sandbox** with restricted filesystem access.

## Filesystem Access

| Path | Access |
|------|--------|
| `/tmp` | readwrite |
| Current working directory | readwrite |
| `~/.agents/` | readwrite — installed skills |
| `~/.config/opencode/` | readwrite — your config |
| `~/.local/share/opencode/` | readwrite |
| `~/.local/state/opencode/` | readwrite |
| `~/.cache/opencode/` | readwrite |
| `~/.local/state/marimo/` | readwrite — marimo server registry |
| `~/.cache/uv/` | readwrite — uv cache |
| `~/.local/share/uv/` | readwrite — uv tool installs |

Everything else is **inaccessible**: `~/.ssh`, `~/.gnupg`, `/etc`, other users' homes, system files.

## Network

Network access is **enabled**.

## Constraint

You cannot escape the sandbox. Python, bash, and all tools are restricted by the kernel to the paths above. If you need access outside these, ask the user.
EOF
        '')

        (readwrite (noescape "/tmp"))
        (readwrite (noescape "~/.agents"))
        (rw-bind (noescape "~/.config/opencode-jailed") (noescape "~/.config/opencode"))
        (readwrite (noescape "~/.local/share/opencode"))
        (readwrite (noescape "~/.local/state/opencode"))
        (readwrite (noescape "~/.cache/opencode"))

        # Marimo server registry (discover/start marimo sessions)
        (readwrite (noescape "~/.local/state/marimo"))

        # UV cache/tool dirs (for uvx to download and run packages)
        (readwrite (noescape "~/.cache/uv"))
        (readwrite (noescape "~/.local/share/uv"))

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
