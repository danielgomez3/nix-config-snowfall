# cli-apps.nix
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
  cfg = config.profiles.${namespace}.my.home.features.cli-apps;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.features.cli-apps = {
    enable = mkEnableOption "Enable custom 'home', module 'cli-apps', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.home = {
      bundles = {
      };
      features = {
      };
      programs = {
        zsh.enable = true;
        nushell.enable = false;
        starship.enable = true;
        ssh.enable = true;
        git.enable = true;
        neovim.enable = true;
        zellij.enable = true;
        rclone.enable = true;
        btop.enable = true;
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
