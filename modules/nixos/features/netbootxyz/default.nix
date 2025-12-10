# modules/nixos/features/netbootxyz/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.netbootxyz;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.netbootxyz = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'netbootxyz', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    boot.loader.systemd-boot.netbootxyz.enable = true;
  };
}
