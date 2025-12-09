# my-cosmic-manager-settings.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.my-cosmic-manager-settings;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.my-cosmic-manager-settings = {
    enable = mkEnableOption "Enable custom 'nixos', module 'my-cosmic-manager-settings', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.home = {
      bundles = {
      };
      features = {
      };
      programs = {
      };
    };
    profiles.${namespace}.my.nixos = {
      bundles = {
      };
      features = {
      };
      programs = {
      };
    };
  };
}
