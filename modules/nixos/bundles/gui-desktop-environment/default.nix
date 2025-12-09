# gui-desktop-environment.nix
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
  cfg = config.profiles.${namespace}.my.nixos.bundles.gui-desktop-environment;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.bundles.gui-desktop-environment = {
    enable = mkEnableOption "Enable custom module for platform 'nixos', of category 'bundles', of module 'gui-desktop-environment', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.nixos = {
      programs = {
        gnome.enable = true;
      };
    };
  };
}
