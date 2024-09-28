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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    stylix.url = "github:danth/stylix";
  };

  outputs = { nixpkgs, impermanence, stylix, self, ... } @ inputs:
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
          modules = [
            ./hosts/icicle
            impermanence.nixosModules.impermanence
            stylix.nixosModules.stylix
          ];
          specialArgs = { host = "icicle"; inherit self inputs username; };
        };
        droplet = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/droplet ];
          specialArgs = { host = "droplet"; inherit self inputs username; };
        };
      };
    };
}
