# raw-image-config.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.raw-image-config;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.raw-image-config = {
    enable = mkEnableOption "Enable custom 'nixos', module 'raw-image-config', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
