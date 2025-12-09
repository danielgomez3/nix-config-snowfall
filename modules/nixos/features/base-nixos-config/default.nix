# base-nixos-config.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.base-nixos-config;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.base-nixos-config = {
    enable = mkEnableOption "Enable custom module for platform 'nixos', of category 'features', of module 'base-nixos-config', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    system.stateVersion = "25.11";
  };
}
