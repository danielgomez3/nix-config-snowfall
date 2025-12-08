# programs/default.nix
{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.profiles.${namespace}.my.nixos.programs.plex;
in {
  options.profiles.${namespace}.my.nixos.programs.plex = {
    enable = lib.mkEnableOption "Enable custom 'home' module 'plex' for namespace '${namespace}'";
  };

  imports = lib.${namespace}.autoImportNamedFiles ./.;
}
