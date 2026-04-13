{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    gvfs
    libmtp
    foliate
  ];
}
