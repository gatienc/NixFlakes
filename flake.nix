{
  description = "One flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyprland.url = "github:hyprland-community/pyprland";
    ags.url = "github:Aylur/ags";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    stylix.url = "github:danth/stylix";
  };

  outputs = inputs@{ nixpkgs, impermanence, home-manager, stylix, self, ... }:
    let
      username = "gatien";
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        glacius = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/glacius ];
          specialArgs = { host = "glacius"; inherit self inputs username; };
        };
        icicle = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/icicle ];
          specialArgs = { host = "icicle"; inherit self inputs username; };
        };
        droplet = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/droplet ];
          specialArgs = { host = "droplet"; inherit self inputs username; };
        };
      };
      # nixosConfigurations = {
      #   glacius = nixpkgs.lib.nixosSystem {
      #     system = "x86_64-linux";
      #     # Pass inputs into the NixOS module system
      #     specialArgs = { inherit inputs; };
      #     modules = [
      #       impermanence.nixosModules.impermanence
      #       stylix.nixosModules.stylix
      #       ./hosts/glacius.nix
      #       ./nixos/configuration.nix
      #       ./nixos/persist.nix
      #       ./nixos/hyprland.nix
      #       ./nixos/hardware.nix
      #       ./nixos/stylix.nix
      #       ./nixos/zen.nix
      #       ./nixos/laptop.nix
      #       ./nixos/remote-desktop.nix
      #       ./nixos/fonts.nix
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.users.gatien = import ./home-manager/home.nix;
      #       }
      #     ];
      #   };
      #   icicle = nixpkgs.lib.nixosSystem {
      #     system = "x86_64-linux";
      #     # Pass inputs into the NixOS module system
      #     specialArgs = { inherit inputs; };
      #     modules = [
      #       impermanence.nixosModules.impermanence
      #       stylix.nixosModules.stylix
      #       ./hosts/icicle.nix
      #       ./nixos/configuration.nix
      #       ./nixos/persist.nix
      #       ./nixos/hyprland.nix
      #       ./nixos/hardware.nix
      #       ./nixos/stylix.nix
      #       ./nixos/zen.nix
      #       ./nixos/laptop.nix
      #       ./nixos/fonts.nix
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.users.gatien = import ./home-manager/home.nix;
      #         home-manager.extraSpecialArgs = { inherit inputs; };
      #       }
      #     ];
      #   };
      #   droplet = nixpkgs.lib.nixosSystem {
      #     system = "x86_64-linux";
      #     # Pass inputs into the NixOS module system
      #     specialArgs = { inherit inputs; };
      #     modules = [
      #       ./hosts/droplet.nix
      #       ./nixos/configuration.nix
      #       #home-manager.nixosModules.home-manager
      #       #{
      #       #  home-manager.useGlobalPkgs = true;
      #       #  home-manager.useUserPackages = true;
      #       #  home-manager.users.gatien = import ./home-manager/home.nix;
      #       #  home-manager.extraSpecialArgs = { inherit inputs; };
      #       #}
      #     ];
      #   };
      # };
    };
}
