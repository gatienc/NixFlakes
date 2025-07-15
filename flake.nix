{
  description = "One flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    pyprland.url = "github:hyprland-community/pyprland";
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
  };

  outputs =
    { nixpkgs
    , impermanence
    , stylix
    , self
    , ...
    }@inputs:
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
      homeConfigurations = {
        "mac" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          extraSpecialArgs = { inherit inputs username; };
          modules = [ ./hosts/mac ];
        };
      };
    };
}
