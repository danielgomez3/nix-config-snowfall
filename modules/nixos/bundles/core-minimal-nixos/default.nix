# core-minimal-nixos.nix
{
  lib,
  pkgs,
  inputs,
  namespace,
  system,
  target,
  format,
  virtual,
  systems,
  config,
  ...
}: let
  cfg = config.profiles.${namespace}.my.nixos.bundles.core-minimal-nixos;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.bundles.core-minimal-nixos = {
    enable = mkEnableOption "Enable custom module for platform 'nixos', of category 'bundles', of module 'core-minimal-nixos', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.nixos = {
      # bundles = {
      # };
      features = {
        myVars.enable = true; # TODO: think about making this inside of base-config.nix
        base-nixos-config.enable = true;
      };
      # programs = {
      #   plex.enable = true;
      # };
    };
  };
}
