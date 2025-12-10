# modules/home/programs/rclone/default.nix
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
  osConfig,
  ...
}: let
  cfg = config.profiles.${namespace}.my.home.programs.rclone;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.programs.rclone = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'programs', of module 'rclone', for namespace '${namespace}'.";
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
  };
}
