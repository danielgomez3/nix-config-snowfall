# pc-boot.nix
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
  cfg = config.profiles.${namespace}.my.nixos.bundles.pc-boot;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.bundles.pc-boot = {
    enable = mkEnableOption "Enable custom 'nixos', module 'pc-boot', for namespace '${namespace}'.";
  };
  config =
    mkIf cfg.enable {
    };
}
