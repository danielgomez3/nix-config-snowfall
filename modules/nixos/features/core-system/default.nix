# core-system.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.core-system;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.core-system = {
    enable = mkEnableOption "Enable custom 'nixos', module 'core-system', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
