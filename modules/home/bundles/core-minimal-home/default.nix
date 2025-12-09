# core-minimal-home.nix
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
  cfg = config.profiles.${namespace}.my.home.bundles.core-minimal-home;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.bundles.core-minimal-home = {
    enable = mkEnableOption "Enable custom module for platform 'home', of category 'bundles', of module 'core-minimal-home', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.home = {
      # bundles = {
      #   core-minimal-home = enabled;
      # };
      features = {
        base-home-config.enable = true;
      };
      # programs = {
      # };
    };
  };
}
