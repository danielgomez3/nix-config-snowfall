# modules/home/features/cosmic-desktop-manager/default.nix
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
  cfg = config.profiles.${namespace}.my.home.features.cosmic-desktop-manager;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.features.cosmic-desktop-manager = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'features', of module 'cosmic-desktop-manager', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
  };
}
