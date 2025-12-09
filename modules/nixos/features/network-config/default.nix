# network-config.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.network-config;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.network-config = {
    enable = mkEnableOption "Enable custom 'nixos', module 'network-config', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
