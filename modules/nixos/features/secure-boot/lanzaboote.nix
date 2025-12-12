# modules/nixos/features/secure-boot/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.secure-boot;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.secure-boot = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'secure-boot', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    services.fwupd.enable = true; # keep system firwmare up to date.
  };
}
