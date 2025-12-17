# modules/nixos/programs/plex/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.plex;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.programs.plex = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'plex', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # assertions = [{assertion = true; message = "";}];

    services.plex = {
      enable = true;
      openFirewall = true;
      user = "${config.myVars.username}";
      # dataDir = "/home/${username}/plex";
    };
  };
}
