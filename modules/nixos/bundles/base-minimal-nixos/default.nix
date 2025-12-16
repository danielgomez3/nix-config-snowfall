# base-minimal-nixos.nix
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
  cfg = config.profiles.${namespace}.my.nixos.bundles.base-minimal-nixos;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.bundles.base-minimal-nixos = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'bundles', of module 'base-minimal-nixos', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.nixos = {
      # bundles = {
      # };
      features = {
        myVars = enabled; # TODO: think about making this inside of base-config.nix
        base-nixos-config = enabled;
        vm-boot-compatible = enabled;
      };
      programs = {
        openssh = enabled;
        sops = enabled;
        stylix = enabled;
      };
    };
  };
}
