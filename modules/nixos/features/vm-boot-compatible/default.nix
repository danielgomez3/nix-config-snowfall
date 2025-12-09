# vm-boot-compatible.nix
# NOTE
# This allows any host to be able to boot into a VM and login.
# Transfers age keys, etc.
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
  cfg = config.profiles.${namespace}.my.nixos.features.vm-boot-compatible;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.vm-boot-compatible = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'vm-boot-compatible', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    virtualisation.vmVariant = {
      virtualisation.sharedDirectories = {
        keys = {
          source = "/home/${config.myVars.username}/.config/sops/age";
          target = "/root/.config/sops/age";
        };
      };
    };
  };
}
