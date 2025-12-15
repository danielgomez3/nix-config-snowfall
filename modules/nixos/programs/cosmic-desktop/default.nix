# modules/nixos/programs/cosmic-desktop/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.cosmic-desktop;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.programs.cosmic-desktop = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'cosmic-desktop', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # Enable the COSMIC login manager
    services.displayManager.cosmic-greeter.enable = true;
    # Enable the COSMIC desktop environment
    services.desktopManager.cosmic.enable = true;
    # NOTE: security issue, enables all windows clipboard access. This is pragmatic.
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
  };
}
