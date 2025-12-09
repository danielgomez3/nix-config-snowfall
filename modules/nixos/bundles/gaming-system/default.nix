# gaming-system.nix
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
  cfg = config.profiles.${namespace}.my.nixos.bundles.gaming-system;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.bundles.gaming-system = {
    enable = mkEnableOption "Enable custom 'nixos', module 'gaming-system', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
