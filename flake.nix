{
  description = "One flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs =
    {
      nixpkgs,
      impermanence,
      stylix,
      home-manager,
      self,
      ...
    }@inputs:
    let
      username = "gatien";
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        glacius = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/glacius
            stylix.nixosModules.stylix
          ];
          specialArgs = {
            host = "glacius";
            inherit self inputs username;
          };
        };
        icicle = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/icicle
            impermanence.nixosModules.impermanence
            stylix.nixosModules.stylix
          ];
          specialArgs = {
            host = "icicle";
            inherit self inputs username;
          };
        };
        droplet = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/droplet ];
          specialArgs = {
            host = "droplet";
            inherit self inputs username;
          };
        };
        frostion = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/frostion
            stylix.nixosModules.stylix
          ];
          specialArgs = {
            host = "frostion";
            inherit self inputs username;
          };
        };
      };
      darwinConfigurations = {
        "MacBook-Pro-de-Gatien" = inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs username; };
          modules = [
            inputs.home-manager.darwinModules.home-manager
            stylix.darwinModules.stylix
            ./hosts/mac
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
      };
    };
}
