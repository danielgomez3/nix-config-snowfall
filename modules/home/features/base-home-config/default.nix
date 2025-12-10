# base-home-config.nix
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
  cfg = config.profiles.${namespace}.my.home.features.base-home-config;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.features.base-home-config = {
    enable = mkEnableOption "Enable custom module for platform 'home', of category 'features', of module 'base-home-config', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    home.stateVersion = "24.05";
    home.activationGenerateGcRoot = false; # HACK: VM wouldn't use home manager, this fixed it. Look up why!
  };
}
