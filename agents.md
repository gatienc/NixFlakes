# NixFlakes Configuration

One flake to rule them all - a NixOS and macOS configuration managed with flakes.

## Structure Overview

```
NixFlakes/
├── flake.nix           # Main flake entry point
├── flake.lock          # Locked dependencies
├── hosts/              # Machine-specific configurations
│   ├── glacius/        # Desktop AMD
│   ├── icicle/         # Desktop AMD (with impermanence)
│   ├── frostion/       # Desktop Intel
│   ├── droplet/        # VPS
│   └── mac/            # macOS laptop
└── modules/            # Reusable NixOS/home-manager modules
    ├── core/           # System-level modules (NixOS)
    └── home/           # User-level modules (home-manager)
```

## How It Works

### Flake Entry Point (`flake.nix`)

The `flake.nix` defines:
- **Inputs**: External flake dependencies (nixpkgs, home-manager, sops-nix, stylix, hyprland, etc.)
- **Outputs**: Machine configurations via `nixosConfigurations` and `darwinConfigurations`

Each host gets:
- Its own system configuration
- Shared modules via imports
- Access to `inputs`, `username`, and `host` via `specialArgs`

### Hosts (`hosts/<name>/`)

Each host directory contains:
- `default.nix` - Main configuration file
- `hardware-configuration.nix` - Hardware-specific settings (usually generated)

Host `default.nix` imports:
1. Home-manager module
2. Core modules (system-level)
3. Home modules (user-level)
4. Hardware configuration

### Modules

#### Core Modules (`modules/core/`)
System-level NixOS configuration:
- `common.nix` - Base settings (user, network, locale, boot)
- `gaming.nix` - Game-related stuff (Minecraft, ROCm, etc.)
- `stylix.nix` - Global theming
- `ssh.nix`, `bluetooth.nix`, `network.nix`, etc.

#### Home Modules (`modules/home/`)
User-level home-manager configuration:
- `common.nix` - Base packages, git, zsh, kitty, starship, etc.
- `desktop.nix` - Desktop environment settings
- `gaming.nix` - Gaming packages
- Hyprland submodules (`hyprland/`)
- Darwin submodules (`darwin/`)

## Available Hosts

| Host                    | Type          | Notes                         |
| ----------------------- | ------------- | ----------------------------- |
| `glacius`               | Desktop AMD   | Main desktop with ROCm        |
| `icicle`                | Desktop AMD   | With impermanence (stateless) |
| `frostion`              | Desktop Intel | Stylix theming                |
| `droplet`               | VPS           | Minimal config                |
| `MacBook-Pro-de-Gatien` | macOS         | Laptop                        |
