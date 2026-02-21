{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  # Common packages for all systems
  commonPackages = with pkgs; [
    # Terminal
    bat # replacement for cat
    bat-extras.batdiff # extra features for bat
    bat-extras.batman # extra features for bat
    jless # Terminal json viewer
    eza # A modern replacement for ‘ls’
    fd # replacement for find
    ripgrep # replacement for grep
    fzf # A command-line fuzzy finder
    lazygit # git terminal
    lazydocker # docker terminal
    nmap # network exploration tool and security/port scanner
    arp-scan # network discovery tool

    tealdeer # tldr client
    wget # download files from the web
    ranger # terminal file manager
    glow # markdown previewer in terminal

    # archives
    zip
    unzip

    # Programming
    python3 # python3 with all the packages
    uv # package manager and installer
    zlib

    gcc # C compiler
    gnumake # GNU make
    cargo # rust package manager
    nodejs # nodejs runtime
    jdk # java development kit

    gh # github cli
    gh-dash # github dashboard
    copier # project templating tool

    # Nix
    nixfmt # nix formatting tool
    direnv # environment variable manager
    # secrets
    age # age encryption tool
    ssh-to-age # ssh to age encryption tool
    sops # secrets management tool

    # System information
    ncdu # disk space navigator
    dust # disk space navigator

    # System monitoring
    btop # replacement of htop/nmo
    iftop # network monitoring

    # Display image
    timg
    w3m

    ffmpeg

    # fun
    cowsay
    cbonsai # bonsai tree generator
    fortune # random quotes
    figlet # text art generator
    cmatrix # terminal screensaver
    asciiquarium # aquarium in terminal
  ];

  # Linux-only packages
  linuxPackages = with pkgs; [
    unrar # unrar tool
    dysk
    gthumb
    playerctl # control media players

    poetry

    iotop # io monitoring

    lshw # hardware information tool
    bluetuith # bluetooth manager
    clipse # clipboard manager
    gsimplecal # calendar
    # Desktop environment
    swww # wallpaper manager
    fuzzel # launcher
    rofi # application launcher
    dunst # notification manager
    libnotify # notification tool

    cava # audio visualizer
    iniparser # for cava

    alsa-utils # ALSA sound utilities

    # Office software
    libreoffice-qt # office suite
    hunspell # spell checker

    radeontop # GPU monitoring
    brightnessctl # control screen brightness
    pavucontrol # control audio devices
    pulsemixer # control audio devices
    pamixer # control audio volume
  ];

in
lib.mkMerge [
  # ===================================================================
  #
  #                            Common Config
  #
  # ===================================================================
  {
    home.packages = commonPackages;

    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        lfs.enable = true;
        settings.user.name = "Gatien Chenu";
        settings.user.email = "gatien+dev@chenu.me";
      };
      firefox.enable = true;
      zellij = {
        enable = true;
        settings.theme = "dracula";
        layouts = {
          gemini = ''
            layout {
                pane split_direction="vertical" {
                    pane
                    pane {
                        command "gemini"
                    }
                }
            }
          '';
        };
      };
      fzf.enable = true; # enables zsh integration by default
      starship.enable = true;
      kitty = {
        enable = true;
        keybindings = {
          "ctrl+alt+f" =
            "launch --type=overlay --stdin-source=@screen_scrollback ${pkgs.fzf}/bin/fzf --no-sort --no-mouse --exact -i"; # not working on macOS
        };
      };
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
          cd = "z";
          nano = "micro";
          cat = "bat";
          icat = "kitty +kitten icat";
          grep = "rg";
          diff = "batdiff";
          man = "batman";
          ls = "eza --icons --group-directories-first";
          ll = "eza --icons -l --group-directories-first";
          tree = "eza --tree --icons";
          whatismyip = "curl https://ipinfo.io/ip";
          c = "clear";
          g = "lazygit";
        };
        plugins = [
          {
            # Must be before plugins that wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting
            name = "fzf-tab";
            src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
            file = "fzf-tab.plugin.zsh";
          }
        ];

        completionInit = ''
          # Enable zmv for powerful file renaming
          autoload -Uz zmv

          # Initialize colors
          autoload -Uz colors
          colors

          # Initialize completion system
          _comp_options+=(globdots)

          # Load edit-command-line for ZLE
          autoload -Uz edit-command-line
          zle -N edit-command-line
          bindkey "^e" edit-command-line

          # General completion behavior
          zstyle ':completion:*' completer _extensions _complete _approximate

          # Use cache
          zstyle ':completion:*' use-cache on
          zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

          # Complete the alias
          zstyle ':completion:*' complete true

          # Autocomplete options
          zstyle ':completion:*' complete-options true

          # Completion matching control
          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
          zstyle ':completion:*' keep-prefix true

          # Group matches and describe
          zstyle ':completion:*' menu select
          zstyle ':completion:*' list-grouped false
          zstyle ':completion:*' list-separator '''
          zstyle ':completion:*' group-name '''
          zstyle ':completion:*' verbose yes
          zstyle ':completion:*:matches' group 'yes'
          zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
          zstyle ':completion:*:messages' format '%d'
          zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
          zstyle ':completion:*:descriptions' format '[%d]'

          # Colors
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

          # Directories
          zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
          zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
          zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
          zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
          zstyle ':completion:*' special-dirs true
          zstyle ':completion:*' squeeze-slashes true

          # Sort
          zstyle ':completion:*' sort false
          zstyle ":completion:*:git-checkout:*" sort false
          zstyle ':completion:*' file-sort modification
          zstyle ':completion:*:eza' sort false
          zstyle ':completion:complete:*:options' sort false
          zstyle ':completion:files' sort false

          # fzf-tab
          zstyle ':fzf-tab:*' use-fzf-default-opts yes
          # preview directory's content with eza when completing cd
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons -1 --color=always $realpath'
          # preview for general file completion
          zstyle ':fzf-tab:complete:*:*' fzf-preview 'eza --icons -a --group-directories-first -1 --color=always $realpath'
          # preview for kill command
          zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
          zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
          zstyle ':fzf-tab:*' fzf-command fzf
          zstyle ':fzf-tab:*' fzf-pad 4
          zstyle ':fzf-tab:*' fzf-min-height 100
          # switch group using '<' and '>'
          zstyle ':fzf-tab:*' switch-group '<' '>'
        '';

        initContent = ''
          setopt sharehistory
          setopt hist_ignore_space
          setopt hist_ignore_all_dups
          setopt hist_save_no_dups
          setopt hist_ignore_dups
          setopt hist_find_no_dups
          setopt hist_expire_dups_first
          setopt hist_verify

          # Copy current command buffer to clipboard
          copy-buffer-to-clipboard() {
            if [[ "$OSTYPE" == "darwin"* ]]; then
              echo -n "$BUFFER" | pbcopy
            else
              echo -n "$BUFFER" | wl-copy
            fi
            zle -M "Copied to clipboard"
          }
          zle -N copy-buffer-to-clipboard
          bindkey '^xc' copy-buffer-to-clipboard

          # Auto-activate Python virtual environments
          function auto_venv() {
            # If already in a virtualenv, do nothing
            if [[ -n "$VIRTUAL_ENV" && "$PWD" != *"''${VIRTUAL_ENV:h}"* ]]; then
              deactivate
              return  
            fi

            [[ -n "$VIRTUAL_ENV" ]] && return

            local dir="$PWD"
            while [[ "$dir" != "/" ]]; do
              if [[ -f "$dir/.venv/bin/activate" ]]; then
                source "$dir/.venv/bin/activate"
                return
              fi
              dir="''${dir:h}"
            done
          }

          # Auto-load Nix development shells
          function auto_nix() {
            # If we're already in a nix develop shell, do nothing
            [[ -n "$IN_NIX_SHELL" ]] && return

            # Walk up to find a flake
            local dir="$PWD"
            while [[ "$dir" != "/" ]]; do
              if [[ -f "$dir/flake.nix" ]]; then
                # If this project already has .envrc, just allow it (you can remove this if you prefer)
                if [[ ! -f "$dir/.envrc" ]]; then
                  # Create .envrc that loads the dev env (fast, no interactive shell)
                  cat > "$dir/.envrc" <<'EOF'
          # autogenerated: load flake dev environment
          eval "$(nix print-dev-env)"
          EOF
                  command direnv allow "$dir" >/dev/null 2>&1
                fi

                command direnv reload >/dev/null 2>&1
                return
              fi
              dir="''${dir:h}"
            done
          }

          # Auto-use correct Node version with nvm
          function auto_nvm() {
            [[ -f .nvmrc ]] && nvm use
          }

          # Register chpwd hooks
          autoload -Uz add-zsh-hook
          add-zsh-hook chpwd auto_venv
          add-zsh-hook chpwd auto_nix
          add-zsh-hook chpwd auto_nvm

          # Hotkey Insertions - Text Snippets
          # Insert git commit template (Ctrl+X, G, C)
          # \C-b moves cursor back one position
          bindkey -s '^Xgc' 'git commit -m ""\C-b'

          # More examples:
          bindkey -s '^Xgp' 'git push origin '
          bindkey -s '^Xgs' 'git status\n'
          bindkey -s '^Xgl' 'git log --oneline -n 10\n'

          # Suffix Aliases - Open Files by Extension
          alias -s json=jless
          alias -s md=bat
          alias -s go=$EDITOR
          alias -s rs=$EDITOR
          alias -s txt=bat
          alias -s log=bat
          alias -s py=$EDITOR
          alias -s js=$EDITOR
          alias -s ts=$EDITOR
          alias -s html=open

          # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
          # - The first argument to the function ($1) is the base path to start traversal
          # - See the source code (completion.{bash,zsh}) for the details.
          _fzf_compgen_path() {
            fd --hidden --exclude .git . "$1"
          }

          # Use fd to generate the list for directory completion
          _fzf_compgen_dir() {
            fd --type=d --hidden --exclude .git . "$1"
          }

          # Advanced customization of fzf options via _fzf_comprun function
          # - The first argument to the function is the name of the command.
          # - You should make sure to pass the rest of the arguments to fzf.
          _fzf_comprun() {
            local command=$1
            shift

            case "$command" in
              cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
              ssh)          fzf --preview 'dig {}'                   "$@" ;;
              *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
            esac
          }

          # Make sure that the terminal is in application mode when zle is active, since
          # only then values from $terminfo are valid
          if (( ''${+terminfo[smkx]} )) && (( ''${+terminfo[rmkx]} )); then
            function zle-line-init() {
              echoti smkx
            }
            function zle-line-finish() {
              echoti rmkx
            }
            zle -N zle-line-init
            zle -N zle-line-finish
          fi

          # Source user-managed aliases if present
          if [ -f ~/.zsh_aliases ]; then
            source ~/.zsh_aliases
          fi
        '';

        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "node"
            "npm"
          ];
          theme = "af-magic";
        };
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "24.05";
  }

  # ===================================================================
  #
  #                            Linux Config
  #
  # ===================================================================
  (lib.mkIf pkgs.stdenv.isLinux {
    home.packages = linuxPackages;

    programs.zsh.shellAliases = {
      nixswitch = "sudo nixos-rebuild switch";
      logout = "hyprctl dispatch exit";
      clip = "wl-copy";
    };
  })

  # ===================================================================
  #
  #                            macOS Config
  #
  # ===================================================================
  (lib.mkIf pkgs.stdenv.isDarwin {
    # Add any macOS-specific packages here
    # home.packages = [ pkgs.mac-app-utils ];

    programs.zsh.shellAliases = {
      # Example of a macOS-specific alias
      nixswitch = "sudo nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/NixFlakes#MacBook-Pro-de-Gatien --fallback --max-jobs auto";
      clip = "pbcopy";
    };
  })
]
