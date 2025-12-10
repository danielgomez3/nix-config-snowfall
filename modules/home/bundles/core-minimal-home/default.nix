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
  inherit (lib.${namespace}) enabled;
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
        base-home-config = enabled;
        persistence = enabled;
      };
      # programs = {
      # };
    };
  };
}
