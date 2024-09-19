let
  pyprland = pkgs.pyprland.overrideAttrs {
    version = "your-version-here";
    src = fetchFromGitHub {
      owner = "hyprland-community";
      repo = "pyprland";
      rev = "tag-or-revision";
      # leave empty for the first time, add the new hash from the error message
      hash = "";
    };
  };
in
{
  # add the overridden package to systemPackages
  environment.systemPackages = [ pyprland ];
}
