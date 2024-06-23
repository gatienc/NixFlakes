{
  description = "Gatienc's config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    stylix.url = "github:danth/stylix";
    
  };

  outputs = inputs@{ nixpkgs, impermanence, home-manager, ... }: {
    nixosConfigurations = {
      glacius = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Pass inputs into the NixOS module system
        specialArgs = { inherit inputs; };

        modules = [
          impermanence.nixosModules.impermanence
          ./hosts/glacius.nix
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gatien = import ./home-manager/home.nix;
          }
        ];
      };
      icicle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Pass inputs into the NixOS module system
        specialArgs = { inherit inputs; };

        modules = [
          impermanence.nixosModules.impermanence
          ./hosts/icicle.nix
          ./nixos/configuration.nix
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gatien = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
