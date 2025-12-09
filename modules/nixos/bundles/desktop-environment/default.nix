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
  cfg = config.profiles.${namespace}.my.nixos.bundles.desktop-environment;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.bundles.desktop-environment = {
    enable = mkEnableOption "Enable custom 'nixos', module 'desktop-environment', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.nixos = {
      bundles = {
      };
      features = {
        gui-apps.enable = true;
        music.enable = true;
        gnome.enable = true;
        cosmic-desktop.enable = true;
        printing.enable = true;
      };
      programs = {
      };
    };
    profiles.${namespace}.my.home = {
      bundles = {
        desktop-environment.enable = true;
      };
      features = {
      };
      programs = {
      };
    };
  };
}
