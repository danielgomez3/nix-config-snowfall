# gui-apps.nix
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
  cfg = config.profiles.${namespace}.my.home.bundles.gui-apps;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.bundles.gui-apps = {
    enable = mkEnableOption "Enable custom 'home', module 'gui-apps', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.home = {
      bundles = {
      };
      features = {
      };
      programs = {
        wezterm.enable = true;
        kitty.enable = true;
        zathura.enable = true;
        obs-studio.enable = true;
        kdeconnect.enable = true;
        firefox.enable = false;
        mangohud.enable = true;
        thunderbird.enable = true;
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
