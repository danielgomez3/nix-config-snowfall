# x86-64-uefi-boot.nix
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
  cfg = config.profiles.${namespace}.my.nixos.bundles.x86-64-uefi-boot;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.bundles.x86-64-uefi-boot = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'bundles', of module 'x86-64-uefi-boot', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.nixos = {
      features = {
        systemd-boot = enabled;
        silent-boot = enabled;
      };
    };
    # profiles.${namespace}.my.home = {
    # };
  };
}
