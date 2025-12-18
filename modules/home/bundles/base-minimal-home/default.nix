# base-minimal-home.nix
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
  cfg = config.profiles.${namespace}.my.home.bundles.base-minimal-home;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;
in {
  options.profiles.${namespace}.my.home.bundles.base-minimal-home = {
    enable = mkEnableOption "Enable custom module for platform 'home', of category 'bundles', of module 'base-minimal-home', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.home = {
      features = {
        base-home-config = enabled;
        base-home-pkgs = enabled;
      };
      programs = {
        zsh = enabled;
        starship = enabled;
        ssh = enabled;
        git = enabled;
        neovim = enabled;
        zellij = enabled;
        btop = enabled;
        eza = enabled;
        zoxide = enabled;
      };
    };
  };
}
