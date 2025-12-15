# modules/nixos/features/embedded-dev-environment/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.embedded-dev-environment;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.embedded-dev-environment = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'embedded-dev-environment', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    environment.systemPackages = [pkgs.platformio-core pkgs.openocd];
  };
}
