{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:

{
  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.webkitgtk_4_1}/lib:${pkgs.gtk3}/lib";
  };

  home.packages = with pkgs; [
    freecad
    blender
    bambu-studio
    orca-slicer
    webkitgtk_4_1
    gtk3
    (appimageTools.wrapType2 {
      pname = "elegoo-slicer";
      version = "1.3.0.11";
      src = fetchurl {
        url = "https://github.com/ELEGOO-3D/ElegooSlicer/releases/download/v1.3.0.11/ElegooSlicer_Linux_Ubuntu2404_V1.3.0.11.AppImage";
        sha256 = "1j30fdxdrj86p9fr54g3j6h1rnqy0c2h89w1spl9h58hrj0vag2w";
      };
      extraPkgs = pkgs: [
        pkgs.webkitgtk_4_1
        pkgs.gtk3
      ];
    })
  ];
}
