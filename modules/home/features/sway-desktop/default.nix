# sway-desktop.nix
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
  cfg = config.profiles.${namespace}.my.home.features.sway-desktop;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.features.sway-desktop = {
    enable = mkEnableOption "Enable custom 'home', module 'sway-desktop', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.home = {
      bundles = {
      };
      features = {
      };
      programs = {
        sway.enable = false;
        swayidle.enable = false;
        dunst.enable = false; # Wayland notifications
        wayland-pipewire-idle-inhibit.enable = false;
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
