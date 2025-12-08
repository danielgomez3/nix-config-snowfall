# plex.nix
{
  config,
  lib,
  system,
  inputs,
  namespace,
  pkgs,
  ...
}: let
in {
  services.plex = {
    enable = true;
    openFirewall = true;
    user = "${config.myVars.username}";
    # dataDir = "/home/${username}/plex";
  };
}
