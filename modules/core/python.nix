{ pkgs, ... }:
{
  devShells.x86_64-linux.default = pkgs.mkShell
    {

      packages = [
        pkgs.python3
      ];
      env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.libz
      ];
    };
}
