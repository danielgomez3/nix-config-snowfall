# gui-desktop-environment.nix
# NOTE
# for non-nix machines only!
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
  cfg = config.profiles.${namespace}.my.home.bundles.gui-desktop-environment;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.bundles.gui-desktop-environment = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'bundles', of module 'gui-desktop-environment', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
  };
}
