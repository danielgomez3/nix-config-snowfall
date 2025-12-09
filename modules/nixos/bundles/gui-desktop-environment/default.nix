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
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.bundles.gui-desktop-environment = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'bundles', of module 'gui-desktop-environment', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.nixos = {
      programs = {
        gnome = enabled;
      };
    };
  };
}
