# xxmodulenamexx.nix
{
  config,
  lib,
  system,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.profiles.${namespace}.nixos.cli.plex;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.nixos.cli.plex = {
    enable = mkEnableOption "Enable custom 'nixos' module 'plex' for namespace '${namespace}'";
  };
  config = mkIf cfg.enable {
    services.plex = {
      enable = true;
      openFirewall = true;
      # user = "${config.myVars.username}";
      # dataDir = "/home/${username}/plex";
    };
  };
}
