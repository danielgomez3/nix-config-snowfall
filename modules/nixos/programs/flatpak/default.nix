# modules/nixos/programs/flatpak/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.flatpak;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.programs.flatpak = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'flatpak', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    # dep
    xdg.portal.enable = true;
    # xdg.portal.extraPortals =;;
  };
}
