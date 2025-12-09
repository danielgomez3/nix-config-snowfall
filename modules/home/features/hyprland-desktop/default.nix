# hyprland-desktop.nix
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
  cfg = config.profiles.${namespace}.my.home.features.hyprland-desktop;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.features.hyprland-desktop = {
    enable = mkEnableOption "Enable custom 'home', module 'hyprland-desktop', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.home = {
      bundles = {
      };
      features = {
      };
      programs = {
        hyprland.enable = true;
      };
    };
    # profiles.${namespace}.my.nixos = {
    #   bundles = {
    #   };
    #   features = {
    #   };
    #   programs = {
    #   };
    # };
  };
}
