# rclone.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.rclone;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.programs.rclone = {
    enable = mkEnableOption "Enable custom 'home', module 'rclone', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {

  programs.rclone = {
    enable = true;
    remotes.daniel-new-remote = {
      config = {
        type = "drive";
        # drive_type = "business";
      };
      secrets = {
        # FIXME: the secret isn't deploying
        token = osConfig.sops.secrets."google_drive/token".path;
      };
    };
  };
    # profiles.${namespace}.my = {
    #   nixos = {
    #     bundles = {
    #     };
    #     features = {
    #     };
    #     programs = {
    #     };
    #   };
    #   home = {
    #     bundles = {
    #     };
    #     features = {
    #     };
    #     programs = {
    #     };
    #   };
    # };
  };
}
