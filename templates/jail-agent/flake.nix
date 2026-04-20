{
  description = "Jailed AI agent dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    jail-nix = {
      url = "sourcehut:~alexdavid/jail.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      jail-nix,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      jail = jail-nix.lib.init pkgs;
      commonJailOptions = with jail.combinators; [
        network
        time-zone
        mount-cwd
        mount-dev
        mount-proc
        no-new-session
      ];
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          (jail "pi-agent" pkgs.pi-coding-agent (
            with jail.combinators;
            (
              commonJailOptions
              ++ [
                (readwrite (noescape "~/.cache/pi"))
                (readwrite (noescape "~/.local/share/pi"))
                (add-pkg-deps [
                  pkgs.git
                  pkgs.curl
                  pkgs.bat
                ])
              ]
            )
          ))
        ];
      };
    };
}
