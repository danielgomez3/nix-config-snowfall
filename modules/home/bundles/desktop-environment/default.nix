# desktop-environment.nix
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
  cfg = config.profiles.${namespace}.my.home.bundles.desktop-environment;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.bundles.desktop-environment = {
    enable = mkEnableOption "Enable custom 'home', module 'desktop-environment', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.home = {
      bundles = {
        # gui-apps.enable = true;
        # sway-desktop.enable = true;
        # zed.enable = true;
      };
      features = {
      };
      programs = {
      };
    };
  };
}
