{ inputs, pkgs, lib, config, ... }: {

  nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

  environment.systemPackages = [ pkgs.affinity-v3 ];

}
