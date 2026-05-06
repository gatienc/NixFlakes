{ pkgs, ... }:
{
  # Enable nix-ld for dynamically linked binaries
  programs.nix-ld.enable = true;

  # Libraries available system-wide for dynamically linked executables
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    expat
    gdal
    proj
    geos
    libxml2
    libspatialite
    sqlite
    libtiff
    libjpeg
    libpng
    openssl
    curl
    hdf5
    netcdf
  ];

  # Environment variables for Python geospatial packages
  environment.sessionVariables = {
    GDAL_LIBRARY_PATH = "${pkgs.gdal}/lib/libgdal.so";
    GEOS_LIBRARY_PATH = "${pkgs.geos}/lib/libgeos_c.so";
    PROJ_LIB = "${pkgs.proj}/share/proj";
  };
}
