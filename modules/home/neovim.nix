{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withPython3 = false; # LazyVim uses Lua, not Python
    withNodeJs = false;  # Set to true if you need Node-based plugins
    withRuby = false;    # Not needed for LazyVim
  };

  home.packages = with pkgs; [
    # LazyVim dependencies (required)
    git
    ripgrep
    fd
    lazygit

    # LSP servers and language tools
    lua-language-server
    nil # nix language server
    nixfmt # nix formatter

    # Additional tools LazyVim commonly uses
    tree-sitter
    nodejs
    gcc # for building native extensions
  ];

  # Clone LazyVim starter config if no config exists
  # This follows the official LazyVim installation guide:
  # https://www.lazyvim.org/installation
  home.activation.installLazyVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Backup existing config if present (as recommended by LazyVim)
    if [ -d "$HOME/.config/nvim" ] && [ ! -f "$HOME/.config/nvim/.lazyvim-installed" ]; then
      $DRY_RUN_CMD mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y%m%d%H%M%S)"
      echo "Backed up existing nvim config"
    fi

    # Install LazyVim starter if not present
    if [ ! -d "$HOME/.config/nvim" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.config"
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
      $DRY_RUN_CMD rm -rf "$HOME/.config/nvim/.git"
      $DRY_RUN_CMD touch "$HOME/.config/nvim/.lazyvim-installed"
      echo "LazyVim starter config installed to ~/.config/nvim"
      echo "Run 'nvim' to complete the setup (may take a few minutes on first launch)"
    fi
  '';
}
