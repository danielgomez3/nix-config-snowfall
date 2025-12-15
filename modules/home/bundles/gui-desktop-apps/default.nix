# modules/home/bundles/gui-desktop-apps/default.nix
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
  cfg = config.profiles.${namespace}.my.home.bundles.gui-desktop-apps;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.bundles.gui-desktop-apps = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'bundles', of module 'gui-desktop-apps', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    profiles.${namespace}.my.home = {
      features = {
        gui-desktop-pkgs = enabled;
      };
      programs = {
        wezterm = enabled;
        kitty = enabled;
        zathura = enabled;
        obs-studio = enabled;
        kdeconnect = enabled;
        thunderbird = enabled;
        zed = enabled;
      };
    };
  };
}
